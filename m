Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4762E739B8
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390135AbfGXTnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390475AbfGXTnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:43:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88EEA21873;
        Wed, 24 Jul 2019 19:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997384;
        bh=OoLstCwrj4LwdSUJRZg8bJXqPiWJi3vK9rLCWGtd5fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0mH8cjiwgvFTyODDIEpEq8VZOonm46WMwXwKIrNtdG3UtPizrPfM0H4oXzf2j/rb
         zRHGNbBtnY/5WLhBXGjfmnwqoeb4oN/kCuJ3VSaVuNJKDmDx2aj3j4o0/hw9Stq6XK
         y0LIN4X9jDKcp+7rR7O3/XyN1JVhPJc25n+Ig7Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 391/413] powerpc/powernv/idle: Fix restore of SPRN_LDBAR for POWER9 stop state.
Date:   Wed, 24 Jul 2019 21:21:22 +0200
Message-Id: <20190724191802.842404671@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

commit f5a9e488d62360c91c5770bd55a0b40e419a71ce upstream.

commit 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in C")
reimplemented book3S code to pltform/powernv/idle.c. But when doing so
missed to add the per-thread LDBAR update in the core_woken path of
the power9_idle_stop(). Patch fixes the same.

Fixes: 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in C")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190702105836.26695-1-maddy@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -758,7 +758,6 @@ static unsigned long power9_idle_stop(un
 	mtspr(SPRN_PTCR,	sprs.ptcr);
 	mtspr(SPRN_RPR,		sprs.rpr);
 	mtspr(SPRN_TSCR,	sprs.tscr);
-	mtspr(SPRN_LDBAR,	sprs.ldbar);
 
 	if (pls >= pnv_first_tb_loss_level) {
 		/* TB loss */
@@ -790,6 +789,7 @@ core_woken:
 	mtspr(SPRN_MMCR0,	sprs.mmcr0);
 	mtspr(SPRN_MMCR1,	sprs.mmcr1);
 	mtspr(SPRN_MMCR2,	sprs.mmcr2);
+	mtspr(SPRN_LDBAR,	sprs.ldbar);
 
 	mtspr(SPRN_SPRG3,	local_paca->sprg_vdso);
 


