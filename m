Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6888A111C99
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfLCWpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbfLCWpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC1C20803;
        Tue,  3 Dec 2019 22:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413144;
        bh=h0U1nofuPTe4sCEj/TQUdWmoKhYd9UzFbpJSKp66ooA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZwIYnrWUS3T+JARslefUHJOztYdtWVeLJE7nweZa/wjahksf8dLWUh3PNXLe908x
         DfF5gSDeAN1sAwGF7siyj/WKkHgmXe+fPbpJuOfc4rW162t9eq+YmuC7v66LLFILq+
         Qinu8Q3nYRMH198V5yHLoScin+EZ/H9juTWExGps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/321] ARM: dts: sun8i-a83t-tbs-a711: Fix WiFi resume from suspend
Date:   Tue,  3 Dec 2019 23:31:22 +0100
Message-Id: <20191203223427.965754178@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index 1537ce148cc19..49547a43cc90a 100644
--- a/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
@@ -171,6 +171,7 @@
 	vqmmc-supply = <&reg_dldo1>;
 	non-removable;
 	wakeup-source;
+	keep-power-in-suspend;
 	status = "okay";
 
 	brcmf: wifi@1 {
-- 
2.20.1



