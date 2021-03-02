Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7C432AF9B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbhCCA1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:27:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350691AbhCBMX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5B7764FA5;
        Tue,  2 Mar 2021 11:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686325;
        bh=/Fw9ccn6NgJqj2TQu4mdRDduD3G3tdF7qP5XJR3ZUww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkwBFiJkKOGY3CwPS8upqpJd5AIgign1mSdmmIvL1nLCPj0ZKE/2ADv9ACuPX77Mx
         oDZ46LLVrc7gvMcf2+MpE93GB63RXN1ISVpxJZEhgh8coY1Ht1wYy1zLx7NTDCarcL
         co2W3a09rHDBD7lVUOuokfY/vvs/dYPO6C/Hh0hkPtdYydyV03qvSFi2P6J7pMsOar
         RsGwa3c9fVWC00zWU+IRB5H2o8kJjXHbAfmhvi7OTZ5ApAGACq9yoia9kUYkpGzEh5
         heXQk2vl43Zl+AxSxvXjy7aPj2PoPMyIO9AfOePgUMMHZY19S78MYN3vRZpOIcnihE
         TY5jDX8pNAoEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 07/21] powerpc: improve handling of unrecoverable system reset
Date:   Tue,  2 Mar 2021 06:58:21 -0500
Message-Id: <20210302115835.63269-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115835.63269-1-sashal@kernel.org>
References: <20210302115835.63269-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 11cb0a25f71818ca7ab4856548ecfd83c169aa4d ]

If an unrecoverable system reset hits in process context, the system
does not have to panic. Similar to machine check, call nmi_exit()
before die().

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210130130852.2952424-26-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 1b2d84cb373b..2379c4bf3979 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -433,8 +433,11 @@ out:
 		die("Unrecoverable nested System Reset", regs, SIGABRT);
 #endif
 	/* Must die if the interrupt is not recoverable */
-	if (!(regs->msr & MSR_RI))
+	if (!(regs->msr & MSR_RI)) {
+		/* For the reason explained in die_mce, nmi_exit before die */
+		nmi_exit();
 		die("Unrecoverable System Reset", regs, SIGABRT);
+	}
 
 	if (!nested)
 		nmi_exit();
-- 
2.30.1

