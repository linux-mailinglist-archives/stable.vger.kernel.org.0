Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEDA594844
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346430AbiHOXhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiHOXeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:34:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0D065645;
        Mon, 15 Aug 2022 13:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4876860B6E;
        Mon, 15 Aug 2022 20:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE09C433C1;
        Mon, 15 Aug 2022 20:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594139;
        bh=QNFvrSfmF8jPkO6xUgA/cBgya04LXm/x8wg9L+Oyn58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dm/cD26K5fi7Fn3wbY4Y1NOttyccfcVsPa7NW6eND7ySTgyCIS6LpSyLLA1Jdq0Ea
         1iItk3WeQyyKWxWhB3Eph7D2Dq9K84kZhCaOVkteJLGhbRXyqInlUWbBYdzr5xsPnp
         rna53rHQlaAnCfa0yl0fHMxX8BNyZ8aGsyHEQc7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lukas Czerner <lczerner@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1062/1095] ext4: make sure ext4_append() always allocates new block
Date:   Mon, 15 Aug 2022 20:07:41 +0200
Message-Id: <20220815180512.959795540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit b8a04fe77ef1360fbf73c80fddbdfeaa9407ed1b ]

ext4_append() must always allocate a new block, otherwise we run the
risk of overwriting existing directory block corrupting the directory
tree in the process resulting in all manner of problems later on.

Add a sanity check to see if the logical block is already allocated and
error out if it is.

Cc: stable@kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20220704142721.157985-2-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2bc3e4b27204..13b6265848c2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -54,6 +54,7 @@ static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
 					ext4_lblk_t *block)
 {
+	struct ext4_map_blocks map;
 	struct buffer_head *bh;
 	int err;
 
@@ -63,6 +64,21 @@ static struct buffer_head *ext4_append(handle_t *handle,
 		return ERR_PTR(-ENOSPC);
 
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
+	map.m_lblk = *block;
+	map.m_len = 1;
+
+	/*
+	 * We're appending new directory block. Make sure the block is not
+	 * allocated yet, otherwise we will end up corrupting the
+	 * directory.
+	 */
+	err = ext4_map_blocks(NULL, inode, &map, 0);
+	if (err < 0)
+		return ERR_PTR(err);
+	if (err) {
+		EXT4_ERROR_INODE(inode, "Logical block already allocated");
+		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	bh = ext4_bread(handle, inode, *block, EXT4_GET_BLOCKS_CREATE);
 	if (IS_ERR(bh))
-- 
2.35.1



