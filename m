Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE68027C9C7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbgI2MNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F37623B8C;
        Tue, 29 Sep 2020 11:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379275;
        bh=gIhC3ilpTfqrolrhepjUWk2QSeVf3R4QWY5CuNHCfWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlJ0xR2diA5KmVNkq9VQfOPOYN7IjC5s84noxa/q3Ws8790M5MGC+IZk7EowLbAXV
         vnYIkiEWYTgUnVfKeG1amc+0epxSPZ2UnrqyipLdi4W734J8eRyYfboXznt+uJSxs7
         m7Rz5lXm7GyktDlnbI0Wz6gyP3Cm8hEWTflcpBjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ramon Pantin <pantin@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/388] f2fs: stop GC when the victim becomes fully valid
Date:   Tue, 29 Sep 2020 12:56:32 +0200
Message-Id: <20200929110013.450442750@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 803e74be04b32f7785742dcabfc62116718fbb06 ]

We must stop GC, once the segment becomes fully valid. Otherwise, it can
produce another dirty segments by moving valid blocks in the segment partially.

Ramon hit no free segment panic sometimes and saw this case happens when
validating reliable file pinning feature.

Signed-off-by: Ramon Pantin <pantin@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e611d768efde3..a78aa5480454f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1012,8 +1012,14 @@ next_step:
 		block_t start_bidx;
 		nid_t nid = le32_to_cpu(entry->nid);
 
-		/* stop BG_GC if there is not enough free sections. */
-		if (gc_type == BG_GC && has_not_enough_free_secs(sbi, 0, 0))
+		/*
+		 * stop BG_GC if there is not enough free sections.
+		 * Or, stop GC if the segment becomes fully valid caused by
+		 * race condition along with SSR block allocation.
+		 */
+		if ((gc_type == BG_GC && has_not_enough_free_secs(sbi, 0, 0)) ||
+				get_valid_blocks(sbi, segno, false) ==
+							sbi->blocks_per_seg)
 			return submitted;
 
 		if (check_valid_map(sbi, segno, off) == 0)
-- 
2.25.1



