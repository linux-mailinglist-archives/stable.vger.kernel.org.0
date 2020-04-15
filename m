Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F95D1AA279
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441328AbgDOMzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897200AbgDOLhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:37:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3628020768;
        Wed, 15 Apr 2020 11:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950622;
        bh=8qfY1PhpS8YCU7EkMHPLz0aR2nf5Kwu2pnxThzBrBOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCL65ug9NLh5aTp7VSqEZLO5n1BousVTOfJdPqrkYtn3ONBDFStS4Jidvj9ygNG+u
         V3rfUvr3Pz0zCx4Irr3dxc/oWOdpeieI0ijKgWGSuazDlkpjrrFeljLjSgcNINlmSZ
         eYC4EM4FYbe4USRReNvVDRuSg/76mBtsam4WHumA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.6 114/129] f2fs: skip GC when section is full
Date:   Wed, 15 Apr 2020 07:34:29 -0400
Message-Id: <20200415113445.11881-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 2bac07635ddf9ed59268e61e415d8de9c5eaded7 ]

This fixes skipping GC when segment is full in large section.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2f645c591a000..3cced15efebc2 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1018,8 +1018,8 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		 * race condition along with SSR block allocation.
 		 */
 		if ((gc_type == BG_GC && has_not_enough_free_secs(sbi, 0, 0)) ||
-				get_valid_blocks(sbi, segno, false) ==
-							sbi->blocks_per_seg)
+				get_valid_blocks(sbi, segno, true) ==
+							BLKS_PER_SEC(sbi))
 			return submitted;
 
 		if (check_valid_map(sbi, segno, off) == 0)
-- 
2.20.1

