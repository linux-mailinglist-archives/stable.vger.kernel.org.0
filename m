Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B0365D9A5
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbjADQ0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239796AbjADQ0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:26:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C246333D4A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:26:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74B53B817B7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36B0C433D2;
        Wed,  4 Jan 2023 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849598;
        bh=42Hu71NTX/QxC2ivMWnlv4Azqa6uLp+RGnpO0frZQF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qkz92Y6pozVCXTAfoV3d6sA6Q6G3u0ruN/hGC/TuysoLgnWFoAMr93rraeSQzOEsK
         pnKB9BN8BbGhvSvV1IeTveY/oGQuXc2xUM0tNZ1hhPYazFI4R8Jrrt19rsHY1CA/ts
         WerrpaA50Jeiy446DvFHlDL46EWEqa2+ZZo31lok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.0 157/177] ext4: fix error code return to user-space in ext4_get_branch()
Date:   Wed,  4 Jan 2023 17:07:28 +0100
Message-Id: <20230104160512.424575606@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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


