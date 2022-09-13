Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EEB5B6FD3
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiIMOST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiIMORk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:17:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A18642C2;
        Tue, 13 Sep 2022 07:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08E4CB80F52;
        Tue, 13 Sep 2022 14:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD2EC433D6;
        Tue, 13 Sep 2022 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078353;
        bh=43QRoDufEtRK3DtXzxScgeaezUW3pXwLMALlVhWIUGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lt5sgrBGZI4PXHhuC4BqKKGmEkugMNNlkPJBuuFKOaPDY+XlIBqt7vujMa0sInnz/
         hQpfo/k3QuI4EgCUhUTlsaWA8EfVTxeJrCUY5gZz09f9FD7OuFChpDT+CjNH2TwiY1
         Af2ubd3JIb4x92JJCNT2+6mVx0Ws7dwceLSsz36s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 080/192] arm64: dts: verdin-imx8mm: add otg2 pd to usbphy
Date:   Tue, 13 Sep 2022 16:03:06 +0200
Message-Id: <20220913140413.948772334@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Philippe Schenker <philippe.schenker@toradex.com>

[ Upstream commit 2fa24aa721ebb3a83dd2093814ba9a5dcdaa3183 ]

The Verdin iMX8M Mini System on Module does not have USB-ID signal
connected on Verdin USB_2 (usbotg2). On Verdin Development board this is
no problem, as we have connected a USB-Hub that is always connected.

However, if Verdin USB_2 is desired to be used as a single USB-Host port
the chipidea driver does not detect if a USB device is plugged into this
port, due to runtime pm shutting down the PHY.

Add the power-domain &pgc_otg2 to &usbphynop2 in order to detect
plugging events and enumerate the usb device.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 6491e745b3fa8..d6d31094be0af 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -737,6 +737,7 @@
 };
 
 &usbphynop2 {
+	power-domains = <&pgc_otg2>;
 	vcc-supply = <&reg_vdd_3v3>;
 };
 
-- 
2.35.1



