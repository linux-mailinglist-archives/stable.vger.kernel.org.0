Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D1B4ABD4A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387211AbiBGLkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349352AbiBGLaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:30:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E449DC03FEF7;
        Mon,  7 Feb 2022 03:28:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1480DB81158;
        Mon,  7 Feb 2022 11:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD12C004E1;
        Mon,  7 Feb 2022 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233305;
        bh=ugirauE7wsGqXb36nXK6gxIvb+7wGHj2bprs0GCSXLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukQjQDUzpmEzWMeJlrrIqbjlTC6ATB6Cwqxwi/SMpr+vpy/3+12IWgeF/YaRzTwsQ
         +/r+Rovx2E0W0Xu3zW7H8UMnuOFy1YrIq6yS097ljNVD2p3RPjsLFjLkDkFthNwLlx
         WjTodUWADorpwONLWywqZ0Ca3WYui7DsUJjYpx1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kane Chen <kane.chen@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grace Kao <grace.kao@intel.com>
Subject: [PATCH 5.15 080/110] pinctrl: intel: Fix a glitch when updating IRQ flags on a preconfigured line
Date:   Mon,  7 Feb 2022 12:06:53 +0100
Message-Id: <20220207103805.092155522@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e12963c453263d5321a2c610e98cbc731233b685 upstream.

The commit af7e3eeb84e2 ("pinctrl: intel: Disable input and output buffer
when switching to GPIO") hadn't taken into account an update of the IRQ
flags scenario.

When updating the IRQ flags on the preconfigured line the ->irq_set_type()
is called again. In such case the sequential Rx buffer configuration
changes may trigger a falling or rising edge interrupt that may lead,
on some platforms, to an undesired event.

This may happen because each of intel_gpio_set_gpio_mode() and
__intel_gpio_set_direction() updates the pad configuration with a different
value of the GPIORXDIS bit. Notable, that the intel_gpio_set_gpio_mode() is
called only for the pads that are configured as an input. Due to this fact,
integrate the logic of __intel_gpio_set_direction() call into the
intel_gpio_set_gpio_mode() so that the Rx buffer won't be disabled and
immediately re-enabled.

Fixes: af7e3eeb84e2 ("pinctrl: intel: Disable input and output buffer when switching to GPIO")
Reported-by: Kane Chen <kane.chen@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Grace Kao <grace.kao@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -451,8 +451,8 @@ static void intel_gpio_set_gpio_mode(voi
 	value &= ~PADCFG0_PMODE_MASK;
 	value |= PADCFG0_PMODE_GPIO;
 
-	/* Disable input and output buffers */
-	value |= PADCFG0_GPIORXDIS;
+	/* Disable TX buffer and enable RX (this will be input) */
+	value &= ~PADCFG0_GPIORXDIS;
 	value |= PADCFG0_GPIOTXDIS;
 
 	/* Disable SCI/SMI/NMI generation */
@@ -497,9 +497,6 @@ static int intel_gpio_request_enable(str
 
 	intel_gpio_set_gpio_mode(padcfg0);
 
-	/* Disable TX buffer and enable RX (this will be input) */
-	__intel_gpio_set_direction(padcfg0, true);
-
 	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
 
 	return 0;
@@ -1115,9 +1112,6 @@ static int intel_gpio_irq_type(struct ir
 
 	intel_gpio_set_gpio_mode(reg);
 
-	/* Disable TX buffer and enable RX (this will be input) */
-	__intel_gpio_set_direction(reg, true);
-
 	value = readl(reg);
 
 	value &= ~(PADCFG0_RXEVCFG_MASK | PADCFG0_RXINV);


