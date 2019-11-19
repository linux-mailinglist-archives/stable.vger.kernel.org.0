Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F349C1016FC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbfKSFuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729351AbfKSFuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:50:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CC42218BA;
        Tue, 19 Nov 2019 05:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142608;
        bh=hf6SbgIk+yIW9m2bRDW1mfmrsZhGzyXJnxMnuBSim6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Caw5RddBeowK8ozBAPzHn1h3HtrVj33T76ELqLbsIMOsOZeFE7to+RT0e0Ctmzq4F
         20KX0MZuszRlqzAIrLyU0wBy6KgMats00H2Z+RE4++US4o0OSLiAEvYGmb8EdQpx9b
         dsdjFkx5RrH0QrzSKxSmY4InMDwnYlHNyYOrqeoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 140/239] powerpc/64s/hash: Fix stab_rr off by one initialization
Date:   Tue, 19 Nov 2019 06:19:00 +0100
Message-Id: <20191119051331.614202410@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 09b4438db13fa83b6219aee5993711a2aa2a0c64 ]

This causes SLB alloation to start 1 beyond the start of the SLB.
There is no real problem because after it wraps it stats behaving
properly, it's just surprisig to see when looking at SLB traces.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/slb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index 6d9bf014b3e78..2502fe3bfb54a 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -315,7 +315,7 @@ void slb_initialize(void)
 #endif
 	}
 
-	get_paca()->stab_rr = SLB_NUM_BOLTED;
+	get_paca()->stab_rr = SLB_NUM_BOLTED - 1;
 
 	lflags = SLB_VSID_KERNEL | linear_llp;
 	vflags = SLB_VSID_KERNEL | vmalloc_llp;
-- 
2.20.1



