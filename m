Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728A245C17A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbhKXNTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347005AbhKXNPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:15:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 224F961AA7;
        Wed, 24 Nov 2021 12:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757836;
        bh=cbAkr7roA/XUOtkCmC8I3swOMtrHElogX+dp0d5mgIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRd6OXe0suvXn5DMIb4hO9dX9vLg5egxmCBoGIxu7O5SUukbMjQRF1E1n8WTKGE6Q
         nMD6j/6E0bpkh9FQnzS5ZXb6IUV9zGRodr+MZPMDu5+JKyFHq6T3fofZ6YuiDrT8UG
         Qwj6Rh8Ocv/a768nck0h/b99L46TKSj/47TMHQAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Artur Rojek <contact@artur-rojek.eu>,
        Paul Cercueil <paul@crapouillou.net>,
        linux-mips@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 291/323] mips: bcm63xx: add support for clk_get_parent()
Date:   Wed, 24 Nov 2021 12:58:01 +0100
Message-Id: <20211124115728.731315256@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e8f67482e5a4bc8d0b65d606d08cb60ee123b468 ]

BCM63XX selects HAVE_LEGACY_CLK but does not provide/support
clk_get_parent(), so add a simple implementation of that
function so that callers of it will build without errors.

Fixes these build errors:

mips-linux-ld: drivers/iio/adc/ingenic-adc.o: in function `jz4770_adc_init_clk_div':
ingenic-adc.c:(.text+0xe4): undefined reference to `clk_get_parent'
mips-linux-ld: drivers/iio/adc/ingenic-adc.o: in function `jz4725b_adc_init_clk_div':
ingenic-adc.c:(.text+0x1b8): undefined reference to `clk_get_parent'

Fixes: e7300d04bd08 ("MIPS: BCM63xx: Add support for the Broadcom BCM63xx family of SOCs." )
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Artur Rojek <contact@artur-rojek.eu>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: linux-mips@vger.kernel.org
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-iio@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: bcm-kernel-feedback-list@broadcom.com
Cc: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm63xx/clk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/bcm63xx/clk.c b/arch/mips/bcm63xx/clk.c
index 164115944a7fd..aba6e2d6a736c 100644
--- a/arch/mips/bcm63xx/clk.c
+++ b/arch/mips/bcm63xx/clk.c
@@ -381,6 +381,12 @@ void clk_disable(struct clk *clk)
 
 EXPORT_SYMBOL(clk_disable);
 
+struct clk *clk_get_parent(struct clk *clk)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(clk_get_parent);
+
 unsigned long clk_get_rate(struct clk *clk)
 {
 	if (!clk)
-- 
2.33.0



