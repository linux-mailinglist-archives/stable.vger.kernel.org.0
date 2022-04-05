Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691184F3AC4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbiDELr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355429AbiDEKTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:19:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835646EC77;
        Tue,  5 Apr 2022 03:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F291EB81BC0;
        Tue,  5 Apr 2022 10:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DF3C385A1;
        Tue,  5 Apr 2022 10:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153092;
        bh=EUPH0vkDEVeXCVAVBEpenWoJnK05JcGiufawvmrh8I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm5bWzJ2ZqWsN2FKXn/Aic1kq2nBzWDrD0rwllJmEUOiZKQ44BsQsNXbqUwwBtVtd
         urBXn0ZiVEN4aqbZz5r171VVtosGUxB5SZAGV8cDuWxP1MrLB8tosApcQsm4PvYj/a
         hbcCN4tfqXBw5816iFX41KE/WaMwQMd+8tPKohKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Alexander Dahl <ada@thorsis.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.10 099/599] ARM: dts: at91: sama5d2: Fix PMERRLOC resource size
Date:   Tue,  5 Apr 2022 09:26:33 +0200
Message-Id: <20220405070301.778257710@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
@@ -413,7 +413,7 @@
 				pmecc: ecc-engine@f8014070 {
 					compatible = "atmel,sama5d2-pmecc";
 					reg = <0xf8014070 0x490>,
-					      <0xf8014500 0x100>;
+					      <0xf8014500 0x200>;
 				};
 			};
 


