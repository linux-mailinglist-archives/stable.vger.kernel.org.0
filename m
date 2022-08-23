Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58D059D9DE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351757AbiHWKD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352243AbiHWKB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4588F6FA21;
        Tue, 23 Aug 2022 01:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEEF9B81BF8;
        Tue, 23 Aug 2022 08:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F70C433C1;
        Tue, 23 Aug 2022 08:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244546;
        bh=X80genjRvM2BQRqho1Zf4KlpLP+VqAoEYc/fqf6UN7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgfJzE0fVZUaOJyJqRc0kkKkWNPsrd65BcMekk05FqYIhE3VHWgC/IkbDhkFcVKup
         hnXhT2JloLeYZulHGWvJJJeYTsh276H1GzJadE6PkE5WpdACvFCEs/8QwTsRz31cJB
         jipgwTVXfYClF+yuevvjlFotgG7zBTa/D7ctjnJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lukas Czerner <lczerner@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 153/229] ext4: make sure ext4_append() always allocates new block
Date:   Tue, 23 Aug 2022 10:25:14 +0200
Message-Id: <20220823080059.141504689@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
@@ -52,6 +52,7 @@ static struct buffer_head *ext4_append(h
 					struct inode *inode,
 					ext4_lblk_t *block)
 {
+	struct ext4_map_blocks map;
 	struct buffer_head *bh;
 	int err;
 
@@ -61,6 +62,21 @@ static struct buffer_head *ext4_append(h
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


