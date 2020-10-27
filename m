Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DE529C204
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819255AbgJ0R27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762427AbgJ0Omr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:42:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E305206B2;
        Tue, 27 Oct 2020 14:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809765;
        bh=Gkf0mJ3r7spa1QV4ABLuN60Go8LUNy1D5m08OzBbltA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u04c7TA0tfURsOVdIqxeFPi5IhNN1nzz2zSbregcN76z7O/Iokf4LeXbZf8L2PJ/W
         T/PNJxaf/ZQtpcunuajBNtWNrryA+uDefmt3AwjDLl53DNuG/DzqFZB9WLjDVzrEBj
         vmnPPXLx3zYqI6JktAYG9g5uTVrFDaahYa2a1/ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Amit Singh Tomar <amittomer25@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 310/408] arm64: dts: actions: limit address range for pinctrl node
Date:   Tue, 27 Oct 2020 14:54:08 +0100
Message-Id: <20201027135509.411828320@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Singh Tomar <amittomer25@gmail.com>

[ Upstream commit 4bb1eb3cd4bd6241d5e5f99bbfd801ea5a007b6c ]

After commit 7cdf8446ed1d ("arm64: dts: actions: Add pinctrl node for
Actions Semi S700") following error has been observed while booting
Linux on Cubieboard7-lite(based on S700 SoC).

[    0.257415] pinctrl-s700 e01b0000.pinctrl: can't request region for
resource [mem 0xe01b0000-0xe01b0fff]
[    0.266902] pinctrl-s700: probe of e01b0000.pinctrl failed with error -16

This is due to the fact that memory range for "sps" power domain controller
clashes with pinctrl.

One way to fix it, is to limit pinctrl address range which is safe
to do as current pinctrl driver uses address range only up to 0x100.

This commit limits the pinctrl address range to 0x100 so that it doesn't
conflict with sps range.

Fixes: 7cdf8446ed1d ("arm64: dts: actions: Add pinctrl node for Actions
Semi S700")

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Suggested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/actions/s700.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/actions/s700.dtsi b/arch/arm64/boot/dts/actions/s700.dtsi
index 2006ad5424fa6..f8eb72bb41254 100644
--- a/arch/arm64/boot/dts/actions/s700.dtsi
+++ b/arch/arm64/boot/dts/actions/s700.dtsi
@@ -231,7 +231,7 @@ timer: timer@e024c000 {
 
 		pinctrl: pinctrl@e01b0000 {
 			compatible = "actions,s700-pinctrl";
-			reg = <0x0 0xe01b0000 0x0 0x1000>;
+			reg = <0x0 0xe01b0000 0x0 0x100>;
 			clocks = <&cmu CLK_GPIO>;
 			gpio-controller;
 			gpio-ranges = <&pinctrl 0 0 136>;
-- 
2.25.1



