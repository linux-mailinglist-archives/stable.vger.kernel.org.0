Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD321F3AB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfEOLCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbfEOLCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E9FA2184C;
        Wed, 15 May 2019 11:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918139;
        bh=H7jQuRGhdlUc72cXuQ+AixjPhH1t7a9OYtkO8VSmaN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXcCW3ws2qiLqMO7t0RespRO7gmP6SrY3Vn+9Sd0ahbWtx7wN4cTSfSWOhPUfY5kn
         jNgGk1lavC0E5m6i7lxAHaMgHBNYDTm2dG96I3rOcvCoYELdAb0JHwxH35V+uBmIpJ
         kAVg1pyMXYIK+E7dZt6YJfU1xbYatwj2/m4uAz2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 4.4 020/266] powerpc/rfi-flush: Differentiate enabled and patched flush types
Date:   Wed, 15 May 2019 12:52:07 +0200
Message-Id: <20190515090723.283267288@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

commit 0063d61ccfc011f379a31acaeba6de7c926fed2c upstream.

Currently the rfi-flush messages print 'Using <type> flush' for all
enabled_flush_types, but that is not necessarily true -- as now the
fallback flush is always enabled on pseries, but the fixup function
overwrites its nop/branch slot with other flush types, if available.

So, replace the 'Using <type> flush' messages with '<type> flush is
available'.

Also, print the patched flush types in the fixup function, so users
can know what is (not) being used (e.g., the slower, fallback flush,
or no flush type at all if flush is disabled via the debugfs switch).

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/setup_64.c    |    6 +++---
 arch/powerpc/lib/feature-fixups.c |    9 ++++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -911,15 +911,15 @@ static void init_fallback_flush(void)
 void setup_rfi_flush(enum l1d_flush_type types, bool enable)
 {
 	if (types & L1D_FLUSH_FALLBACK) {
-		pr_info("rfi-flush: Using fallback displacement flush\n");
+		pr_info("rfi-flush: fallback displacement flush available\n");
 		init_fallback_flush();
 	}
 
 	if (types & L1D_FLUSH_ORI)
-		pr_info("rfi-flush: Using ori type flush\n");
+		pr_info("rfi-flush: ori type flush available\n");
 
 	if (types & L1D_FLUSH_MTTRIG)
-		pr_info("rfi-flush: Using mttrig type flush\n");
+		pr_info("rfi-flush: mttrig type flush available\n");
 
 	enabled_flush_types = types;
 
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -151,7 +151,14 @@ void do_rfi_flush_fixups(enum l1d_flush_
 		patch_instruction(dest + 2, instrs[2]);
 	}
 
-	printk(KERN_DEBUG "rfi-flush: patched %d locations\n", i);
+	printk(KERN_DEBUG "rfi-flush: patched %d locations (%s flush)\n", i,
+		(types == L1D_FLUSH_NONE)       ? "no" :
+		(types == L1D_FLUSH_FALLBACK)   ? "fallback displacement" :
+		(types &  L1D_FLUSH_ORI)        ? (types & L1D_FLUSH_MTTRIG)
+							? "ori+mttrig type"
+							: "ori type" :
+		(types &  L1D_FLUSH_MTTRIG)     ? "mttrig type"
+						: "unknown");
 }
 #endif /* CONFIG_PPC_BOOK3S_64 */
 


