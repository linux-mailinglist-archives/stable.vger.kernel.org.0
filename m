Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC15944F0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349541AbiHOWi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351212AbiHOWht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796E112F71A;
        Mon, 15 Aug 2022 12:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC02BB80EAB;
        Mon, 15 Aug 2022 19:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3AAC433D6;
        Mon, 15 Aug 2022 19:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593056;
        bh=UcJUPZ1QbSmS9xdHVvp7rd9UQ+GV5ASMhZ482Ly/dV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJoEgCRtzjPAH3ZU8gc+iqlDqaTRmnQNqqecvJtbHZoAsTBzqWGYq0zBtgi/2O1GG
         v9ALjWhMrDb/YDxSRXBBdkueaN/jc8HA4h1NMT/oyUqSkCiNoaykBMBg3tNfE8cTDg
         rqLD3F13LpOkvigKT635cfKWOchYWgtbFCLVf3+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0206/1157] ARM: dts: imx7-colibri: improve wake-up with gpio key
Date:   Mon, 15 Aug 2022 19:52:42 +0200
Message-Id: <20220815180447.892699167@linuxfoundation.org>
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

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

[ Upstream commit fd5d2974652c96935d94301af6eaf6b3585ab330 ]

The pin GPIO1_IO01 externally pulls down, it is required to sequentially
connect this pin (signal WAKE_MICO#) to +3v3 and then disconnect it to
trigger a wakeup interrupt.
Adding the flag GPIO_PULL_DOWN allows the system to be woken up just
connecting the pin GPIO1_IO01 to +3v3.

Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7-colibri-aster.dtsi   | 2 +-
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx7-colibri-aster.dtsi b/arch/arm/boot/dts/imx7-colibri-aster.dtsi
index 950b4e5f6cf4..69ee85084ad4 100644
--- a/arch/arm/boot/dts/imx7-colibri-aster.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-aster.dtsi
@@ -16,7 +16,7 @@ gpio-keys {
 
 		power {
 			label = "Wake-Up";
-			gpios = <&gpio1 1 GPIO_ACTIVE_HIGH>;
+			gpios = <&gpio1 1 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>;
 			linux,code = <KEY_WAKEUP>;
 			debounce-interval = <10>;
 			wakeup-source;
diff --git a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
index 17ad9065646d..d6775e3c64f1 100644
--- a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
@@ -34,7 +34,7 @@ gpio-keys {
 
 		power {
 			label = "Wake-Up";
-			gpios = <&gpio1 1 GPIO_ACTIVE_HIGH>;
+			gpios = <&gpio1 1 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>;
 			linux,code = <KEY_WAKEUP>;
 			debounce-interval = <10>;
 			wakeup-source;
-- 
2.35.1



