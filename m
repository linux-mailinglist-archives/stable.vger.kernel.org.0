Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E0657805
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiL1Opv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiL1OpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:45:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273A412081
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:44:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71209CE134F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AB6C433D2;
        Wed, 28 Dec 2022 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238693;
        bh=OvoPftLgNCIVWyumvRT5AIgLunjqxeCqOuMRWjthq48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpPVom9g1J5CpWJEjUc82tthK3sO7IhLU6VddKB2Qy84S38ZJihowXMKtrmqmIHO8
         QmvsG69/W/rMxNBpkqiifByoPaqWKgOLq+BD6XVzFKgbTQ08OvTleWzwvhz+9a5Zl9
         Ki4bvo+A5o8M/zXP9+ha3FCvOsvm8vVJGXcIsHOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Cercueil <paul@crapouillou.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 6.1 0001/1146] MIPS: DTS: CI20: fix reset line polarity of the ethernet controller
Date:   Wed, 28 Dec 2022 15:25:40 +0100
Message-Id: <20221228144330.227642259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit ca637c0ece144ce62ec8ef75dc127bcccd4f442a upstream.

The reset line is called PWRST#, annotated as "active low" in the
binding documentation, and is driven low and then high by the driver to
reset the chip. However in device tree for CI20 board it was incorrectly
marked as "active high". Fix it.

Because (as far as I know) the ci20.dts is always built in the kernel I
elected not to also add a quirk to gpiolib to force the polarity there.

Fixes: db49ca38579d ("net: davicom: dm9000: switch to using gpiod API")
Reported-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -438,7 +438,7 @@
 		ingenic,nemc-tAW = <50>;
 		ingenic,nemc-tSTRV = <100>;
 
-		reset-gpios = <&gpf 12 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpf 12 GPIO_ACTIVE_LOW>;
 		vcc-supply = <&eth0_power>;
 
 		interrupt-parent = <&gpe>;


