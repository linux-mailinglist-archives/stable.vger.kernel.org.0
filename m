Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04FF5558
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733286AbfKHTBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390314AbfKHTBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:01:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D63222C5;
        Fri,  8 Nov 2019 19:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239705;
        bh=Pkh8O6u6Xi3YkNZ+kgSiq60tEkoy6kaOzhQaxlLsPqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUWEOVAclTfLlOPVb2lwYcSz4Ib7Pq6M0OwdofICONncksDiufLPupFt0jlr+9+an
         4FHEYHopmHE5YB9BXMDPO0UvxzE/049KTqD7AkNNI6hCgf2oweL/9IbH4RMiLWi6mq
         TrhewygcU5lrg3lZwBXty/PXInrHVTwyUxomEBwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/79] arm64: dts: allwinner: a64: sopine-baseboard: Add PHY regulator delay
Date:   Fri,  8 Nov 2019 19:49:45 +0100
Message-Id: <20191108174748.006012861@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit ccdf3aaa27ded6db9a93eed3ca7468bb2353b8fe ]

It turns out that sopine-baseboard needs same fix as pine64-plus
for ethernet PHY. Here too Realtek ethernet PHY chip needs additional
power on delay to properly initialize. Datasheet mentions that chip
needs 30 ms to be properly powered on and that it needs some more time
to be initialized.

Fix that by adding 100ms ramp delay to regulator responsible for
powering PHY.

Note that issue was found out and fix tested on pine64-lts, but it's
basically the same as sopine-baseboard, only layout and connectors
differ.

Fixes: bdfe4cebea11 ("arm64: allwinner: a64: add Ethernet PHY regulator for several boards")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts      | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
index c21f2331add60..285cb7143b96c 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
@@ -113,6 +113,12 @@
 };
 
 &reg_dc1sw {
+	/*
+	 * Ethernet PHY needs 30ms to properly power up and some more
+	 * to initialize. 100ms should be plenty of time to finish
+	 * whole process.
+	 */
+	regulator-enable-ramp-delay = <100000>;
 	regulator-name = "vcc-phy";
 };
 
-- 
2.20.1



