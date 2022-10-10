Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBED5F9920
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiJJHIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiJJHHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:07:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A500058B71;
        Mon, 10 Oct 2022 00:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F17AB80E4D;
        Mon, 10 Oct 2022 07:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D82DC433D6;
        Mon, 10 Oct 2022 07:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385529;
        bh=4JCiA5c4NdAx7YY0hwes4pyrpsIJwxT/BMs6N3Jek1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGZcgiXylaEkLjWoMTov440cJUrFCA5j5mJQhGQfU4b73lGxIlQleKJZPL8asvBsy
         4Y32kr8/kilShXteJpxz4h3gVHU8Nw/8ZDMYG2vTVD28yAYWmDcH4KmtLGwCsSdt8/
         pGO9OeXSUqaSV5KOFQ3cmToGJQ6POza6DJgF3CLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 12/48] arm64: dts: rockchip: fix upper usb port on BPI-R2-Pro
Date:   Mon, 10 Oct 2022 09:05:10 +0200
Message-Id: <20221010070334.027094907@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 388f9f0a7ff84b7890a24499a3a1fea0cad21373 ]

- extcon is no more needed in 5.19 - so drop it
  commit 51a9b2c03dd3 ("phy: rockchip-inno-usb2: Handle ID IRQ")
- dr_mode was changed from host to otg in rk356x.dtsi
  commit bc405bb3eeee ("arm64: dts: rockchip: enable otg/drd
    operation of usb_host0_xhci in rk356x")
  change it back on board level as id-pin on r2pro is not connected

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20220821121929.244112-1-linux@fw-web.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
index 40cf2236c0b6..ca48d9a54939 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@ -558,7 +558,7 @@ &usb_host0_ohci {
 };
 
 &usb_host0_xhci {
-	extcon = <&usb2phy0>;
+	dr_mode = "host";
 	status = "okay";
 };
 
-- 
2.35.1



