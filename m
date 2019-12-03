Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64898111C1C
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfLCWka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbfLCWk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 871322073C;
        Tue,  3 Dec 2019 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412829;
        bh=gdJkhf7wIZ4TH7jdbUR4rc3E9LaipBc/WPb56TGe7L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6eosnJCnC27/UgRxRywbu+9YDgj6Z/7CfxRtlX1bvS15KJPUUiBdgaGi3iyrlPT6
         HZzrXTzsQZMKPPINMMZ3rEoJ0QZ5dsQ8ySI1zuiUmuwI3TO9Bdx+eGYuo/YhGaPM4b
         MlsDAxNydRph00bUIXtS08hXgse4P4dVdeyTbhqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 031/135] ARM: dts: sun8i-a83t-tbs-a711: Fix WiFi resume from suspend
Date:   Tue,  3 Dec 2019 23:34:31 +0100
Message-Id: <20191203213012.204748993@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit e614f341253f8541baf0230a8dc6a016b544b1e2 ]

Without enabling keep-power-in-suspend, we can't wake the device
up using WOL packet, and the log is flooded with these messages
on resume:

sunxi-mmc 1c10000.mmc: send stop command failed
sunxi-mmc 1c10000.mmc: data error, sending stop command
sunxi-mmc 1c10000.mmc: send stop command failed
sunxi-mmc 1c10000.mmc: data error, sending stop command

So to make the WiFi really a wakeup-source, we need to keep it powered
during suspend.

Fixes: 0e23372080def7 ("arm: dts: sun8i: Add the TBS A711 tablet devicetree")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts b/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
index 568b90ece3427..3bec3e0a81b2c 100644
--- a/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
@@ -192,6 +192,7 @@
 	vqmmc-supply = <&reg_dldo1>;
 	non-removable;
 	wakeup-source;
+	keep-power-in-suspend;
 	status = "okay";
 
 	brcmf: wifi@1 {
-- 
2.20.1



