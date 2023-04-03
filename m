Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE91F6D48A6
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjDCOak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjDCOai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:30:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126FD31996
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C118EB81C50
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF86C433EF;
        Mon,  3 Apr 2023 14:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532234;
        bh=YBS5+jHGJzi3JDG7CMye8IsKn0fN3IFUkvZPxXmj5eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpN8KfteolQVENdrUrq2JzosguGozFhX3o0YqgF8K80IUONvTsClboXhTLDPH94fE
         DvnRFEghvSxxga2o6MBepB+Kl3CTA+tKqwpdrR/ApDDN/IoZ0LrMBi78jaC3t1bwv0
         oxVclwYfccAqsVcLLobwtKvip4vOsa6cjLJdQc9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 154/173] pinctrl: at91-pio4: fix domain name assignment
Date:   Mon,  3 Apr 2023 16:09:29 +0200
Message-Id: <20230403140419.428295685@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 7bb97e360acdd38b68ad0a1defb89c6e89c85596 upstream.

Since commit d59f6617eef0 ("genirq: Allow fwnode to carry name
information only") an IRQ domain is always given a name during
allocation (e.g. used for the debugfs entry).

Drop the no longer valid name assignment, which would lead to an attempt
to free a string constant when removing the domain on late probe
failures (e.g. probe deferral).

Fixes: d59f6617eef0 ("genirq: Allow fwnode to carry name information only")
Cc: stable@vger.kernel.org	# 4.13
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com> # on SAMA7G5
Link: https://lore.kernel.org/r/20230224130828.27985-1-johan+linaro@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-at91-pio4.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1139,7 +1139,6 @@ static int atmel_pinctrl_probe(struct pl
 		dev_err(dev, "can't add the irq domain\n");
 		return -ENODEV;
 	}
-	atmel_pioctrl->irq_domain->name = "atmel gpio";
 
 	for (i = 0; i < atmel_pioctrl->npins; i++) {
 		int irq = irq_create_mapping(atmel_pioctrl->irq_domain, i);


