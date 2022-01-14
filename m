Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311AF48E594
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbiANITN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbiANISs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD3AC061773;
        Fri, 14 Jan 2022 00:18:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BDB961E18;
        Fri, 14 Jan 2022 08:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B435C36AEA;
        Fri, 14 Jan 2022 08:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148326;
        bh=NLfessbUmXe+ZF6y3fEFHiUKLlf2JiiygL3Uj94k/cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XT4uyCxr5XvW4n0f34ZC0W1jRUZ6JAfU0dLLDCZLZPjeM7l0t6fwTXSKWVRAdL3Yu
         C9k02eRoQLerg3GRuf/sVejjy9xqFTAePqrPA2L+15uEBqU6Zi1fRKPOQkffxbOwow
         1ajuC9FnDZq12LE8qUf7YDxifO+TSyke+wA9XKA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.10 09/25] ARM: dts: exynos: Fix BCM4330 Bluetooth reset polarity in I9100
Date:   Fri, 14 Jan 2022 09:16:17 +0100
Message-Id: <20220114081543.013327684@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 9cb6de45a006a9799ec399bce60d64b6d4fcc4af upstream.

The reset GPIO was marked active-high, which is against what's specified
in the documentation. Mark the reset GPIO as active-low. With this
change, Bluetooth can now be used on the i9100.

Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20211031234137.87070-1-paul@crapouillou.net
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4210-i9100.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -765,7 +765,7 @@
 		compatible = "brcm,bcm4330-bt";
 
 		shutdown-gpios = <&gpl0 4 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpl1 0 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpl1 0 GPIO_ACTIVE_LOW>;
 		device-wakeup-gpios = <&gpx3 1 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpx2 6 GPIO_ACTIVE_HIGH>;
 	};


