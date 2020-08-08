Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA60623FA2E
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHHXku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbgHHXkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:40:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9EC520656;
        Sat,  8 Aug 2020 23:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596930048;
        bh=07OtW7d5134FkJsRUqn7e/OAUYC/AtgYEEoc7+iC8Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhWHbNtHkanpytKos/YLfTJoLOGn1OlM1NcKwmKNrw+ekys1ZppOXaF9WcLHNREQP
         OjXUZXOcvmPDjrgrju3tWYTd2IIb6uzIVv0N6XBYOr+m62BAvBO48t3N/zpdt/0PYw
         +DB+EBCZvqPVZ9Pmz1TI/eIpIaR20hGHFy5tAO+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        Joshua Thompson <funaho@jurai.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 4.9 5/9] m68k: mac: Fix IOP status/control register writes
Date:   Sat,  8 Aug 2020 19:40:32 -0400
Message-Id: <20200808234037.3619732-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808234037.3619732-1-sashal@kernel.org>
References: <20200808234037.3619732-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 931fc82a6aaf4e2e4a5490addaa6a090d78c24a7 ]

When writing values to the IOP status/control register make sure those
values do not have any extraneous bits that will clear interrupt flags.

To place the SCC IOP into bypass mode would be desirable but this is not
achieved by writing IOP_DMAINACTIVE | IOP_RUN | IOP_AUTOINC | IOP_BYPASS
to the control register. Drop this ineffective register write.

Remove the flawed and unused iop_bypass() function. Make use of the
unused iop_stop() function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Cc: Joshua Thompson <funaho@jurai.org>
Link: https://lore.kernel.org/r/09bcb7359a1719a18b551ee515da3c4c3cf709e6.1590880333.git.fthain@telegraphics.com.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/iop.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 8209a74fbdebc..cb516cacc819b 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -173,7 +173,7 @@ static __inline__ void iop_writeb(volatile struct mac_iop *iop, __u16 addr, __u8
 
 static __inline__ void iop_stop(volatile struct mac_iop *iop)
 {
-	iop->status_ctrl &= ~IOP_RUN;
+	iop->status_ctrl = IOP_AUTOINC;
 }
 
 static __inline__ void iop_start(volatile struct mac_iop *iop)
@@ -181,14 +181,9 @@ static __inline__ void iop_start(volatile struct mac_iop *iop)
 	iop->status_ctrl = IOP_RUN | IOP_AUTOINC;
 }
 
-static __inline__ void iop_bypass(volatile struct mac_iop *iop)
-{
-	iop->status_ctrl |= IOP_BYPASS;
-}
-
 static __inline__ void iop_interrupt(volatile struct mac_iop *iop)
 {
-	iop->status_ctrl |= IOP_IRQ;
+	iop->status_ctrl = IOP_IRQ | IOP_RUN | IOP_AUTOINC;
 }
 
 static int iop_alive(volatile struct mac_iop *iop)
@@ -239,7 +234,6 @@ void __init iop_preinit(void)
 		} else {
 			iop_base[IOP_NUM_SCC] = (struct mac_iop *) SCC_IOP_BASE_QUADRA;
 		}
-		iop_base[IOP_NUM_SCC]->status_ctrl = 0x87;
 		iop_scc_present = 1;
 	} else {
 		iop_base[IOP_NUM_SCC] = NULL;
@@ -251,7 +245,7 @@ void __init iop_preinit(void)
 		} else {
 			iop_base[IOP_NUM_ISM] = (struct mac_iop *) ISM_IOP_BASE_QUADRA;
 		}
-		iop_base[IOP_NUM_ISM]->status_ctrl = 0;
+		iop_stop(iop_base[IOP_NUM_ISM]);
 		iop_ism_present = 1;
 	} else {
 		iop_base[IOP_NUM_ISM] = NULL;
-- 
2.25.1

