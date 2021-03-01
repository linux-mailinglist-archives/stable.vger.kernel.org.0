Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCEC328E83
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241677AbhCATdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:33:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241534AbhCAT0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:26:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B80064F48;
        Mon,  1 Mar 2021 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618888;
        bh=v1qgq11IQiNc8b4IKEHQ3qeCbnn0O59oU4+m9UbuUIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ec1CBlK5FoKpwnyymE9wFGmAAyuRR8tJu+lhLj7+gpKUpq/mjjczIhxZD5OoVLawb
         rwgpNLgtO6OrR6wQt987bZoRFymuPce8Jw9aUDBpWkUZoBN3361EQ1uNWgP7OpYlu9
         SvS82rmoPKRk0QTmsQKpsoYh5erEJoD83DcNPgbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/663] irqchip/imx: IMX_INTMUX should not default to y, unconditionally
Date:   Mon,  1 Mar 2021 17:08:22 +0100
Message-Id: <20210301161154.396226994@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a890caeb2ba40ca183969230e204ab144f258357 ]

Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
To fix this, restrict the automatic enabling of IMX_INTMUX to ARCH_MXC,
and ask the user in case of compile-testing.

Fixes: 66968d7dfc3f5451 ("irqchip: Add COMPILE_TEST support for IMX_INTMUX")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210208145605.422943-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 2aa79c32ee228..6156a065681bc 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -464,7 +464,8 @@ config IMX_IRQSTEER
 	  Support for the i.MX IRQSTEER interrupt multiplexer/remapper.
 
 config IMX_INTMUX
-	def_bool y if ARCH_MXC || COMPILE_TEST
+	bool "i.MX INTMUX support" if COMPILE_TEST
+	default y if ARCH_MXC
 	select IRQ_DOMAIN
 	help
 	  Support for the i.MX INTMUX interrupt multiplexer.
-- 
2.27.0



