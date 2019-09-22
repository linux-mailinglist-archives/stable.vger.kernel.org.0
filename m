Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82021BA850
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395395AbfIVTCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395390AbfIVTCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:02:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE97C2186A;
        Sun, 22 Sep 2019 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178923;
        bh=BrDoBTenExKjWcM+h6i58GVnPzZrlbh1uQ6q8BdcW50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hrxz5TTJvLGnpL8H5JnaFggvFLjmcqiF55C6zyMIHhW++Dtzn0jE3scdOB2etSoJc
         JTMKeItp6pf0tZgsFOOeh+F9AFcX80VvIgjo83cmmDxXf20aCYus220XeqIma5kHCO
         Ky1az8FBxPxzszbWjmNpcDO/unzoC7V3hs0adxZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Travis <mike.travis@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russ Anderson <russ.anderson@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Thomas Gleixner <tglx@linutronix.de>, allison@lohutok.net,
        andy@infradead.org, armijn@tjaldur.nl, bp@alien8.de,
        dvhart@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        kjlu@umn.edu, platform-driver-x86@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 38/44] x86/platform/uv: Fix kmalloc() NULL check routine
Date:   Sun, 22 Sep 2019 15:00:56 -0400
Message-Id: <20190922190103.4906-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 864b23f0169d5bff677e8443a7a90dfd6b090afc ]

The result of kmalloc() should have been checked ahead of below statement:

	pqp = (struct bau_pq_entry *)vp;

Move BUG_ON(!vp) before above statement.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Hedi Berriche <hedi.berriche@hpe.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russ Anderson <russ.anderson@hpe.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: allison@lohutok.net
Cc: andy@infradead.org
Cc: armijn@tjaldur.nl
Cc: bp@alien8.de
Cc: dvhart@infradead.org
Cc: gregkh@linuxfoundation.org
Cc: hpa@zytor.com
Cc: kjlu@umn.edu
Cc: platform-driver-x86@vger.kernel.org
Link: https://lkml.kernel.org/r/20190905232951.GA28779@LGEARND20B15
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/uv/tlb_uv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3b6ec42718e46..fd2149e8ca0f7 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1784,9 +1784,9 @@ static void pq_init(int node, int pnode)
 
 	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_pq_entry);
 	vp = kmalloc_node(plsize, GFP_KERNEL, node);
-	pqp = (struct bau_pq_entry *)vp;
-	BUG_ON(!pqp);
+	BUG_ON(!vp);
 
+	pqp = (struct bau_pq_entry *)vp;
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_pq_entry *)(((unsigned long)cp >> 5) << 5);
 
-- 
2.20.1

