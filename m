Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B376C17E7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjCTPSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbjCTPRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:17:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCB3A25A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6D8561592
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE86BC4339C;
        Mon, 20 Mar 2023 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325136;
        bh=rvfbTQmx+MYVRFtgyWmcktrV1sAZDMXwHaKtrVLWxfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgm0xAwgjBPNMjX9tmPafo9UgIyqgiHd4F4lXJkZJWQyZoFsfqW1PUAp9PVRImbva
         sWp27ItkhdyS/hMkBtPkYU3cYUFa+P9P4C73KjfX1pM6XBwfO0eAYWNBX8MZhYTl0W
         153WyMS4ub3z2kkJeTeNVMSb6FCR+dsRusXctAuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.10 94/99] attr: add setattr_should_drop_sgid()
Date:   Mon, 20 Mar 2023 15:55:12 +0100
Message-Id: <20230320145447.363902005@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 72ae017c5451860443a16fb2a8c243bff3e396b8 upstream.

[backported to 5.10.y, prior to idmapped mounts]

The current setgid stripping logic during write and ownership change
operations is inconsistent and strewn over multiple places. In order to
consolidate it and make more consistent we'll add a new helper
setattr_should_drop_sgid(). The function retains the old behavior where
we remove the S_ISGID bit unconditionally when S_IXGRP is set but also
when it isn't set and the caller is neither in the group of the inode
nor privileged over the inode.

We will use this helper both in write operation permission removal such
as file_remove_privs() as well as in ownership change operations.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c     |   25 +++++++++++++++++++++++++
 fs/internal.h |    5 +++++
 2 files changed, 30 insertions(+)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,31 @@
 
 #include "internal.h"
 
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(inode, inode->i_gid))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
 /*
  * The logic we want is
  *
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -197,3 +197,8 @@ int sb_init_dio_done_wq(struct super_blo
  */
 int do_statx(int dfd, const char __user *filename, unsigned flags,
 	     unsigned int mask, struct statx __user *buffer);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(const struct inode *inode);


