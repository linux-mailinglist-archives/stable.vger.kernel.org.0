Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E32F38A13C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhETJ3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232062AbhETJ16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CCF56121E;
        Thu, 20 May 2021 09:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502790;
        bh=GGYeuE3Kf1KuUNPDu9rHsOC+PjsoL5g6WqM8hbssvJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSYB7qWfoXN51XbmDSgk8ggK9hCMeBw4rDU+61iscl7tdo3NnQ/yP8JVS5b5429vx
         PJIDoQ0AIUP62zqI8mkWbLElmEjbd8j6z8cpA0cyoL/TLyW0uS6qSVEhKqBdfdfS+l
         CwNqBmMAl5EjPjyl4XLALBzOXUAxJMuLJxQxYJn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 04/47] kgdb: fix gcc-11 warning on indentation
Date:   Thu, 20 May 2021 11:22:02 +0200
Message-Id: <20210520092053.702373767@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
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


