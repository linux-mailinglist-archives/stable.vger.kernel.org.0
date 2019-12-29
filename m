Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE0612C939
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732945AbfL2SCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732737AbfL2Rym (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7242D206DB;
        Sun, 29 Dec 2019 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642081;
        bh=Jr8t59oHCU9w4yalef6PIXJgCoErclWXFy6+f+VOfrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/oAt46Cqt/pCGHDGq5lRkxZ9EfCTUetNc3LdbbecnwYVOHEjAzJovALdh2kVm0oV
         urvLL/M96718S/oJdmFYfGzfwkx7wcBCeuVKDi8lgot6dYjFKhMXDmOQIj+5qfO4WW
         +gnb+e9iYFHTncfslQcMBP4RUDbf3T4AscsIr1OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 335/434] s390/kasan: support memcpy_real with TRACE_IRQFLAGS
Date:   Sun, 29 Dec 2019 18:26:28 +0100
Message-Id: <20191229172724.220761956@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 13f9bae579c6bd051e58f326913dd09af1291208 ]

Currently if the kernel is built with CONFIG_TRACE_IRQFLAGS and KASAN
and used as crash kernel it crashes itself due to
trace_hardirqs_off/trace_hardirqs_on being called with DAT off. This
happens because trace_hardirqs_off/trace_hardirqs_on are instrumented and
kasan code tries to perform access to shadow memory to validate memory
accesses. Kasan shadow memory is populated with vmemmap, so all accesses
require DAT on.

memcpy_real could be called with DAT on or off (with kasan enabled DAT
is set even before early code is executed).

Make sure that trace_hardirqs_off/trace_hardirqs_on are called with DAT
on and only actual __memcpy_real is called with DAT off.

Also annotate __memcpy_real and _memcpy_real with __no_sanitize_address
to avoid further problems due to switching DAT off.

Reviewed-by: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/maccess.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 1864a8bb9622..59ad7997fed1 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -70,7 +70,7 @@ void notrace s390_kernel_write(void *dst, const void *src, size_t size)
 	spin_unlock_irqrestore(&s390_kernel_write_lock, flags);
 }
 
-static int __memcpy_real(void *dest, void *src, size_t count)
+static int __no_sanitize_address __memcpy_real(void *dest, void *src, size_t count)
 {
 	register unsigned long _dest asm("2") = (unsigned long) dest;
 	register unsigned long _len1 asm("3") = (unsigned long) count;
@@ -91,19 +91,23 @@ static int __memcpy_real(void *dest, void *src, size_t count)
 	return rc;
 }
 
-static unsigned long _memcpy_real(unsigned long dest, unsigned long src,
-				  unsigned long count)
+static unsigned long __no_sanitize_address _memcpy_real(unsigned long dest,
+							unsigned long src,
+							unsigned long count)
 {
 	int irqs_disabled, rc;
 	unsigned long flags;
 
 	if (!count)
 		return 0;
-	flags = __arch_local_irq_stnsm(0xf8UL);
+	flags = arch_local_irq_save();
 	irqs_disabled = arch_irqs_disabled_flags(flags);
 	if (!irqs_disabled)
 		trace_hardirqs_off();
+	__arch_local_irq_stnsm(0xf8); // disable DAT
 	rc = __memcpy_real((void *) dest, (void *) src, (size_t) count);
+	if (flags & PSW_MASK_DAT)
+		__arch_local_irq_stosm(0x04); // enable DAT
 	if (!irqs_disabled)
 		trace_hardirqs_on();
 	__arch_local_irq_ssm(flags);
-- 
2.20.1



