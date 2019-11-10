Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0937BF633D
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfKJCul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728726AbfKJCul (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D72A622583;
        Sun, 10 Nov 2019 02:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354240;
        bh=Dy0nQHLC0EG49p21cGnkSnEVhDvhAHZJBiKFNBod/08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJpSugLXN5G2uPj4yN3XyJm0hTyO8L3e/czfrpfs6oqNqepleeDyg52DvIX4UuYcW
         MLKIhGXqEkvuiJNotIilkJGSzwQMKQLD1wIJqq6y9ahVAQc5cbapW87X8lTUjt9p8A
         FZbvx2QvhKcjwbtPiBcQxrJPxz5yAYBBcAiujh1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 05/40] powerpc/64s/hash: Fix stab_rr off by one initialization
Date:   Sat,  9 Nov 2019 21:49:57 -0500
Message-Id: <20191110025032.827-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 309027208f7c0..27f00a7c1085f 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -322,7 +322,7 @@ void slb_initialize(void)
 #endif
 	}
 
-	get_paca()->stab_rr = SLB_NUM_BOLTED;
+	get_paca()->stab_rr = SLB_NUM_BOLTED - 1;
 
 	lflags = SLB_VSID_KERNEL | linear_llp;
 	vflags = SLB_VSID_KERNEL | vmalloc_llp;
-- 
2.20.1

