Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77572C09F1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbgKWNO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733168AbgKWMp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E6E220732;
        Mon, 23 Nov 2020 12:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135525;
        bh=oDLcnlMwN2wjgBOiQff4OUc5Gb+aQjsmoFbBbC1knpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxTdhvF+x4AIVib2eBw54p/j7+yGhkpdpry8/MTj9VARf7XzG3ufa+y1hQuVRq3Ae
         DWgyjl0rlIbqxD82pU03neCG0/PnzzpElh20VqV6iuLy/AbeO78BfTuirE3yomfWc/
         2hOIPv81BSO9f4Kv8iWYfzSJ8BIKDdnf6BfyDqdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 099/252] ARM: dts: vf610-zii-dev-rev-b: Fix MDIO over clocking
Date:   Mon, 23 Nov 2020 13:20:49 +0100
Message-Id: <20201123121840.361203148@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit f8b5a33707c9a19ec905d2826be0acd151997a09 ]

The ZII devel B board has two generations of Marvell Switches.  The
mv88e6352 supports an MDIO clock of 12MHz. However the older 88e6185
does not like 12MHz, and often fails to probe.

Reduce the clock speed to 5MHz, which seems to work reliably.

Cc: Chris Healy <cphealy@gmail.com>
Fixes: b955387667ec ("ARM: dts: ZII: update MDIO speed and preamble")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index e500911ce0a59..6f1e0f0d4f0ae 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -406,6 +406,9 @@
 	};
 };
 
+&mdio1 {
+	clock-frequency = <5000000>;
+};
 
 &iomuxc {
 	pinctrl_gpio_e6185_eeprom_sel: pinctrl-gpio-e6185-eeprom-spi0 {
-- 
2.27.0



