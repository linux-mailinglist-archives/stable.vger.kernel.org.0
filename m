Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C617F4ABC2A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384936AbiBGLau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384060AbiBGLYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:24:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C9FC043181;
        Mon,  7 Feb 2022 03:24:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D95461426;
        Mon,  7 Feb 2022 11:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262D4C340EB;
        Mon,  7 Feb 2022 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233075;
        bh=hGthDrumJtm6T5rSAr+FgCa3SsvvzGoGvBKplDoc2ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONQNk2MBfJdMeqfDb5bTrFanj5Hp4NnP0a6A7cwfgX7rFGi9Eb4049jpKuKPECGAP
         KbSQTuEGTVYC7fB9w1ZpWfp11Hi534Nn8bm4t/k7QYxPP2Pq9CmqIOkkYA9Z9CEf7B
         f6Rd15HXIkl0tRpt+W2DAcgqj16bUI5E7HbEW1ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kane Chen <kane.chen@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grace Kao <grace.kao@intel.com>
Subject: [PATCH 5.10 49/74] pinctrl: intel: Fix a glitch when updating IRQ flags on a preconfigured line
Date:   Mon,  7 Feb 2022 12:06:47 +0100
Message-Id: <20220207103758.827863262@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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
@@ -441,8 +441,8 @@ static void intel_gpio_set_gpio_mode(voi
 	value &= ~PADCFG0_PMODE_MASK;
 	value |= PADCFG0_PMODE_GPIO;
 
-	/* Disable input and output buffers */
-	value |= PADCFG0_GPIORXDIS;
+	/* Disable TX buffer and enable RX (this will be input) */
+	value &= ~PADCFG0_GPIORXDIS;
 	value |= PADCFG0_GPIOTXDIS;
 
 	/* Disable SCI/SMI/NMI generation */
@@ -487,9 +487,6 @@ static int intel_gpio_request_enable(str
 
 	intel_gpio_set_gpio_mode(padcfg0);
 
-	/* Disable TX buffer and enable RX (this will be input) */
-	__intel_gpio_set_direction(padcfg0, true);
-
 	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
 
 	return 0;
@@ -1105,9 +1102,6 @@ static int intel_gpio_irq_type(struct ir
 
 	intel_gpio_set_gpio_mode(reg);
 
-	/* Disable TX buffer and enable RX (this will be input) */
-	__intel_gpio_set_direction(reg, true);
-
 	value = readl(reg);
 
 	value &= ~(PADCFG0_RXEVCFG_MASK | PADCFG0_RXINV);


