Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6959847ACB5
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbhLTOqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50512 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhLTOnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:43:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 668F6B80EE0;
        Mon, 20 Dec 2021 14:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E909C36AE9;
        Mon, 20 Dec 2021 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011415;
        bh=h2b/hTO1DzvEMZkWj74z11Nn9usp8pUuk3bGiuDws5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFkE//mi8npT/FDLFChAJmsc8b0gvAKzLZZvbcDkD5VE1Us5OkEKCAKbC3u/WR5Yd
         fVHAn9RW6jG2cYeRgeBy/xqhhqYd/EuJLTznWxsVrOlBMwfRm6nFDhQi9r6DdiLeKd
         OiIFdyY9QFDx5KrNy6Dg/Z9UoeOF4HHtT88leKFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/71] arm64: dts: rockchip: fix audio-supply for Rock Pi 4
Date:   Mon, 20 Dec 2021 15:34:02 +0100
Message-Id: <20211220143026.140372992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 8240e87f16d17a9592c9d67857a3dcdbcb98f10d ]

As stated in the schematics [1] and [2] P5 the APIO5 domain is supplied
by RK808-D Buck4, which in our case vcc1v8_codec - i.e. a 1.8 V regulator.

Currently only white noise comes from the ES8316's output, which - for
whatever reason - came up only after the the correct switch from i2s0_8ch_bus
to i2s0_2ch_bus for i2s0's pinctrl was done.

Fix this by setting the correct regulator for audio-supply.

[1] https://dl.radxa.com/rockpi4/docs/hw/rockpi4/rockpi4_v13_sch_20181112.pdf
[2] https://dl.radxa.com/rockpi4/docs/hw/rockpi4/rockpi_4c_v12_sch_20200620.pdf

Fixes: 1b5715c602fd ("arm64: dts: rockchip: add ROCK Pi 4 DTS support")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20211027143726.165809-1-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
index 1ae1ebd4efdd0..da3b031d4befa 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
@@ -452,7 +452,7 @@ &io_domains {
 	status = "okay";
 
 	bt656-supply = <&vcc_3v0>;
-	audio-supply = <&vcc_3v0>;
+	audio-supply = <&vcc1v8_codec>;
 	sdmmc-supply = <&vcc_sdio>;
 	gpio1830-supply = <&vcc_3v0>;
 };
-- 
2.33.0



