Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5062B313788
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhBHP13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:27:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhBHPTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:19:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A23664EBF;
        Mon,  8 Feb 2021 15:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797182;
        bh=/Izv91zcxQEaeZ1igCpWGrDY2izGsbwaRvgM/JEiTOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWbqLLhC9EsopaZHbfrZHsIlJNmbHnm70XcdIppEtkJQoy+szghh1+H19gm94dCA9
         5afWOemRuZ8DMilPfARuW9XtlgXNb0jZWWSiJdXWSkl6xKbiBmLJiCw7IZl65Aogzy
         FeyeWbGMISPhsJ6gOs0HLG3aUAmRNkWAGlyiFro8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/120] ARM: dts: stm32: Fix polarity of the DH DRC02 uSD card detect
Date:   Mon,  8 Feb 2021 16:00:07 +0100
Message-Id: <20210208145819.207162197@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit a0572c0734e4926ac51a31f97c12f752e1cdc7c8 ]

The uSD card detect signal on the DH DRC02 is active-high, with
a default pull down resistor on the board. Invert the polarity.

Fixes: fde180f06d7b ("ARM: dts: stm32: Add DHSOM based DRC02 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
--
Note that this could not be tested on prototype SoMs, now that it is
tested, this issue surfaced, so it needs to be fixed.
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
index 62ab23824a3e7..3299a42d80633 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
@@ -104,7 +104,7 @@
 	 * are used for on-board microSD slot instead.
 	 */
 	/delete-property/broken-cd;
-	cd-gpios = <&gpioi 10 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)>;
+	cd-gpios = <&gpioi 10 GPIO_ACTIVE_HIGH>;
 	disable-wp;
 };
 
-- 
2.27.0



