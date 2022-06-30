Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D96561C5F
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiF3NyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbiF3Nwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD24B4D4FE;
        Thu, 30 Jun 2022 06:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A4746200C;
        Thu, 30 Jun 2022 13:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52419C34115;
        Thu, 30 Jun 2022 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596994;
        bh=o3tqqsF5eFwjKTHYgfSEao3TrrhqYt7yT8Nw8o9EBlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oxu5VyJtSoMOQhwfvhOIyoeMArtKxZ9keMc/hbLKxl9DGbQeKVWlK9bNVYJOZifun
         09cJMVvep0MbMkM2vza19hzW/+YndZpm1ZNM4PIi2Bb52Oda769J5MZALCb+KyzI9i
         8HNXKV+/x+VbGFnq5iRXZycUe8U18Lu7jgll7id4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.14 25/35] ARM: dts: imx6qdl: correct PU regulator ramp delay
Date:   Thu, 30 Jun 2022 15:46:36 +0200
Message-Id: <20220630133233.179789514@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
References: <20220630133232.433955678@linuxfoundation.org>
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
@@ -699,7 +699,7 @@
 					regulator-name = "vddpu";
 					regulator-min-microvolt = <725000>;
 					regulator-max-microvolt = <1450000>;
-					regulator-enable-ramp-delay = <150>;
+					regulator-enable-ramp-delay = <380>;
 					anatop-reg-offset = <0x140>;
 					anatop-vol-bit-shift = <9>;
 					anatop-vol-bit-width = <5>;


