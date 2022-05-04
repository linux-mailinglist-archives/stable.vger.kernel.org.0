Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B504C51AA0C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351481AbiEDRVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358072AbiEDRPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E285640A;
        Wed,  4 May 2022 09:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E1D2CE28B0;
        Wed,  4 May 2022 16:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF40C385A4;
        Wed,  4 May 2022 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683521;
        bh=hFzdxaibjjuBchOtAixxvVDfgsr7vHrSRkpGGqYPVW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aj0fUUhyJbtioaBysFbWzIpnL06RdGOEzCubfOJJoDYtjfCePOLgc4KkpZgThYoZK
         BooTsnuxl2TeRU5+sugMG7S3EKOyWNaJUgL9la6OAsBHZ1A+2qXqW4NlHYn/C+34UB
         a55NMUYnTY1+hZwXMcmkgGGfLf7OOzF0EPCUhq3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.17 196/225] ARM: dts: at91: sama7g5ek: enable pull-up on flexcom3 console lines
Date:   Wed,  4 May 2022 18:47:14 +0200
Message-Id: <20220504153127.688262187@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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
@@ -465,7 +465,7 @@
 	pinctrl_flx3_default: flx3_default {
 		pinmux = <PIN_PD16__FLEXCOM3_IO0>,
 			 <PIN_PD17__FLEXCOM3_IO1>;
-		bias-disable;
+		bias-pull-up;
 	};
 
 	pinctrl_flx4_default: flx4_default {


