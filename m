Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54AC505566
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbiDRNPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242044AbiDRNNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:13:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542362DA9C;
        Mon, 18 Apr 2022 05:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E5B861256;
        Mon, 18 Apr 2022 12:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4184C385A1;
        Mon, 18 Apr 2022 12:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286258;
        bh=64WSwsWMU/xKi1MR4L5fR0tWrt3NkgAciY9O3eHCo/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A122EymkK11CdiN3Vr0/DTGUjvPYbA9gT1J8CCgPuqVMb8DjGyHx3zrmUUbeViiT+
         QeMyrT9VVDe4l+F56hLou0vuZnmjCSJtaeeDiND2WVHrO1t2wg/Tx3v4+K6+U7Z2Yt
         IAuT+PXB+CSgBle+YAckHt8krlpclGLCz9igWgFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Alexander Dahl <ada@thorsis.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 4.14 041/284] ARM: dts: at91: sama5d2: Fix PMERRLOC resource size
Date:   Mon, 18 Apr 2022 14:10:22 +0200
Message-Id: <20220418121211.862607178@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
@@ -1121,7 +1121,7 @@
 				pmecc: ecc-engine@f8014070 {
 					compatible = "atmel,sama5d2-pmecc";
 					reg = <0xf8014070 0x490>,
-					      <0xf8014500 0x100>;
+					      <0xf8014500 0x200>;
 				};
 			};
 


