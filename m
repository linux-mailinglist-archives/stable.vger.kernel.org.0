Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E764F6DBA26
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 12:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDHKrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 06:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjDHKrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 06:47:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706631026B;
        Sat,  8 Apr 2023 03:46:24 -0700 (PDT)
Date:   Sat, 08 Apr 2023 10:45:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680950715;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8toMptRbl0YAh2qmk/dW1vdH5vnrI9650hQda4a4V0=;
        b=EdsN/SaK7hU6KX168e0EcRRM1WW+ohT04xMfh/7srQUjAvBCv2cs5k77OFRt521faexs/O
        QYC6IlXDcUpkSgy4MnSmmLDLusKPeFq7PsY5F2v62IEi2bQNWlDUhcrhAnhl+Q4vYDr3aq
        ZAIm2MKCDgRWt201wyTUYTL8bMjihXnEYP0aZAK1Y/8/0QoCkDMIGAnIi1wpw7MO4nw7er
        ewn/Z4y3gsK4b6Sf3wxto0jTrLdP3wcdfwYrRTrpFHmEN3kiYbwnO3iK8b45Cg1iAXI/eO
        Wjyqjy+G+N2CU3S0133auBn2zgDfq1CymT7pNMav/UVpUjlgt/v0Bw33XbLF3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680950715;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8toMptRbl0YAh2qmk/dW1vdH5vnrI9650hQda4a4V0=;
        b=08HVg8MSbBAaCDG65JqNC9/Wia+cKdgmvlSle8z5kS2MKUMMar3sEp116ptBQsSinR8Cpe
        ygESDen4CBT2ZaCg==
From:   "irqchip-bot for Jianmin Lv" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/loongson-pch-pic: Fix
 registration of syscore_ops
Cc:     stable@vger.kernel.org, Jianmin Lv <lvjianmin@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230407083453.6305-5-lvjianmin@loongson.cn>
References: <20230407083453.6305-5-lvjianmin@loongson.cn>
MIME-Version: 1.0
Message-ID: <168095071449.404.65013102195860563.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     c84efbba46901b187994558ee0edb15f7076c9a7
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/c84efbba46901b187994558ee0edb15f7076c9a7
Author:        Jianmin Lv <lvjianmin@loongson.cn>
AuthorDate:    Fri, 07 Apr 2023 16:34:52 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Sat, 08 Apr 2023 11:29:18 +01:00

irqchip/loongson-pch-pic: Fix registration of syscore_ops

When support suspend/resume for loongson-pch-pic, the syscore_ops
is registered twice in dual-bridges machines where there are two
pch-pic IRQ domains. Repeated registration of an same syscore_ops
broke syscore_ops_list, so the patch will corret it.

Fixes: 1ed008a2c331 ("irqchip/loongson-pch-pic: Add suspend/resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-5-lvjianmin@loongson.cn
---
 drivers/irqchip/irq-loongson-pch-pic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 437f1af..64fa67d 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -311,7 +311,8 @@ static int pch_pic_init(phys_addr_t addr, unsigned long size, int vec_base,
 	pch_pic_handle[nr_pics] = domain_handle;
 	pch_pic_priv[nr_pics++] = priv;
 
-	register_syscore_ops(&pch_pic_syscore_ops);
+	if (nr_pics == 1)
+		register_syscore_ops(&pch_pic_syscore_ops);
 
 	return 0;
 
