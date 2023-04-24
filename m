Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18D36ECD78
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjDXNXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjDXNXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:23:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF595251
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EC26226E
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27BFC433D2;
        Mon, 24 Apr 2023 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342606;
        bh=MJkxg7SbmdfcO8FSivhsBwp6EJ/QmTRnrAnSk1fzDgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaUhoZXJBtMQC5x6RVxYvxCmAM4S9DeCwhVr9wqbn8cYwD8ZZz9lV6N1BsgY2xPs5
         5YPnhvhbT5Q2foPfTK8uolzmVanLZOUaISJUKn2LgK2rgK3s+H8EGsi8iRA+M/3/X9
         6ExgjmaGxb7gWir4k6/SrC1K+BV6gF4C3vUSBk74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, joneslee@google.com, Tudor Ambarus" 
        <tudor.ambarus@linaro.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.4 28/39] Revert "ext4: fix use-after-free in ext4_xattr_set_entry"
Date:   Mon, 24 Apr 2023 15:17:31 +0200
Message-Id: <20230424131124.118961532@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@linaro.org>

This reverts commit bb8592efcf8ef2f62947745d3182ea05b5256a15 which is
commit 67d7d8ad99beccd9fe92d585b87f1760dc9018e3 upstream.

The order in which patches are queued to stable matters. This patch
has a logical dependency on commit 310c097c2bdbea253d6ee4e064f3e65580ef93ac
upstream, and failing to queue the latter results in a null-ptr-deref
reported at the Link below.

In order to avoid conflicts on stable, revert the commit just so that we
can queue its prerequisite patch first and then queue the same after.

Link: https://syzkaller.appspot.com/bug?extid=d5ebf56f3b1268136afd
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2210,9 +2210,8 @@ int ext4_xattr_ibody_find(struct inode *
 	struct ext4_inode *raw_inode;
 	int error;
 
-	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
+	if (EXT4_I(inode)->i_extra_isize == 0)
 		return 0;
-
 	raw_inode = ext4_raw_inode(&is->iloc);
 	header = IHDR(inode, raw_inode);
 	is->s.base = is->s.first = IFIRST(header);
@@ -2240,9 +2239,8 @@ int ext4_xattr_ibody_inline_set(handle_t
 	struct ext4_xattr_search *s = &is->s;
 	int error;
 
-	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
+	if (EXT4_I(inode)->i_extra_isize == 0)
 		return -ENOSPC;
-
 	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
 	if (error)
 		return error;


