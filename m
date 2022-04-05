Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830534F2579
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiDEHuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiDEHr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AC592D00;
        Tue,  5 Apr 2022 00:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AF7616C4;
        Tue,  5 Apr 2022 07:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E7CC340EE;
        Tue,  5 Apr 2022 07:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144727;
        bh=h/fjImZufkoiOHYV3J89zfVTdxTBVYhSbpTa8rbcvSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTLd5Xu+q5SsRnreGmKSNjU8ihtRrC5R36P6GrjdMO24xMVUUpJlfFtHFYMqkQWO5
         w9+6oq4+NWVuivkqerhtBNPPxPIUs3gp7fl19vauE+uaVaCI6btbbkSbSyr2Vuom/q
         duvO1guzE0VohzYAyPXG1CgbOcCs62RMLWH2f0Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Alexander Dahl <ada@thorsis.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.17 0150/1126] ARM: dts: at91: sama5d2: Fix PMERRLOC resource size
Date:   Tue,  5 Apr 2022 09:14:57 +0200
Message-Id: <20220405070411.987164965@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 0fb578a529ac7aca326a9fa475b4a6f58a756fda upstream.

PMERRLOC resource size was set to 0x100, which resulted in HSMC_ERRLOCx
register being truncated to offset x = 21, causing error correction to
fail if more than 22 bit errors and if 24 or 32 bit error correction
was supported.

Fixes: d9c41bf30cf8 ("ARM: dts: at91: Declare EBI/NAND controllers")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: <stable@vger.kernel.org> # 4.13.x
Acked-by: Alexander Dahl <ada@thorsis.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220111132301.906712-1-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/sama5d2.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -415,7 +415,7 @@
 				pmecc: ecc-engine@f8014070 {
 					compatible = "atmel,sama5d2-pmecc";
 					reg = <0xf8014070 0x490>,
-					      <0xf8014500 0x100>;
+					      <0xf8014500 0x200>;
 				};
 			};
 


