Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A051128B7EC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgJLNry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389769AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1AFD208B8;
        Mon, 12 Oct 2020 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510343;
        bh=tJmT2y/FrIAr0MGCssRr4tjanVeOY5jttuPUMfr1Ado=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnMgo8AzlhTxO3SpBfjS2yPP7VP8ii9+XF10qs6lV+7nsF/DwtdmuQnrkgqh70JWd
         nLN7/3UUsdgUpk6M6ndjdSyEveR9LofsfyRGzzeau/QgG12o5xAXj2uUSMpVLi2ovq
         LM/WLFx/Cz71CMKPmy2qHjHkVVcaYdGV2orsnAEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        mark gross <mgross@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 059/124] platform/x86: fix kconfig dependency warning for LG_LAPTOP
Date:   Mon, 12 Oct 2020 15:31:03 +0200
Message-Id: <20201012133149.717102975@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 8f0c01e666685c4d2e1a233e6f4d7ab16c9f8b2a ]

When LG_LAPTOP is enabled and NEW_LEDS is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for LEDS_CLASS
  Depends on [n]: NEW_LEDS [=n]
  Selected by [y]:
  - LG_LAPTOP [=y] && X86 [=y] && X86_PLATFORM_DEVICES [=y] && ACPI [=y] && ACPI_WMI [=y] && INPUT [=y]

The reason is that LG_LAPTOP selects LEDS_CLASS without depending on or
selecting NEW_LEDS while LEDS_CLASS is subordinate to NEW_LEDS.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: dbf0c5a6b1f8 ("platform/x86: Add LG Gram laptop special features driver")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: mark gross <mgross@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 0581a54cf562f..e1668a9538c8f 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1091,6 +1091,7 @@ config LG_LAPTOP
 	depends on ACPI_WMI
 	depends on INPUT
 	select INPUT_SPARSEKMAP
+	select NEW_LEDS
 	select LEDS_CLASS
 	help
 	 This driver adds support for hotkeys as well as control of keyboard
-- 
2.25.1



