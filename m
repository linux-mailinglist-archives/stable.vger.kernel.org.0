Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633C6106F03
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfKVKzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbfKVKzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E114020706;
        Fri, 22 Nov 2019 10:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420115;
        bh=E4c7E0E0gF6jfSVz2Pxox2hy9Q5loNqXt/ABscsuXqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWtVenTnxN3Vw6UN2Un07beD1ZckxjXWCwdmc6xPDdfV2BIXbE8121f3bYQZDDuEv
         SBiORRQPmyauANLqvqgU0C8U3kuR+nm3CZpg9EFnJmD2lRzoIb5NJzXdXhgL/CYyeE
         Lllwr7BZTXMH/JJHrCAWIpH3S6v9De6FCJDmpNX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Roger Quadros <rogerq@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/122] ARM: dts: omap5: Fix dual-role mode on Super-Speed port
Date:   Fri, 22 Nov 2019 11:29:32 +0100
Message-Id: <20191122100837.456100988@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit a763ecc15d0e37c3a15ff6825183061209832685 ]

OMAP5's Super-Speed USB port has a software mailbox register
that needs to be fed with VBUS and ID events from an external
VBUS/ID comparator.

Without this, Host role will not work correctly.

Fixes: 656c1a65ab55 ("ARM: dts: omap5: enable OTG role for DWC3 controller")
Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap5-board-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index f65343f8e1d69..c58f14de01451 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -695,6 +695,7 @@
 };
 
 &dwc3 {
+	extcon = <&extcon_usb3>;
 	dr_mode = "otg";
 };
 
-- 
2.20.1



