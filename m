Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211C555D041
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiF0Lnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbiF0Lmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF06F14;
        Mon, 27 Jun 2022 04:37:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8491BB8111B;
        Mon, 27 Jun 2022 11:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A9EC3411D;
        Mon, 27 Jun 2022 11:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329847;
        bh=N7dJWLRMRxzL2biPyLakUYQmTOEGugbKkPbjLBE8LRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFIJY5FwhMS64NdD+P1fg4mOyGZnuG/98jKSWtPJOyNocPBT83k18dKt41DJJGu9a
         252H/U5Y3mH1hWYs4kdUsY5y8SEALnA7FAvus3KneU/dZIyvnVGAmcH7fPFcu11vOr
         uh+R1619BgU3e/yyOAMKzeTBffTIhmajxHI7/r/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 122/135] ARM: dts: imx6qdl: correct PU regulator ramp delay
Date:   Mon, 27 Jun 2022 13:22:09 +0200
Message-Id: <20220627111941.695258314@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 93a8ba2a619816d631bd69e9ce2172b4d7a481b8 upstream.

Contrary to what was believed at the time, the ramp delay of 150us is not
plenty for the PU LDO with the default step time of 512 pulses of the 24MHz
clock. Measurements have shown that after enabling the LDO the voltage on
VDDPU_CAP jumps to ~750mV in the first step and after that the regulator
executes the normal ramp up as defined by the step size control.

This means it takes the regulator between 360us and 370us to ramp up to
the nominal 1.15V voltage for this power domain. With the old setting of
the ramp delay the power up of the PU GPC domain would happen in the middle
of the regulator ramp with the voltage being at around 900mV. Apparently
this was enough for most units to properly power up the peripherals in the
domain and execute the reset. Some units however, fail to power up properly,
especially when the chip is at a low temperature. In that case any access
to the GPU registers would yield an incorrect result with no way to recover
from this situation.

Change the ramp delay to 380us to cover the measured ramp up time with a
bit of additional slack.

Fixes: 40130d327f72 ("ARM: dts: imx6qdl: Allow disabling the PU regulator, add a enable ramp delay")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6qdl.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -763,7 +763,7 @@
 					regulator-name = "vddpu";
 					regulator-min-microvolt = <725000>;
 					regulator-max-microvolt = <1450000>;
-					regulator-enable-ramp-delay = <150>;
+					regulator-enable-ramp-delay = <380>;
 					anatop-reg-offset = <0x140>;
 					anatop-vol-bit-shift = <9>;
 					anatop-vol-bit-width = <5>;


