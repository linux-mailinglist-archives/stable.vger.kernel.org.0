Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AB0273043
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgIUQgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgIUQgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E141C2396F;
        Mon, 21 Sep 2020 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706183;
        bh=d3XFlJeZ5FcVRMjyET295KfplhHWKUPA6e5DSv4GAcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZODU70kakwOW1R54VkYSPKENQtjUGVTN6wrTGQoYOEIDhw3aGHD3jCbBl8/HgRHhB
         XtMnz3XNxyKtu2JhzPyqmgLEn0h5w58PHrLIu10POiu/xLuL+lptgGS2iEd8Gt812l
         t3F3dDebUJHKAO9PAghF7Ldp7+fqB5qIdIEEwwuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 61/70] MIPS: SNI: Fix spurious interrupts
Date:   Mon, 21 Sep 2020 18:28:01 +0200
Message-Id: <20200921162037.922800381@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit b959b97860d0fee8c8f6a3e641d3c2ad76eab6be ]

On A20R machines the interrupt pending bits in cause register need to be
updated by requesting the chipset to do it. This needs to be done to
find the interrupt cause and after interrupt service. In
commit 0b888c7f3a03 ("MIPS: SNI: Convert to new irq_chip functions") the
function to do after service update got lost, which caused spurious
interrupts.

Fixes: 0b888c7f3a03 ("MIPS: SNI: Convert to new irq_chip functions")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sni/a20r.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/sni/a20r.c b/arch/mips/sni/a20r.c
index f9407e1704762..c6af7047eb0d2 100644
--- a/arch/mips/sni/a20r.c
+++ b/arch/mips/sni/a20r.c
@@ -143,7 +143,10 @@ static struct platform_device sc26xx_pdev = {
 	},
 };
 
-static u32 a20r_ack_hwint(void)
+/*
+ * Trigger chipset to update CPU's CAUSE IP field
+ */
+static u32 a20r_update_cause_ip(void)
 {
 	u32 status = read_c0_status();
 
@@ -205,12 +208,14 @@ static void a20r_hwint(void)
 	int irq;
 
 	clear_c0_status(IE_IRQ0);
-	status = a20r_ack_hwint();
+	status = a20r_update_cause_ip();
 	cause = read_c0_cause();
 
 	irq = ffs(((cause & status) >> 8) & 0xf8);
 	if (likely(irq > 0))
 		do_IRQ(SNI_A20R_IRQ_BASE + irq - 1);
+
+	a20r_update_cause_ip();
 	set_c0_status(IE_IRQ0);
 }
 
-- 
2.25.1



