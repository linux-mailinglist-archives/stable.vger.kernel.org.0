Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34D14125C9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384605AbhITSs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384028AbhITSq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A330D61AFE;
        Mon, 20 Sep 2021 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159203;
        bh=GtAz6a0Xn/a5dVpSrAYarcdx2uWZsIINFWCN4NvS7Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpMVjM4hUTHfCxTEgfnz57dtSqlgFisOtOnqP9jEAik14reokL/Hsc7UxW0gn3tpq
         v7B9tXg3VwKOdus61hr4t+1SM870V5HbEp8aibTMxuqwrbWWKkDu3K7VNEXuGCPv7Q
         CzB56dGZpbbI3iyPbbfhMRh4EWYsES2Ez23gLpNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 123/168] PCI: controller: PCI_IXP4XX should depend on ARCH_IXP4XX
Date:   Mon, 20 Sep 2021 18:44:21 +0200
Message-Id: <20210920163925.704051309@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9f1168cf263aab0474300f7118107f8ef73e7423 ]

The Intel IXP4xx PCI controller is only present on Intel IXP4xx
XScale-based network processor SoCs.

Add a dependency on ARCH_IXP4XX, to prevent asking the user about this
driver when configuring a kernel without support for the XScale
processor family.

Link: https://lore.kernel.org/r/6a88e55fe58fc280f4ff1ca83c154e4895b6dcbf.1624972789.git.geert+renesas@glider.be
Fixes: f7821b4934584824 ("PCI: ixp4xx: Add a new driver for IXP4xx")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
index 5e1e3796efa4..326f7d13024f 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -40,6 +40,7 @@ config PCI_FTPCI100
 config PCI_IXP4XX
 	bool "Intel IXP4xx PCI controller"
 	depends on ARM && OF
+	depends on ARCH_IXP4XX || COMPILE_TEST
 	default ARCH_IXP4XX
 	help
 	  Say Y here if you want support for the PCI host controller found
-- 
2.30.2



