Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C69666CD94
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbjAPRhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbjAPRhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:37:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864FD4523F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:13:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2134E60F7C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EFCC433D2;
        Mon, 16 Jan 2023 17:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889213;
        bh=42Hu71NTX/QxC2ivMWnlv4Azqa6uLp+RGnpO0frZQF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=152nYoX6ZnUmc2/hGBGM2vKJTHYOdKAUtldHlZoe4HQBpKieiFkWYCvO/3Qmuwd0E
         V2bv9NSB79nO7zHMP7Ubfb1QueY/6ybS4oU02elkjrOLnbPrJreG64zgUwFBzMwLlc
         DMUCIvvNLN7E8MKeYkRjDyVBEiIJ9wPRddw+y+Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 301/338] ext4: fix error code return to user-space in ext4_get_branch()
Date:   Mon, 16 Jan 2023 16:52:54 +0100
Message-Id: <20230116154834.222962094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Luís Henriques <lhenriques@suse.de>

commit 26d75a16af285a70863ba6a81f85d81e7e65da50 upstream.

If a block is out of range in ext4_get_branch(), -ENOMEM will be returned
to user-space.  Obviously, this error code isn't really useful.  This
patch fixes it by making sure the right error code (-EFSCORRUPTED) is
propagated to user-space.  EUCLEAN is more informative than ENOMEM.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Link: https://lore.kernel.org/r/20221109181445.17843-1-lhenriques@suse.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/indirect.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -148,6 +148,7 @@ static Indirect *ext4_get_branch(struct
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	unsigned int key;
 	int ret = -EIO;
 
 	*err = 0;
@@ -156,7 +157,13 @@ static Indirect *ext4_get_branch(struct
 	if (!p->key)
 		goto no_block;
 	while (--depth) {
-		bh = sb_getblk(sb, le32_to_cpu(p->key));
+		key = le32_to_cpu(p->key);
+		if (key > ext4_blocks_count(EXT4_SB(sb)->s_es)) {
+			/* the block was out of range */
+			ret = -EFSCORRUPTED;
+			goto failure;
+		}
+		bh = sb_getblk(sb, key);
 		if (unlikely(!bh)) {
 			ret = -ENOMEM;
 			goto failure;


