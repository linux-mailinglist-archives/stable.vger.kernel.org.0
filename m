Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D93E56FDE4
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiGKKCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiGKKBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:01:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1CB77A7A;
        Mon, 11 Jul 2022 02:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98010B80E6D;
        Mon, 11 Jul 2022 09:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0232DC341CF;
        Mon, 11 Jul 2022 09:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531701;
        bh=jhc/ulTw10SoBS56aSkgurPUpyWUw86gbF4tzyLdDKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nV8ft7Nfno3T7snPDxyvUvsKTFqSls+Z3vuihy/bk+jKKxUqB4HRkcjM3Ws762x9G
         MNNMMZqn0PdtTcvbK1jjIoHy/9MeEKGqHQOLFidm94VcJ5p9hFFF92qHweNCoeKPx3
         Tkr9udK4DKV02IBO6n433Z5tjlTX6ntHXgNHShfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/230] ARM: dts: at91: sam9x60ek: fix eeprom compatible and size
Date:   Mon, 11 Jul 2022 11:07:36 +0200
Message-Id: <20220711090609.779176726@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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
index b1068cca4228..fd8dc1183b3e 100644
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



