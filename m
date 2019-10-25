Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2698E530F
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbfJYSHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46924 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731502AbfJYSFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:45 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xx-0008PH-1x; Fri, 25 Oct 2019 19:05:37 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0001kS-AO; Fri, 25 Oct 2019 19:05:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Vineet Gupta" <vgupta@synopsys.com>
Date:   Fri, 25 Oct 2019 19:03:38 +0100
Message-ID: <lsq.1572026582.551181502@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 37/47] ARC: hide unused function unw_hdr_alloc
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit fd5de2721ea7d16e2b16c4049ac49f229551b290 upstream.

As kernelci.org reports, this function is not used in
vdk_hs38_defconfig:

arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but not used [-Wunused-function]

Fixes: bc79c9a72165 ("ARC: dw2 unwind: Reinstante unwinding out of modules")
Link: https://kernelci.org/build/id/5d1cae3f59b514300340c132/logs/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arc/kernel/unwind.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/arc/kernel/unwind.c
+++ b/arch/arc/kernel/unwind.c
@@ -183,11 +183,6 @@ static void *__init unw_hdr_alloc_early(
 				       MAX_DMA_ADDRESS);
 }
 
-static void *unw_hdr_alloc(unsigned long sz)
-{
-	return kmalloc(sz, GFP_KERNEL);
-}
-
 static void init_unwind_table(struct unwind_table *table, const char *name,
 			      const void *core_start, unsigned long core_size,
 			      const void *init_start, unsigned long init_size,
@@ -368,6 +363,10 @@ static void init_unwind_hdr(struct unwin
 }
 
 #ifdef CONFIG_MODULES
+static void *unw_hdr_alloc(unsigned long sz)
+{
+	return kmalloc(sz, GFP_KERNEL);
+}
 
 static struct unwind_table *last_table;
 

