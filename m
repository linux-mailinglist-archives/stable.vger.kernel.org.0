Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75197150D1B
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgBCQlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbgBCQem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:42 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E982082E;
        Mon,  3 Feb 2020 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747681;
        bh=8q1Jas/q+s5IaRxGYxL9jFMJFjlPUTIRXcKAPTYK13U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiZc+h7d9IZaf2iTzbKwDyveEdFS1zZwrCxqNqD0x1sLRG7oGQwIjoxjF+Xkn3bU7
         FH4TJWJLOWtfZ4xn8AhYmz2SXm4uFxqhiS2UdBapwNRj66VRy5+AZu87Uh+Ou4N1W2
         5ZHmYc6nCoAZxLaj9VgKHk9snC+T1RrrE0OA94VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/90] ARM: dts: sun8i: a83t: Correct USB3503 GPIOs polarity
Date:   Mon,  3 Feb 2020 16:19:29 +0000
Message-Id: <20200203161921.061213173@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 1c226017d3ec93547b58082bdf778d9db7401c95 ]

Current USB3503 driver ignores GPIO polarity and always operates as if the
GPIO lines were flagged as ACTIVE_HIGH. Fix the polarity for the existing
USB3503 chip applications to match the chip specification and common
convention for naming the pins. The only pin, which has to be ACTIVE_LOW
is the reset pin. The remaining are ACTIVE_HIGH. This change allows later
to fix the USB3503 driver to properly use generic GPIO bindings and read
polarity from DT.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
index fb928503ad45d..d9be511f054f0 100644
--- a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
@@ -101,7 +101,7 @@
 		initial-mode = <1>; /* initialize in HUB mode */
 		disabled-ports = <1>;
 		intn-gpios = <&pio 7 5 GPIO_ACTIVE_HIGH>; /* PH5 */
-		reset-gpios = <&pio 4 16 GPIO_ACTIVE_HIGH>; /* PE16 */
+		reset-gpios = <&pio 4 16 GPIO_ACTIVE_LOW>; /* PE16 */
 		connect-gpios = <&pio 4 17 GPIO_ACTIVE_HIGH>; /* PE17 */
 		refclk-frequency = <19200000>;
 	};
-- 
2.20.1



