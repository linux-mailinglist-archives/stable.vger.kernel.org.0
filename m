Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BDD593C11
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbiHOT5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345684AbiHOTzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:55:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6568975FD3;
        Mon, 15 Aug 2022 11:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5D961019;
        Mon, 15 Aug 2022 18:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613FFC433D6;
        Mon, 15 Aug 2022 18:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589534;
        bh=RPFvDBopYVsLgn+huv5j8AZAu+3Kbq4r/71DAohIOE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccvQC8sHTUwJfgm7P6nKUA79KdcozmU9VUUuxrekJr/ruXFqQlkHu0L0NKh/WkSu8
         28JII4MOod/cbB2Isak6COilOzyMKsSv5IhLQZvAEnSPHBmdyLucoL+Fsh0cQwFWPJ
         6LfBvvBKcb/UDLGPeh5X96Nic4ZZ5S0zaKWP0sY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 748/779] ext4: check if directory block is within i_size
Date:   Mon, 15 Aug 2022 20:06:32 +0200
Message-Id: <20220815180409.450413762@linuxfoundation.org>
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

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit 65f8ea4cd57dbd46ea13b41dc8bac03176b04233 ]

Currently ext4 directory handling code implicitly assumes that the
directory blocks are always within the i_size. In fact ext4_append()
will attempt to allocate next directory block based solely on i_size and
the i_size is then appropriately increased after a successful
allocation.

However, for this to work it requires i_size to be correct. If, for any
reason, the directory inode i_size is corrupted in a way that the
directory tree refers to a valid directory block past i_size, we could
end up corrupting parts of the directory tree structure by overwriting
already used directory blocks when modifying the directory.

Fix it by catching the corruption early in __ext4_read_dirblock().

Addresses Red-Hat-Bugzilla: #2070205
CVE: CVE-2022-1184
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20220704142721.157985-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 871eebf12bf4..ac0b7e53591f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -110,6 +110,13 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
+	if (block >= inode->i_size) {
+		ext4_error_inode(inode, func, line, block,
+		       "Attempting to read directory block (%u) that is past i_size (%llu)",
+		       block, inode->i_size);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	if (ext4_simulate_fail(inode->i_sb, EXT4_SIM_DIRBLOCK_EIO))
 		bh = ERR_PTR(-EIO);
 	else
-- 
2.35.1



