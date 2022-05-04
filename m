Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B528751A85B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355748AbiEDRKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356238AbiEDRJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CE652E7E;
        Wed,  4 May 2022 09:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6222B827A4;
        Wed,  4 May 2022 16:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E781C385A4;
        Wed,  4 May 2022 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683298;
        bh=+pd8bGsS0zR0hJwb5IFgrU+qEToXC0YbxDwkOVysbwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHzR3+V3C/b4u27j+Au1Qpb5ZvDzGpjESzcG9Fe3L+3FtojSiU7qkJNEFijdZzXaY
         wrFzGhIuXeKms3Fg/0LajAUiNWOYgunvcl5pLmOYyEayAAvvBADhIQX6AJnSq3MJtG
         zatTgB/6tUxBU1/6M9hTQVf4ACxwn1mb122NOjFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.15 152/177] ARM: dts: at91: sama7g5ek: enable pull-up on flexcom3 console lines
Date:   Wed,  4 May 2022 18:45:45 +0200
Message-Id: <20220504153106.964060853@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

commit 3f7ce6d7091765ed6c67c5d78aa364b9d17e3aab upstream.

Flexcom3 is used as board console serial. There are no pull-ups on these
lines on the board. This means that if a cable is not connected (that has
pull-ups included), stray characters could appear on the console as the
floating pins voltage levels are interpreted as incoming characters.
To avoid this problem, enable the internal pull-ups on these lines.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220307113827.2419331-1-eugen.hristev@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/at91-sama7g5ek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -403,7 +403,7 @@
 	pinctrl_flx3_default: flx3_default {
 		pinmux = <PIN_PD16__FLEXCOM3_IO0>,
 			 <PIN_PD17__FLEXCOM3_IO1>;
-		bias-disable;
+		bias-pull-up;
 	};
 
 	pinctrl_flx4_default: flx4_default {


