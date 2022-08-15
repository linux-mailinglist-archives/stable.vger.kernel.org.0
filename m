Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D95946A7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346725AbiHOW75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352481AbiHOW6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A202760C9;
        Mon, 15 Aug 2022 12:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBDD860FD8;
        Mon, 15 Aug 2022 19:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AE5C433D6;
        Mon, 15 Aug 2022 19:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593394;
        bh=wx3Pqq+F2h2jfSI8/LFoPCkQS2DBaKaEJmT2ns3U6iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0Esu8/IZ+ZtOnsw8Lo3hDJsZIgPvnWyocSAPnf2in6W6nw71lz3TWr3JctEs7oQD
         ojWNYugMVbHcRv1lCb1NX/zcM5/vavLDu3zGECB026v7vn65TXpRVaK1PNamK+jA/2
         +be2qbsVw5vzoga8V1eROAU3yN5JeRgaQKADnUhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, INAGAKI Hiroshi <musashino.open@gmail.com>,
        Nick Hainke <vincent@systemli.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0261/1157] arm64: dts: mt7622: fix BPI-R64 WPS button
Date:   Mon, 15 Aug 2022 19:53:37 +0200
Message-Id: <20220815180450.016037629@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nick Hainke <vincent@systemli.org>

[ Upstream commit c98e6e683632386a3bd284acda4342e68aec4c41 ]

The bananapi R64 (BPI-R64) experiences wrong WPS button signals.
In OpenWrt pushing the WPS button while powering on the device will set
it to recovery mode. Currently, this also happens without any user
interaction. In particular, the wrong signals appear while booting the
device or restarting it, e.g. after doing a system upgrade. If the
device is in recovery mode the user needs to manually power cycle or
restart it.

The official BPI-R64 sources set the WPS button to GPIO_ACTIVE_LOW in
the device tree. This setting seems to suppress the unwanted WPS button
press signals. So this commit changes the button from GPIO_ACTIVE_HIGH to
GPIO_ACTIVE_LOW.

The official BPI-R64 sources can be found on
https://github.com/BPI-SINOVOIP/BPI-R64-openwrt

Fixes: 0b6286dd96c0 ("arm64: dts: mt7622: add bananapi BPI-R64 board")

Suggested-by: INAGAKI Hiroshi <musashino.open@gmail.com>
Signed-off-by: Nick Hainke <vincent@systemli.org>
Link: https://lore.kernel.org/r/20220630111746.4098-1-vincent@systemli.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
index 2b9bf8dd14ec..7538918c7a82 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
@@ -49,7 +49,7 @@ factory {
 		wps {
 			label = "wps";
 			linux,code = <KEY_WPS_BUTTON>;
-			gpios = <&pio 102 GPIO_ACTIVE_HIGH>;
+			gpios = <&pio 102 GPIO_ACTIVE_LOW>;
 		};
 	};
 
-- 
2.35.1



