Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952C26B81B6
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 20:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCMTXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 15:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjCMTW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 15:22:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB999193DA
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 12:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61006B81150
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 19:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0604C433EF;
        Mon, 13 Mar 2023 19:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678735363;
        bh=s9909jI5PwXSuuE36ULb/laFF+DVoZkI/RdXPFUQ2sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK9FySCCmxEvOGczqBOv38iepvzRqhpimgLnk0oGakCfF93PX3Q2jugp3oH1bJlDG
         0UNrn2EJ8RlUvaGdeonCKBJ3xBelnyv930vUZUMYMHIg3vYs5rQ7pfm3GwK4XEj1Wz
         +FbsoKQ9yU3w6RXZGNTDu7XZZPSgCj18h5y87iklk+Z3xS2DUrwXriFh173Flm/cuJ
         0b03D/OYJ9+diUCrOcVbjm9FEIYM2eJofS2TXuuQfoOtYzcSfHz+wuZQbT5NLJklll
         SbBKrK4D+Jc7Yyw2wdb2n5dCVHL71Oj10fNkwyHhHucUsnUYQfjiQoV3j9BgIX46na
         RdOMxqNJwBFFQ==
From:   "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sforshee@kernel.org, brauner@kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.1] filelocks: use mount idmapping for setlease permission check
Date:   Mon, 13 Mar 2023 14:22:41 -0500
Message-Id: <20230313192241.3987557-1-sforshee@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167870483012291@kroah.com>
References: <167870483012291@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Forshee <sforshee@kernel.org>

[ Upstream commit 42d0c4bdf753063b6eec55415003184d3ca24f6e ]

A user should be allowed to take out a lease via an idmapped mount if
the fsuid matches the mapped uid of the inode. generic_setlease() is
checking the unmapped inode uid, causing these operations to be denied.

Fix this by comparing against the mapped inode uid instead of the
unmapped uid.

Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Cc: stable@vger.kernel.org
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/locks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 7dc129cc1a26..240b9309ed6d 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1862,9 +1862,10 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!vfsuid_eq_kuid(vfsuid, current_fsuid())) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
-- 
2.39.1

