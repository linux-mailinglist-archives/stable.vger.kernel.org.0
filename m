Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B10F26B6FE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgIPAPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgIOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 397ED222EA;
        Tue, 15 Sep 2020 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179508;
        bh=pGj7zHXG2F0d1nb/ZFnThlg4trSeFGXl4LPh38Vv14s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruSKDZq/A3WT4sSZCgLlBiYFqRfyxKxmPU719b3AnP8N/t3pt3bLugE+/NB4U/wDb
         /AKn9/pPBTeG9Bph77UcngOw2V3Ixb09EAINQp0ksSoZrHL4GACiTnpTX7IttNleFF
         ZUNwlpBzpaIVKEJGb5wqkpGiY3iLVMQx3CXBiUBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/132] ARM: dts: logicpd-torpedo-baseboard: Fix broken audio
Date:   Tue, 15 Sep 2020 16:11:43 +0200
Message-Id: <20200915140644.114100621@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit d7dfee67688ac7f2dfd4c3bc70c053ee990c40b5 ]

Older versions of U-Boot would pinmux the whole board, but as
the bootloader got updated, it started to only pinmux the pins
it needed, and expected Linux to configure what it needed.

Unfortunately this caused an issue with the audio, because the
mcbsp2 pins were configured in the device tree, they were never
referenced by the driver. When U-Boot stopped muxing the audio
pins, the audio died.

This patch adds the references to the associate the pin controller
with the mcbsp2 driver which makes audio operate again.

Fixes: 739f85bba5ab ("ARM: dts: Move most of logicpd-torpedo-37xx-devkit to logicpd-torpedo-baseboard")

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi b/arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi
index 449cc7616da63..e7a8f8addb6e0 100644
--- a/arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi
+++ b/arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi
@@ -80,6 +80,8 @@
 };
 
 &mcbsp2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcbsp2_pins>;
 	status = "okay";
 };
 
-- 
2.25.1



