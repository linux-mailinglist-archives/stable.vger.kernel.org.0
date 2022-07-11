Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2250A56FB97
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiGKJco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiGKJcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFA3419A8;
        Mon, 11 Jul 2022 02:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1AD561257;
        Mon, 11 Jul 2022 09:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63E2C341C0;
        Mon, 11 Jul 2022 09:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531041;
        bh=ettJJAGG6+QCxqGnRfN2A097HPuayip3gBx+rD7C5SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kn1GrgSTPERNG/GiDxQ4ZKewRqgH+uXxXakpQmsy2oDb5oOr0FZFv+vQ7X4AtJ8xI
         UbwA7nbtU7rzSvKXPhfY6EGHxIGO4pW3X4d9HxDVWL8rsqAVNG+4/H2crHO4Fk00Gd
         0TeGf33T2lJ8y4uA5qLjxcv6T4GKrdLL+K9/Do/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 073/112] ARM: dts: at91: sam9x60ek: fix eeprom compatible and size
Date:   Mon, 11 Jul 2022 11:07:13 +0200
Message-Id: <20220711090551.644673592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit f2cbbc3f926316ccf8ef9363d8a60c1110afc1c7 ]

The board has a microchip 24aa025e48 eeprom, which is a 2 Kbits memory,
so it's compatible with at24c02 not at24c32.
Also the size property is wrong, it's not 128 bytes, but 256 bytes.
Thus removing and leaving it to the default (256).

Fixes: 1e5f532c27371 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220607090455.80433-1-eugen.hristev@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index 7719ea3d4933..81ccb0636a00 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -233,10 +233,9 @@
 		status = "okay";
 
 		eeprom@53 {
-			compatible = "atmel,24c32";
+			compatible = "atmel,24c02";
 			reg = <0x53>;
 			pagesize = <16>;
-			size = <128>;
 			status = "okay";
 		};
 	};
-- 
2.35.1



