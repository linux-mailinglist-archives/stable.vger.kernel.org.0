Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB3A395F7E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhEaOL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhEaOJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:09:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E46761971;
        Mon, 31 May 2021 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468429;
        bh=1hTUnAuEtZd3tinnFT/q6OSKEpQDZ08WXxy2j2oPjDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyK7YX0eQPiyDcklCMKUyqT7tRp+Hbjv//nYNz0pKVoxRPUWbssOtHAN/AGsBUM2g
         qPsHGIH5GNTWLbto6pAOewcrBGeh8KPrMtMMUnsyhOYvpSr7TnWthnBIiku1S7gjH2
         OGI4jWADC95T/u+P/4AJZThWQewMI2N56m15WeC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@iguana.be>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/252] MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c
Date:   Mon, 31 May 2021 15:15:05 +0200
Message-Id: <20210531130706.159826423@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit fef532ea0cd871afab7d9a7b6e9da99ac2c24371 ]

rt2880_wdt.c uses (well, attempts to use) rt_sysc_membase. However,
when this watchdog driver is built as a loadable module, there is a
build error since the rt_sysc_membase symbol is not exported.
Export it to quell the build error.

ERROR: modpost: "rt_sysc_membase" [drivers/watchdog/rt2880_wdt.ko] undefined!

Fixes: 473cf939ff34 ("watchdog: add ralink watchdog driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: John Crispin <john@phrozen.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/of.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index cbae9d23ab7f..a971f1aca096 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -8,6 +8,7 @@
 
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/sizes.h>
 #include <linux/of_fdt.h>
@@ -25,6 +26,7 @@
 
 __iomem void *rt_sysc_membase;
 __iomem void *rt_memc_membase;
+EXPORT_SYMBOL_GPL(rt_sysc_membase);
 
 __iomem void *plat_of_remap_node(const char *node)
 {
-- 
2.30.2



