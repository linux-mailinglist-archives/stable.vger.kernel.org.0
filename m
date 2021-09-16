Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D734440E5CE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbhIPRPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350743AbhIPRMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 043B5619EA;
        Thu, 16 Sep 2021 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810314;
        bh=j61CxPG6IjYyPEc5XcZWmzte+Iu57/UMMkwH+my3scE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzWQVh+seo0GQG7TNS8ltHWn6gnDYPpoAe7tB2UWNoc6nqurIRmaiW/Ln4mfUJsrH
         bjZl+luEvSQ2F7yUycKGOs4loIVjDO692NgFdbjJ2i9HUUSGjSMlJQpUv/slrBxyTr
         KFCzXh1m5UZg+yfkCj3FgE9jVRnuCSI1f9iQx/d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.14 063/432] f2fs: fix to do sanity check for sb/cp fields correctly
Date:   Thu, 16 Sep 2021 17:56:52 +0200
Message-Id: <20210916155812.920065409@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 65ddf6564843890a58ee3b18bb46ce67d96333fb upstream.

This patch fixes below problems of sb/cp sanity check:
- in sanity_check_raw_superi(), it missed to consider log header
blocks while cp_payload check.
- in f2fs_sanity_check_ckpt(), it missed to check nat_bits_blocks.

Cc: <stable@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3217,11 +3217,13 @@ static int sanity_check_raw_super(struct
 		return -EFSCORRUPTED;
 	}
 
-	if (le32_to_cpu(raw_super->cp_payload) >
-				(blocks_per_seg - F2FS_CP_PACKS)) {
-		f2fs_info(sbi, "Insane cp_payload (%u > %u)",
+	if (le32_to_cpu(raw_super->cp_payload) >=
+				(blocks_per_seg - F2FS_CP_PACKS -
+				NR_CURSEG_PERSIST_TYPE)) {
+		f2fs_info(sbi, "Insane cp_payload (%u >= %u)",
 			  le32_to_cpu(raw_super->cp_payload),
-			  blocks_per_seg - F2FS_CP_PACKS);
+			  blocks_per_seg - F2FS_CP_PACKS -
+			  NR_CURSEG_PERSIST_TYPE);
 		return -EFSCORRUPTED;
 	}
 
@@ -3257,6 +3259,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_s
 	unsigned int cp_pack_start_sum, cp_payload;
 	block_t user_block_count, valid_user_blocks;
 	block_t avail_node_count, valid_node_count;
+	unsigned int nat_blocks, nat_bits_bytes, nat_bits_blocks;
 	int i, j;
 
 	total = le32_to_cpu(raw_super->segment_count);
@@ -3387,6 +3390,17 @@ skip_cross:
 		return 1;
 	}
 
+	nat_blocks = nat_segs << log_blocks_per_seg;
+	nat_bits_bytes = nat_blocks / BITS_PER_BYTE;
+	nat_bits_blocks = F2FS_BLK_ALIGN((nat_bits_bytes << 1) + 8);
+	if (__is_set_ckpt_flags(ckpt, CP_NAT_BITS_FLAG) &&
+		(cp_payload + F2FS_CP_PACKS +
+		NR_CURSEG_PERSIST_TYPE + nat_bits_blocks >= blocks_per_seg)) {
+		f2fs_warn(sbi, "Insane cp_payload: %u, nat_bits_blocks: %u)",
+			  cp_payload, nat_bits_blocks);
+		return -EFSCORRUPTED;
+	}
+
 	if (unlikely(f2fs_cp_error(sbi))) {
 		f2fs_err(sbi, "A bug case: need to run fsck");
 		return 1;


