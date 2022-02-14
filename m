Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D5B4B49DC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344526AbiBNKCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345309AbiBNKBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAED13F15;
        Mon, 14 Feb 2022 01:47:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C7A61252;
        Mon, 14 Feb 2022 09:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28535C340E9;
        Mon, 14 Feb 2022 09:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832059;
        bh=0SOO8xkYBZ52xNgcRbuIriuBZKJmD4xqKnRP+PGEuL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GygL/AxUbOJapveWGSu4t7KZ0F5eRoZaT7uahBMaTqWh8xQ4O+Kf6ofEjCv8gVsEi
         wIiH2UVkoU2UW6FK1pqYzCzbfn5EyyUZBGTN7fR1vze49Xs+tjsHO/OjU3Pf/UavtV
         2Xm1hP6rLGwYGFmbe9iyBpmrfeSlNiF65eKePtdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/172] irqchip/realtek-rtl: Service all pending interrupts
Date:   Mon, 14 Feb 2022 10:24:53 +0100
Message-Id: <20220214092507.615736547@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 960dd884ddf5621ae6284cd3a42724500a97ae4c ]

Instead of only servicing the lowest pending interrupt line, make sure
all pending SoC interrupts are serviced before exiting the chained
handler. This adds a small overhead if only one interrupt is pending,
but should prevent rapid re-triggering of the handler.

Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/5082ad3cb8b4eedf55075561b93eff6570299fe1.1641739718.git.sander@svanheule.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 568614edd88f4..50a56820c99bc 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -76,16 +76,20 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct irq_domain *domain;
-	unsigned int pending;
+	unsigned long pending;
+	unsigned int soc_int;
 
 	chained_irq_enter(chip, desc);
 	pending = readl(REG(RTL_ICTL_GIMR)) & readl(REG(RTL_ICTL_GISR));
+
 	if (unlikely(!pending)) {
 		spurious_interrupt();
 		goto out;
 	}
+
 	domain = irq_desc_get_handler_data(desc);
-	generic_handle_domain_irq(domain, __ffs(pending));
+	for_each_set_bit(soc_int, &pending, 32)
+		generic_handle_domain_irq(domain, soc_int);
 
 out:
 	chained_irq_exit(chip, desc);
-- 
2.34.1



