Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2C659E085
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355166AbiHWKoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356452AbiHWKmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:42:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44851A99E7;
        Tue, 23 Aug 2022 02:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65AF5B81C85;
        Tue, 23 Aug 2022 09:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D119AC433D6;
        Tue, 23 Aug 2022 09:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245781;
        bh=39fLYJxgTa/5WNl2rQh5djoofFlwSo/C1iad9b3gn18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCMz0Ke/u89Gm3B6IectXTPUVAKN9e0SKtAOXP1P54CaESaqub+vOAmjjLdzwFrec
         acUJxcLvbWYbu9jngMPMxtTHFANb0Qdx9d4e7JuhcN1wUH6Wwa983fvV23Ko5fkcbD
         Cm1DvFhsdSitpXqi2NhtufIuxfNhD5Gq2CKMiADI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lukas Czerner <lczerner@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 188/287] ext4: make sure ext4_append() always allocates new block
Date:   Tue, 23 Aug 2022 10:25:57 +0200
Message-Id: <20220823080107.141743747@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

commit b8a04fe77ef1360fbf73c80fddbdfeaa9407ed1b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -53,6 +53,7 @@ static struct buffer_head *ext4_append(h
 					struct inode *inode,
 					ext4_lblk_t *block)
 {
+	struct ext4_map_blocks map;
 	struct buffer_head *bh;
 	int err;
 
@@ -62,6 +63,21 @@ static struct buffer_head *ext4_append(h
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


