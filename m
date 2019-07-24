Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5514073E26
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGXTnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727342AbfGXTnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:43:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8002622ADB;
        Wed, 24 Jul 2019 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997412;
        bh=wANQe52zrBRb4Xw+3bw6crTD8mEUNcXjq3SEyZdmO1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sE7aNix8Sxpt6eoQUAoaIABBGe0T/mtL/ZCDLACEiztyvyl/rjWV60e/sQU2070yS
         T0FI7EetrpHoRl3jXpSo2FCf6LSvVAXWgRWu6zH6Av2gleh5nzjOrwJqn6+i2ekVuZ
         9aH9rpm/uzhbUAnjDkKgh4J0tXkHVs/La7LUkf7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 015/371] wil6210: fix missed MISC mbox interrupt
Date:   Wed, 24 Jul 2019 21:16:07 +0200
Message-Id: <20190724191725.636602465@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7441be71ba7e07791fd4fa2b07c932dff14ff4d9 ]

When MISC interrupt is triggered due to HALP bit, in parallel
to mbox events handling by the MISC threaded IRQ, new mbox
interrupt can be missed in the following scenario:
1. MISC ICR is read in the IRQ handler
2. Threaded IRQ is completed and all MISC interrupts are unmasked
3. mbox interrupt is set by FW
4. HALP is masked
The mbox interrupt in step 3 can be missed due to constant high level
of ICM.
Masking all MISC IRQs instead of masking only HALP bit in step 4
will guarantee that ICM will drop to 0 and interrupt will be triggered
once MISC interrupts will be unmasked.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 3f5bd177d55f..e41ba24011d8 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -580,7 +580,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 			/* no need to handle HALP ICRs until next vote */
 			wil->halp.handle_icr = false;
 			wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
-			wil6210_mask_halp(wil);
+			wil6210_mask_irq_misc(wil, true);
 			complete(&wil->halp.comp);
 		}
 	}
-- 
2.20.1



