Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA186328963
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhCARzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238992AbhCARtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2003464EFE;
        Mon,  1 Mar 2021 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618020;
        bh=eCjytbrzNgFTMozE8yJrwlEMCfqMOUqtSTSS+MWopow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhdru+KtLIWsrtD0r2k5HfLwSSezMb42xHabY0xd6VMmb+AGMFdc57R3/Flt4cWxj
         VBFbt3vu6nzTzd0om6+fenmQQRkRYm+5rYgeg4CMtAPlyJaFvohOD6NQD95ojec4Pm
         /EgD5EtLpJoyvkvcOH5heJu2iDY+uzkSU504kOYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.4 279/340] dts64: mt7622: fix slow sd card access
Date:   Mon,  1 Mar 2021 17:13:43 +0100
Message-Id: <20210301161102.024278631@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

commit dc2e76175417e69c41d927dba75a966399f18354 upstream.

Fix extreme slow speed (200MB takes ~20 min) on writing sdcard on
bananapi-r64 by adding reset-control for mmc1 like it's done for mmc0/emmc.

Fixes: 2c002a3049f7 ("arm64: dts: mt7622: add mmc related device nodes")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210113180919.49523-1-linux@fw-web.de
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -698,6 +698,8 @@
 		clocks = <&pericfg CLK_PERI_MSDC30_1_PD>,
 			 <&topckgen CLK_TOP_AXI_SEL>;
 		clock-names = "source", "hclk";
+		resets = <&pericfg MT7622_PERI_MSDC1_SW_RST>;
+		reset-names = "hrst";
 		status = "disabled";
 	};
 


