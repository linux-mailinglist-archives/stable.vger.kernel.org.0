Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268BE6C771
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389921AbfGRDYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390190AbfGRDGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:06:21 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC562053B;
        Thu, 18 Jul 2019 03:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419180;
        bh=gcoQcpHmMYKJvS8eyy4TEbIp704nm07q9cjihtk1UQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3TeyY/6PbUd1wafyGO/Roj3y3eYumeGm7MuqbFsg7wHflct7P2aBd+NZSMR2k4J2
         7PeyhbemRAso8IAc2dSXrtVJQPNpGSgqNGQyS5+/ZWXtmq2OpOgsaOXb25A5SWMqw4
         xxzUMjBoxf89xVBPVN9Fqep8vdTwx6i5F4rOdQ/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.1 47/54] ARC: hide unused function unw_hdr_alloc
Date:   Thu, 18 Jul 2019 12:01:42 +0900
Message-Id: <20190718030056.830149362@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit fd5de2721ea7d16e2b16c4049ac49f229551b290 upstream.

As kernelci.org reports, this function is not used in
vdk_hs38_defconfig:

arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but not used [-Wunused-function]

Fixes: bc79c9a72165 ("ARC: dw2 unwind: Reinstante unwinding out of modules")
Link: https://kernelci.org/build/id/5d1cae3f59b514300340c132/logs/
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/unwind.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/arc/kernel/unwind.c
+++ b/arch/arc/kernel/unwind.c
@@ -184,11 +184,6 @@ static void *__init unw_hdr_alloc_early(
 	return memblock_alloc_from(sz, sizeof(unsigned int), MAX_DMA_ADDRESS);
 }
 
-static void *unw_hdr_alloc(unsigned long sz)
-{
-	return kmalloc(sz, GFP_KERNEL);
-}
-
 static void init_unwind_table(struct unwind_table *table, const char *name,
 			      const void *core_start, unsigned long core_size,
 			      const void *init_start, unsigned long init_size,
@@ -369,6 +364,10 @@ ret_err:
 }
 
 #ifdef CONFIG_MODULES
+static void *unw_hdr_alloc(unsigned long sz)
+{
+	return kmalloc(sz, GFP_KERNEL);
+}
 
 static struct unwind_table *last_table;
 


