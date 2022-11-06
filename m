Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC26961E710
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 23:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiKFWwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 17:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiKFWwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 17:52:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D23101CE;
        Sun,  6 Nov 2022 14:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E135DB80D43;
        Sun,  6 Nov 2022 22:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D251C433B5;
        Sun,  6 Nov 2022 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667775154;
        bh=TjmpkjWX9P8hHhPptyAvKB3UAJOnIEmiV1SrLIr0HMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXBl6TrAjAlnwKaZuDZAR+itCHZgqa0Z8t88t8bP6qxyjQN8U+7Oln8DStKlsjDni
         cZWLaB0RTByVv0z0lMYHaZM+5KkigAUkcDKsDKXNCI4RA8avBJtDXUXMKDQs6nSDM3
         1G7pdclFHySOOYwPlgfaP3R/crCKOfQlFS/Yr7woaz2vyn5duEjluJFcfQfyRTQKnM
         v2f6PcamP/5SQH1nfJ+nj+LGz46SPc5sN9bg/c+Xs7CAPNXv3kz7TCTdZINTSydRmr
         9KvAWBct0H7HjIKOHwC61XVK/uqObEELAqrrw8DDTVngw3jcq3vcn8tczcU5wxJoza
         Vu34DlXvgAR3w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/7] ext4: fix leaking uninitialized memory in fast-commit journal
Date:   Sun,  6 Nov 2022 14:48:37 -0800
Message-Id: <20221106224841.279231-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221106224841.279231-1-ebiggers@kernel.org>
References: <20221106224841.279231-1-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@google.com>

When space at the end of fast-commit journal blocks is unused, make sure
to zero it out so that uninitialized memory is not leaked to disk.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index da0c8228cf9c3..1e8be05542396 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -737,6 +737,9 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
 	if (pad_len > 0)
 		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+	/* Don't leak uninitialized memory in the unused last byte. */
+	*((u8 *)(tl + 1) + pad_len) = 0;
+
 	ext4_fc_submit_bh(sb, false);
 
 	ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
@@ -793,6 +796,8 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	dst += sizeof(tail.fc_tid);
 	tail.fc_crc = cpu_to_le32(crc);
 	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	dst += sizeof(tail.fc_crc);
+	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
 	ext4_fc_submit_bh(sb, true);
 
-- 
2.38.1

