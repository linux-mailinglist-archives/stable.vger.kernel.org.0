Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62CCF5555
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733198AbfKHTBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732559AbfKHTBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:01:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F0AE2067B;
        Fri,  8 Nov 2019 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239703;
        bh=A8OJ0gmDn66ao2MoOx6aQnaAj57Lc5OKhEELCpvSyIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPVhRFwD43vzOQNEWwrG/oAPkct3w79LcSyOb3Z770xLY/KM4ISCQEoU4UwGjzcvx
         KPv3Ao+tnTw2VdsMj/U0PRGCJ2C+kaukKR+GDd2uExsDxobweAfQdwPlJSzwDENEHE
         oPEqtnfO6q4s8d1fkaLeuR34g5kf4aUJEYiyEV5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/79] arm64: dts: allwinner: a64: pine64-plus: Add PHY regulator delay
Date:   Fri,  8 Nov 2019 19:49:44 +0100
Message-Id: <20191108174747.567732384@linuxfoundation.org>
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

[ Upstream commit 2511366797fa6ab4a404b4b000ef7cd262aaafe8 ]

Depending on kernel and bootloader configuration, it's possible that
Realtek ethernet PHY isn't powered on properly. According to the
datasheet, it needs 30ms to power up and then some more time before it
can be used.

Fix that by adding 100ms ramp delay to regulator responsible for
powering PHY.

Fixes: 94dcfdc77fc5 ("arm64: allwinner: pine64-plus: Enable dwmac-sun8i")
Suggested-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
index 24f1aac366d64..d5b6e8159a335 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts
@@ -63,3 +63,12 @@
 		reg = <1>;
 	};
 };
+
+&reg_dc1sw {
+	/*
+	 * Ethernet PHY needs 30ms to properly power up and some more
+	 * to initialize. 100ms should be plenty of time to finish
+	 * whole process.
+	 */
+	regulator-enable-ramp-delay = <100000>;
+};
-- 
2.20.1



