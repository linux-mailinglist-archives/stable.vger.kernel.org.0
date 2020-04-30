Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5001E1BFD90
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3ONQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgD3Nut (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:50:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B717B2082E;
        Thu, 30 Apr 2020 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254648;
        bh=2mLw8FLDMvON6Ru0EDLJPgLcxLqD12on0r+a5CvEJY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U85ZRaV6Bz3WrXAeXONYpX3hRADMsBEJfcMoAskF1LSa+d4uVWs3Kmg2md7UtjuLr
         a+JXtlT0RDM/lPFma3Tmm4K5fXgb9SRWUIcUM4zG3hrm80DDXQSdj494+v1fAigTUK
         tVMP2JOSD4aCjtX+M7NylwmIJdbI4UzwnKjGJwtM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 03/79] ARM: dts: bcm283x: Add cells encoding format to firmware bus
Date:   Thu, 30 Apr 2020 09:49:27 -0400
Message-Id: <20200430135043.19851-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit be08d278eb09210fefbad4c9b27d7843f1c096b2 ]

With the introduction of 55c7c0621078 ("ARM: dts: bcm283x: Fix vc4's
firmware bus DMA limitations") the firmware bus has to comply with
/soc's DMA limitations. Ultimately linking both buses to a same
dma-ranges property. The patch (and author) missed the fact that a bus'
#address-cells and #size-cells properties are not inherited, but set to
a fixed value which, in this case, doesn't match /soc's. This, although
not breaking Linux's DMA mapping functionality, generates ugly dtc
warnings.

Fix the issue by adding the correct address and size cells properties
under the firmware bus.

Fixes: 55c7c0621078 ("ARM: dts: bcm283x: Fix vc4's firmware bus DMA limitations")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20200326134413.12298-1-nsaenzjulienne@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2835-rpi.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm2835-rpi.dtsi
index fd2c766e0f710..f7ae5a4530b88 100644
--- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -14,6 +14,9 @@
 	soc {
 		firmware: firmware {
 			compatible = "raspberrypi,bcm2835-firmware", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
 			mboxes = <&mailbox>;
 			dma-ranges;
 		};
-- 
2.20.1

