Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE13838A0FE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhETJ1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231820AbhETJ04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 357CD61279;
        Thu, 20 May 2021 09:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502735;
        bh=GGYeuE3Kf1KuUNPDu9rHsOC+PjsoL5g6WqM8hbssvJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXFCDgZ8xe9Xkytr1kUiI/midVsjxdSVcLyre6ZHjaUxdrTaIONfDPwEzfPlflN7k
         Rq+8DPP2PXvdn14OuqVXRId75bsg9ctaltKdi2sSAOo1kyqEMeq0oGQ05s0qfQ95jx
         vwX+iAc7ohaDzBJZI/hHeRP6PDdQW4daBG7an5zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.12 04/45] kgdb: fix gcc-11 warning on indentation
Date:   Thu, 20 May 2021 11:21:52 +0200
Message-Id: <20210520092053.669870330@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 40cc3a80bb42587db1e6ae21d6f3090582d33e89 upstream.

gcc-11 starts warning about misleading indentation inside of macros:

drivers/misc/kgdbts.c: In function ‘kgdbts_break_test’:
drivers/misc/kgdbts.c:103:9: error: this ‘if’ clause does not guard... [-Werror=misleading-indentation]
  103 |         if (verbose > 1) \
      |         ^~
drivers/misc/kgdbts.c:200:9: note: in expansion of macro ‘v2printk’
  200 |         v2printk("kgdbts: breakpoint complete\n");
      |         ^~~~~~~~
drivers/misc/kgdbts.c:105:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the ‘if’
  105 |                 touch_nmi_watchdog();   \
      |                 ^~~~~~~~~~~~~~~~~~

The code looks correct to me, so just reindent it for readability.

Fixes: e8d31c204e36 ("kgdb: add kgdb internal test suite")
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210322164308.827846-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/kgdbts.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -95,19 +95,19 @@
 
 #include <asm/sections.h>
 
-#define v1printk(a...) do { \
-	if (verbose) \
-		printk(KERN_INFO a); \
-	} while (0)
-#define v2printk(a...) do { \
-	if (verbose > 1) \
-		printk(KERN_INFO a); \
-		touch_nmi_watchdog();	\
-	} while (0)
-#define eprintk(a...) do { \
-		printk(KERN_ERR a); \
-		WARN_ON(1); \
-	} while (0)
+#define v1printk(a...) do {		\
+	if (verbose)			\
+		printk(KERN_INFO a);	\
+} while (0)
+#define v2printk(a...) do {		\
+	if (verbose > 1)		\
+		printk(KERN_INFO a);	\
+	touch_nmi_watchdog();		\
+} while (0)
+#define eprintk(a...) do {		\
+	printk(KERN_ERR a);		\
+	WARN_ON(1);			\
+} while (0)
 #define MAX_CONFIG_LEN		40
 
 static struct kgdb_io kgdbts_io_ops;


