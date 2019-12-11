Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55D511B81A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfLKPIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbfLKPIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:08:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F070724658;
        Wed, 11 Dec 2019 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076931;
        bh=KY+MWFGnauWcY/Zv39yLl7TdEnCbPv7rV5WnpBMm7rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0mpuGxkU89kyYiSJkg9gOgSpER07suWA0DORGCOgfPSCDq1JEzNoOpkQ8Y0efssj
         2cDCjPWrTbJuOIpDa555L3hH335lbPhNtoh+fVfw+JaDJgLO9vB2poVIy8S5m50ly3
         xpxewzsGn3eQj2y6EiTw86UNmVBvbBHPhKmhtcFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 09/92] staging/octeon: Use stubs for MIPS && !CAVIUM_OCTEON_SOC
Date:   Wed, 11 Dec 2019 16:05:00 +0100
Message-Id: <20191211150223.848490134@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit 17a29fea086ba18b000d28439bd5cb4f2b0a527b upstream.

When building for a non-Cavium MIPS system with COMPILE_TEST=y, the
Octeon ethernet driver hits a number of issues due to use of macros
provided only for CONFIG_CAVIUM_OCTEON_SOC=y configurations. For
example:

  drivers/staging/octeon/ethernet-rx.c:190:6: error:
    'CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE' undeclared (first use in this function)
  drivers/staging/octeon/ethernet-rx.c:472:25: error:
    'OCTEON_IRQ_WORKQ0' undeclared (first use in this function)

These come from various asm/ headers that a non-Octeon build will be
using a non-Octeon version of.

Fix this by using the octeon-stubs.h header for non-Cavium MIPS builds,
and only using the real asm/octeon/ headers when building a Cavium
Octeon kernel configuration.

This requires that octeon-stubs.h doesn't redefine XKPHYS_TO_PHYS, which
is defined for MIPS by asm/addrspace.h which is pulled in by many other
common asm/ headers.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
URL: https://lore.kernel.org/linux-mips/CAMuHMdXvu+BppwzsU9imNWVKea_hoLcRt9N+a29Q-QsjW=ip2g@mail.gmail.com/
Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20191007231741.2012860-1-paul.burton@mips.com
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/octeon/octeon-ethernet.h |    2 +-
 drivers/staging/octeon/octeon-stubs.h    |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/staging/octeon/octeon-ethernet.h
+++ b/drivers/staging/octeon/octeon-ethernet.h
@@ -14,7 +14,7 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 
-#ifdef CONFIG_MIPS
+#ifdef CONFIG_CAVIUM_OCTEON_SOC
 
 #include <asm/octeon/octeon.h>
 
--- a/drivers/staging/octeon/octeon-stubs.h
+++ b/drivers/staging/octeon/octeon-stubs.h
@@ -1,5 +1,8 @@
 #define CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE	512
-#define XKPHYS_TO_PHYS(p)			(p)
+
+#ifndef XKPHYS_TO_PHYS
+# define XKPHYS_TO_PHYS(p)			(p)
+#endif
 
 #define OCTEON_IRQ_WORKQ0 0
 #define OCTEON_IRQ_RML 0


