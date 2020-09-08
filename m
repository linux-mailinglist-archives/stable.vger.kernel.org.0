Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC74261419
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbgIHQEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731138AbgIHQCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8409F24058;
        Tue,  8 Sep 2020 15:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579500;
        bh=BXufkdNKathyKRvjduTt/X7oK/+P/Q1NnuhCpXBoF+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bo3QE109r+1jXtMALC5k3+346BmsxjymqRnr/BC4d3EASScPBhVMpz9Fx54bliBb3
         9kzT2qJ7T6sL9Afl5drWmK7FeCP7QJ5WMa2Zzp89fwn4J4VrUiL4D/CnkZDrcIoVZE
         DaMcGQTO9M6+YMYpRMCxhECAzlk2T74sj9c6wrXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 103/186] MIPS: SNI: Fix SCSI interrupt
Date:   Tue,  8 Sep 2020 17:24:05 +0200
Message-Id: <20200908152246.629306006@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit baf5cb30fbd1c22f6aa03c081794c2ee0f5be4da ]

On RM400(a20r) machines ISA and SCSI interrupts share the same interrupt
line. Commit 49e6e07e3c80 ("MIPS: pass non-NULL dev_id on shared
request_irq()") accidently dropped the IRQF_SHARED bit, which breaks
registering SCSI interrupt. Put back IRQF_SHARED and add dev_id for
ISA interrupt.

Fixes: 49e6e07e3c80 ("MIPS: pass non-NULL dev_id on shared request_irq()")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sni/a20r.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/sni/a20r.c b/arch/mips/sni/a20r.c
index 0ecffb65fd6d1..b09dc844985a8 100644
--- a/arch/mips/sni/a20r.c
+++ b/arch/mips/sni/a20r.c
@@ -222,8 +222,8 @@ void __init sni_a20r_irq_init(void)
 		irq_set_chip_and_handler(i, &a20r_irq_type, handle_level_irq);
 	sni_hwint = a20r_hwint;
 	change_c0_status(ST0_IM, IE_IRQ0);
-	if (request_irq(SNI_A20R_IRQ_BASE + 3, sni_isa_irq_handler, 0, "ISA",
-			NULL))
+	if (request_irq(SNI_A20R_IRQ_BASE + 3, sni_isa_irq_handler,
+			IRQF_SHARED, "ISA", sni_isa_irq_handler))
 		pr_err("Failed to register ISA interrupt\n");
 }
 
-- 
2.25.1



