Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A8737CBF1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbhELQjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240186AbhELQab (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF53461C1C;
        Wed, 12 May 2021 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835053;
        bh=CnPcuIfL/kFVx0I4okBPSIqzFp3kQPQh3KTFFdhdSQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUPGiH2vgGZYFFWiJTgFfB2KFtn/Tst27EhEtNgWflsPQLWmqIvZLI/ElJ3w6O1yj
         eBB9BL4W6/pbUtTjUOuWD9xI0/3vzJaDk2GvG5NNlOTImH19C3X/5y8s/1ngk9gfmn
         pGWguYHMT/UNHbS6JB5qAP0MGhPYJhTPiFOTRa4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 154/677] ARM: dts: s5pv210: correct fuel gauge interrupt trigger level on Fascinate family
Date:   Wed, 12 May 2021 16:43:20 +0200
Message-Id: <20210512144842.359325337@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 214e6ec8c9f5a3353d3282b3ff475d3ee86cc21a ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: 99bb20321f0e ("ARM: dts: s5pv210: Correct fuelgauge definition on Aries")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-10-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-fascinate4g.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-fascinate4g.dts b/arch/arm/boot/dts/s5pv210-fascinate4g.dts
index ca064359dd30..b47d8300e536 100644
--- a/arch/arm/boot/dts/s5pv210-fascinate4g.dts
+++ b/arch/arm/boot/dts/s5pv210-fascinate4g.dts
@@ -115,7 +115,7 @@
 	compatible = "maxim,max77836-battery";
 
 	interrupt-parent = <&gph3>;
-	interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+	interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 
 	pinctrl-names = "default";
 	pinctrl-0 = <&fg_irq>;
-- 
2.30.2



