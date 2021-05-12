Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC21037C7BB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhELQCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238104AbhELP5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E09AD6147F;
        Wed, 12 May 2021 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833412;
        bh=CnPcuIfL/kFVx0I4okBPSIqzFp3kQPQh3KTFFdhdSQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVcny4+ZQOOeCQWBqbqMaVB4T66oJbxrtK97T5zfzEKiCzHoQYyZbgj0skIvDOLEG
         erF2eC+zfNG19RbSng+K1jh42sqGHWyfTwotHdouI3nkWo3exrUzUk0n1FdTIeUVcW
         fIf+EgpEXnrbVmlPufdRF8uNhWqP6jntfJF7hsQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 138/601] ARM: dts: s5pv210: correct fuel gauge interrupt trigger level on Fascinate family
Date:   Wed, 12 May 2021 16:43:35 +0200
Message-Id: <20210512144832.365699169@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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



