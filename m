Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD74660A44D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiJXMHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiJXMFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8EB7E30A;
        Mon, 24 Oct 2022 04:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25261612C3;
        Mon, 24 Oct 2022 11:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3718AC433D7;
        Mon, 24 Oct 2022 11:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612297;
        bh=+IJfdwQZHLdBxmVW+3yGX0T13fs3Qxpi0bql/8osMgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDGnHXHeSXslOuUXAxG0RV8jUwi3qHLEdq5x+AHsostU55LPP6H3xFzKwMoc9L2je
         fJttDwJmKT1b8uU4MVEXuuHhK+aRhAF36r2BuHyfkMdlTcmjJgUe5ceheO+j8CNYSE
         Kenkytqlbit3eQ6/XBzvWDUrU3yJG8f6RBXJHnJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 145/210] mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()
Date:   Mon, 24 Oct 2022 13:31:02 +0200
Message-Id: <20221024113001.678082256@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 792d51bae20f..ae65928f35f0 100644
--- a/drivers/mfd/lp8788-irq.c
+++ b/drivers/mfd/lp8788-irq.c
@@ -179,6 +179,7 @@ int lp8788_irq_init(struct lp8788 *lp, int irq)
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				"lp8788-irq", irqd);
 	if (ret) {
+		irq_domain_remove(lp->irqdm);
 		dev_err(lp->dev, "failed to create a thread for IRQ_N\n");
 		return ret;
 	}
@@ -192,4 +193,6 @@ void lp8788_irq_exit(struct lp8788 *lp)
 {
 	if (lp->irq)
 		free_irq(lp->irq, lp->irqdm);
+	if (lp->irqdm)
+		irq_domain_remove(lp->irqdm);
 }
-- 
2.35.1



