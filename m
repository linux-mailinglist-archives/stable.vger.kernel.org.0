Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5505C616A5
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfGGTlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57840 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727642AbfGGTiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:15 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzD-0006ji-0j; Sun, 07 Jul 2019 20:38:11 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0005ev-75; Sun, 07 Jul 2019 20:38:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Nathan Chancellor" <natechancellor@gmail.com>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.909156221@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 107/129] cpufreq: pxa2xx: remove incorrect __init
 annotation
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 9505b98ccddc454008ca7efff90044e3e857c827 upstream.

pxa_cpufreq_init_voltages() is marked __init but usually inlined into
the non-__init pxa_cpufreq_init() function. When building with clang,
it can stay as a standalone function in a discarded section, and produce
this warning:

WARNING: vmlinux.o(.text+0x616a00): Section mismatch in reference from the function pxa_cpufreq_init() to the function .init.text:pxa_cpufreq_init_voltages()
The function pxa_cpufreq_init() references
the function __init pxa_cpufreq_init_voltages().
This is often because pxa_cpufreq_init lacks a __init
annotation or the annotation of pxa_cpufreq_init_voltages is wrong.

Fixes: 50e77fcd790e ("ARM: pxa: remove __init from cpufreq_driver->init()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -191,7 +191,7 @@ static int pxa_cpufreq_change_voltage(px
 	return ret;
 }
 
-static void __init pxa_cpufreq_init_voltages(void)
+static void pxa_cpufreq_init_voltages(void)
 {
 	vcc_core = regulator_get(NULL, "vcc_core");
 	if (IS_ERR(vcc_core)) {
@@ -207,7 +207,7 @@ static int pxa_cpufreq_change_voltage(px
 	return 0;
 }
 
-static void __init pxa_cpufreq_init_voltages(void) { }
+static void pxa_cpufreq_init_voltages(void) { }
 #endif
 
 static void find_freq_tables(struct cpufreq_frequency_table **freq_table,

