Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8B9313773
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhBHPZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233718AbhBHPVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6AB764EEE;
        Mon,  8 Feb 2021 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797191;
        bh=2jRD/+vUlcAh4Q/IiAcqlQLJf40XZtUywx8UV4WjHGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tbQtQw7Dar6sZnzCZPhnVSwQ5Nw+X/U7Kl1oIS0w8yeRegWs3pRnt4JDZ5SVw3sO
         l3gGw20SYh8urEaEZU6RjXZ2Ej17k0W+eSHTq3mkTnWg7OE4uq5xKxh8aWwHOqZ0dX
         xEialYI9eICWhtsaYLzcUkyrGfDXm1QucDEAeiI4=
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
Subject: [PATCH 5.10 023/120] ARM: dts: stm32: Disable optional TSC2004 on DRC02 board
Date:   Mon,  8 Feb 2021 16:00:10 +0100
Message-Id: <20210208145819.329733830@linuxfoundation.org>
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

[ Upstream commit 087698939f30d489e785d7df3e6aa5dce2487b39 ]

The DRC02 has no use for the on-SoM touchscreen controller, and the
on-SoM touchscreen controller may not even be populated, which then
results in error messages in kernel log. Disable the touchscreen
controller in DT.

Fixes: fde180f06d7b ("ARM: dts: stm32: Add DHSOM based DRC02 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
index 3299a42d80633..4cabdade6432b 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
@@ -87,6 +87,12 @@
 	};
 };
 
+&i2c4 {
+	touchscreen@49 {
+		status = "disabled";
+	};
+};
+
 &i2c5 {	/* TP7/TP8 */
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c5_pins_a>;
-- 
2.27.0



