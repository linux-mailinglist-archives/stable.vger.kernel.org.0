Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD76EA15B
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfJ3QBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 12:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbfJ3PyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:54:17 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F5120874;
        Wed, 30 Oct 2019 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450856;
        bh=A8OJ0gmDn66ao2MoOx6aQnaAj57Lc5OKhEELCpvSyIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbTI4sGqhdtgCGlPpKZa1bFAZ9mvCiMscKeHF9vCjop2ktnGKNoKjZC4qwgRT59Bu
         loHqyF/IxGTBfDx9yHBlbC4cLRSuUktG0dv71+mg3VBJMFfBxU77rxy2m5+5YuHR0b
         dQXJv1fiwR458xC0b2Qe2sALsUqmruPTp8qizESk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/38] arm64: dts: allwinner: a64: pine64-plus: Add PHY regulator delay
Date:   Wed, 30 Oct 2019 11:53:31 -0400
Message-Id: <20191030155406.10109-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

