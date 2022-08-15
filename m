Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA01593BB1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiHOT5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243313AbiHOTxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF6D45F50;
        Mon, 15 Aug 2022 11:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3EEDB810A1;
        Mon, 15 Aug 2022 18:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EBDC433D6;
        Mon, 15 Aug 2022 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589516;
        bh=AJ9Cae9twUPm3oRt+U4Os2vYeJaUHtnMyscaHzAnWyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGvKYFnyM13mz3bm65rT9IyxHfGxxXGOZIQBzABL2bNy0ZT6o61Ci5BvPgGM6icsH
         SqViV+XMDz39vFQvUYwqhLS74bBa+uSxG7XPpfztBdPm7A8JLiLQu5grAwQKStcSFb
         DlTAaihp4zqOD7R0urSZPq9YNigI7gkkW7Inw4so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 743/779] ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h
Date:   Mon, 15 Aug 2022 20:06:27 +0200
Message-Id: <20220815180409.224874033@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 179b14152dcb6a24c3415200603aebca70ff13af ]

When adding an xattr to an inode, we must ensure that the inode_size is
not less than EXT4_GOOD_OLD_INODE_SIZE + extra_isize + pad. Otherwise,
the end position may be greater than the start position, resulting in UAF.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220616021358.2504451-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 77efb9a627ad..f885f362add4 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -95,6 +95,19 @@ struct ext4_xattr_entry {
 
 #define EXT4_ZERO_XATTR_VALUE ((void *)-1)
 
+/*
+ * If we want to add an xattr to the inode, we should make sure that
+ * i_extra_isize is not 0 and that the inode size is not less than
+ * EXT4_GOOD_OLD_INODE_SIZE + extra_isize + pad.
+ *   EXT4_GOOD_OLD_INODE_SIZE   extra_isize header   entry   pad  data
+ * |--------------------------|------------|------|---------|---|-------|
+ */
+#define EXT4_INODE_HAS_XATTR_SPACE(inode)				\
+	((EXT4_I(inode)->i_extra_isize != 0) &&				\
+	 (EXT4_GOOD_OLD_INODE_SIZE + EXT4_I(inode)->i_extra_isize +	\
+	  sizeof(struct ext4_xattr_ibody_header) + EXT4_XATTR_PAD <=	\
+	  EXT4_INODE_SIZE((inode)->i_sb)))
+
 struct ext4_xattr_info {
 	const char *name;
 	const void *value;
-- 
2.35.1



