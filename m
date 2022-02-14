Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC374B4989
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347761AbiBNKbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348745AbiBNKbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A831710DF;
        Mon, 14 Feb 2022 01:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6BBA60B3F;
        Mon, 14 Feb 2022 09:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D4EC340E9;
        Mon, 14 Feb 2022 09:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832769;
        bh=T7YDZ7jqaN12u6DNHfqzCT1Ns3t7VXGIw+QDvT0i+QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/SJH/UtaVLLnijp7GgzifHWH4qzML9qYH9TZqKg9m8p6aS9mRzOP6S2eBkZP/WoM
         oIOqkM8FzEvKxIvuyt6gL7hKjiW4pZxK44ghVMNN///hcfFKhc/7BeyBMKgVEg1vyk
         7CHw1tq4kQJ4x5+yT8T57fyhkNf5E8y2TYE6q6i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lutz Koschorreck <theleks@ko-hh.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 119/203] arm64: dts: meson-sm1-odroid: use correct enable-gpio pin for tf-io regulator
Date:   Mon, 14 Feb 2022 10:26:03 +0100
Message-Id: <20220214092514.295382934@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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

From: Lutz Koschorreck <theleks@ko-hh.de>

[ Upstream commit 323ca765bfe9d637fa774373baec0bc41e51fcfa ]

The interrupt pin of the external ethernet phy is used, instead of the
enable-gpio pin of the tf-io regulator. The GPIOE_2 pin is located in
the gpio_ao bank.

This causes phy interrupt problems at system startup.
[   76.645190] irq 36: nobody cared (try booting with the "irqpoll" option)
[   76.649617] CPU: 0 PID: 1416 Comm: irq/36-0.0:00 Not tainted 5.16.0 #2
[   76.649629] Hardware name: Hardkernel ODROID-HC4 (DT)
[   76.649635] Call trace:
[   76.649638]  dump_backtrace+0x0/0x1c8
[   76.649658]  show_stack+0x14/0x60
[   76.649667]  dump_stack_lvl+0x64/0x7c
[   76.649676]  dump_stack+0x14/0x2c
[   76.649683]  __report_bad_irq+0x38/0xe8
[   76.649695]  note_interrupt+0x220/0x3a0
[   76.649704]  handle_irq_event_percpu+0x58/0x88
[   76.649713]  handle_irq_event+0x44/0xd8
[   76.649721]  handle_fasteoi_irq+0xa8/0x130
[   76.649730]  generic_handle_domain_irq+0x38/0x58
[   76.649738]  gic_handle_irq+0x9c/0xb8
[   76.649747]  call_on_irq_stack+0x28/0x38
[   76.649755]  do_interrupt_handler+0x7c/0x80
[   76.649763]  el1_interrupt+0x34/0x80
[   76.649772]  el1h_64_irq_handler+0x14/0x20
[   76.649781]  el1h_64_irq+0x74/0x78
[   76.649788]  irq_finalize_oneshot.part.56+0x68/0xf8
[   76.649796]  irq_thread_fn+0x5c/0x98
[   76.649804]  irq_thread+0x13c/0x260
[   76.649812]  kthread+0x144/0x178
[   76.649822]  ret_from_fork+0x10/0x20
[   76.649830] handlers:
[   76.653170] [<0000000025a6cd31>] irq_default_primary_handler threaded [<0000000093580eb7>] phy_interrupt
[   76.661256] Disabling IRQ #36

Fixes: 1f80a5cf74a6 ("arm64: dts: meson-sm1-odroid: add missing enable gpio and supply for tf_io regulator")
Signed-off-by: Lutz Koschorreck <theleks@ko-hh.de>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
[narmstrong: removed spurious invalid & blank lines from commit message]
Link: https://lore.kernel.org/r/20220127130537.GA187347@odroid-VirtualBox
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
index 5779e70caccd3..328f4adfaaa9d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
@@ -48,7 +48,7 @@ tf_io: gpio-regulator-tf_io {
 		regulator-max-microvolt = <3300000>;
 		vin-supply = <&vcc_5v>;
 
-		enable-gpio = <&gpio GPIOE_2 GPIO_ACTIVE_HIGH>;
+		enable-gpio = <&gpio_ao GPIOE_2 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		regulator-always-on;
 
-- 
2.34.1



