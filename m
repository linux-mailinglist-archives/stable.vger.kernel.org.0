Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0426B13F664
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389266AbgAPTDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbgAPRC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5CA2077B;
        Thu, 16 Jan 2020 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194148;
        bh=ym474XaUAzg8O52I4veViPZJ5pKolRrM+e+R9cUVBp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQgBoH4kgHn/niKQ53i4AaY2d1e7N9ayBDbQ9c73nm6y3wwOk0RucJpD0CcAIiBig
         /1oFoSevypSj1y/SyYmKZxYBMjVA/mRyZ76088jhbizxSdjj4Jy5q+SrHe/oV9WNxW
         R/GDp/E7Q4h7PNbr3KjndSMIE/L3JFCxcya5gxrw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rashmica Gupta <rashmica.g@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 233/671] powerpc/mm: Check secondary hash page table
Date:   Thu, 16 Jan 2020 11:52:22 -0500
Message-Id: <20200116165940.10720-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rashmica Gupta <rashmica.g@gmail.com>

[ Upstream commit 790845e2f12709d273d08ea7a2af7c2593689519 ]

We were always calling base_hpte_find() with primary = true,
even when we wanted to check the secondary table.

mpe: I broke this when refactoring Rashmica's original patch.

Fixes: 1515ab932156 ("powerpc/mm: Dump hash table")
Signed-off-by: Rashmica Gupta <rashmica.g@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/dump_hashpagetable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/dump_hashpagetable.c b/arch/powerpc/mm/dump_hashpagetable.c
index 869294695048..b430e4e08af6 100644
--- a/arch/powerpc/mm/dump_hashpagetable.c
+++ b/arch/powerpc/mm/dump_hashpagetable.c
@@ -342,7 +342,7 @@ static unsigned long hpte_find(struct pg_state *st, unsigned long ea, int psize)
 
 	/* Look in secondary table */
 	if (slot == -1)
-		slot = base_hpte_find(ea, psize, true, &v, &r);
+		slot = base_hpte_find(ea, psize, false, &v, &r);
 
 	/* No entry found */
 	if (slot == -1)
-- 
2.20.1

