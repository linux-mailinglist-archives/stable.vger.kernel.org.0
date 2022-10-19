Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02EC604639
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiJSNCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiJSNCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:02:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37448630C;
        Wed, 19 Oct 2022 05:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78E06CE215C;
        Wed, 19 Oct 2022 09:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58610C433D6;
        Wed, 19 Oct 2022 09:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170230;
        bh=Ku35vuD17YGpq0QHl+DAKe80YrZ/0TpL18rzyvhTdJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CagYI3fh6r38FyflXj4TC2rflExuXnvmtp87s4RFxpALov6+hTXxTtKi+6/ZTDQxy
         BqKSEAfhT7Y7Ldx6BNBNHsoxtA6EnRa7Mon5icmMdE0YL/ejB6bxqyfutUsKX1FcD8
         lpa5ar5TOvJIUAc+G9gB1pMe1c36xlk6HL65OSVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 577/862] mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()
Date:   Wed, 19 Oct 2022 10:31:04 +0200
Message-Id: <20221019083315.456426694@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 557244f6284f30613f2d61f14b579303165876c3 ]

In lp8788_irq_init(), if an error occurs after a successful
irq_domain_add_linear() call, it must be undone by a corresponding
irq_domain_remove() call.

irq_domain_remove() should also be called in lp8788_irq_exit() for the same
reason.

Fixes: eea6b7cc53aa ("mfd: Add lp8788 mfd driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/bcd5a72c9c1c383dd6324680116426e32737655a.1659261275.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/lp8788-irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/lp8788-irq.c b/drivers/mfd/lp8788-irq.c
index 348439a3fbbd..39006297f3d2 100644
--- a/drivers/mfd/lp8788-irq.c
+++ b/drivers/mfd/lp8788-irq.c
@@ -175,6 +175,7 @@ int lp8788_irq_init(struct lp8788 *lp, int irq)
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				"lp8788-irq", irqd);
 	if (ret) {
+		irq_domain_remove(lp->irqdm);
 		dev_err(lp->dev, "failed to create a thread for IRQ_N\n");
 		return ret;
 	}
@@ -188,4 +189,6 @@ void lp8788_irq_exit(struct lp8788 *lp)
 {
 	if (lp->irq)
 		free_irq(lp->irq, lp->irqdm);
+	if (lp->irqdm)
+		irq_domain_remove(lp->irqdm);
 }
-- 
2.35.1



