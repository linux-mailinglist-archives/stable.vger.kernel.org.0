Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1361C1631
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgEANlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731415AbgEANle (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD7520757;
        Fri,  1 May 2020 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340494;
        bh=Lf9oEQ3lI1qIP5shT6OKBB/wJ6bYndoz/cNzVPJMB18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRsMbS8vP0S5bv28t1OghftweEoI2u7Dp0AJ+iUfYut/iTEvr1t3CDWWijiBfmPV+
         uv+3hCStvu4qPAwaCyeBAd2+GKiNhN2vzftuiOFS+p6Rw1Lzo3UWw8mhXZk5cZIjOm
         H2Zf/ZPt8EJbuSBeF5mMwX1vAlV5CCIWO1TVqtiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Subject: [PATCH 5.6 005/106] ARM: dts: bcm283x: Add cells encoding format to firmware bus
Date:   Fri,  1 May 2020 15:22:38 +0200
Message-Id: <20200501131544.107799394@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit be08d278eb09210fefbad4c9b27d7843f1c096b2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/bcm2835-rpi.dtsi |    3 +++
 1 file changed, 3 insertions(+)

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


