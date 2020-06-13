Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17331F844B
	for <lists+stable@lfdr.de>; Sat, 13 Jun 2020 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFMQgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jun 2020 12:36:20 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:52816 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgFMQgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jun 2020 12:36:18 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2020 12:36:17 EDT
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 1A54882179C; Sat, 13 Jun 2020 23:28:05 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from himel.orionnet.ru (121.253.33.171.ip.orionnet.ru [171.33.253.121])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id 9306982179C;
        Sat, 13 Jun 2020 23:28:03 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Scott Wood <oss@buserror.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linux-kernel@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>,
        stable@vger.kernel.org
Subject: [PATCH] powerpc/fsl_booke/32: fix build with CONFIG_RANDOMIZE_BASE
Date:   Sat, 13 Jun 2020 23:28:01 +0700
Message-Id: <20200613162801.1946619-1-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building the current 5.8 kernel for a e500 machine with
CONFIG_RANDOMIZE_BASE set yields the following failure:

  arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_early_init':
  arch/powerpc/mm/nohash/kaslr_booke.c:387:2: error: implicit declaration
of function 'flush_icache_range'; did you mean 'flush_tlb_range'?
[-Werror=implicit-function-declaration]

Indeed, including asm/cacheflush.h into kaslr_booke.c fixes the build.

The issue dates back to the introduction of that file and probably went
unnoticed because there's no in-tree defconfig with CONFIG_RANDOMIZE_BASE
set.

Fixes: 2b0e86cc5de6 ("powerpc/fsl_booke/32: implement KASLR infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 arch/powerpc/mm/nohash/kaslr_booke.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 4a75f2d9bf0e..bce0e5349978 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -14,6 +14,7 @@
 #include <linux/memblock.h>
 #include <linux/libfdt.h>
 #include <linux/crash_core.h>
+#include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/kdump.h>
-- 
2.27.0

