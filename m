Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D4B20DC6A
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgF2UPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732835AbgF2TaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC0ED25309;
        Mon, 29 Jun 2020 15:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445135;
        bh=NDjWpEVOqcrwfOoS0J3bTaePGj2M8pGgeS5pPPXAN8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWiM1QtpNtnqsmErOa6HR53jlFHNPKg9/0WHMetkDbum2D+qZh26He6PgjtrPHQ8r
         kBWDmVg2+/oYRld9mL+SZ5Mw+ouKXOJd253J7SeM5Ho/PbT7CsPhqfz4QdTNdAel6J
         /KlwGbs92Lyrqmwombg0BusZS+qxmcP+z6I7iPWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/78] ARM: dts: NSP: Correct FA2 mailbox node
Date:   Mon, 29 Jun 2020 11:37:29 -0400
Message-Id: <20200629153806.2494953-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit ac4e106d8934a5894811fc263f4b03fc8ed0fb7a ]

The FA2 mailbox is specified at 0x18025000 but should actually be
0x18025c00, length 0x400 according to socregs_nsp.h and board_bu.c. Also
the interrupt was off by one and should be GIC SPI 151 instead of 150.

Fixes: 17d517172300 ("ARM: dts: NSP: Add mailbox (PDC) to NSP")
Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 1792192001a22..e975f9cabe84b 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -249,10 +249,10 @@ amac2: ethernet@24000 {
 			status = "disabled";
 		};
 
-		mailbox: mailbox@25000 {
+		mailbox: mailbox@25c00 {
 			compatible = "brcm,iproc-fa2-mbox";
-			reg = <0x25000 0x445>;
-			interrupts = <GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x25c00 0x400>;
+			interrupts = <GIC_SPI 151 IRQ_TYPE_LEVEL_HIGH>;
 			#mbox-cells = <1>;
 			brcm,rx-status-len = <32>;
 			brcm,use-bcm-hdr;
-- 
2.25.1

