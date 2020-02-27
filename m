Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603F7171CD5
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388964AbgB0OPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:15:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388403AbgB0OPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:15:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8620320578;
        Thu, 27 Feb 2020 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812940;
        bh=qeuyLHc7L0dkcvrU9U/EoihFhJn/C0c0dFgiBvVErrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMAL0J/Ol9nWsYe7zRP38aK/vdY9M6BqeAaRVSFDpXxSNDdT4e39vWVmpcNs1srfU
         FA95cKTtqeEDsylfjPP4st3sEZnWihgKA0nTceAzya33wwLz6I2Gz4BeHmmmjib0wq
         2bc6GoOTiqzQEoBSJlFlhlQ+48fpOWROdSwoCMNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.5 075/150] genirq/irqdomain: Make sure all irq domain flags are distinct
Date:   Thu, 27 Feb 2020 14:36:52 +0100
Message-Id: <20200227132243.931133271@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

commit 2546287c5fb363a0165933ae2181c92f03e701d0 upstream.

This was noticed when printing debugfs for MSIs on my ARM64 server.  The
new dstate IRQD_MSI_NOMASK_QUIRK came out surprisingly while it should only
be the x86 stuff for the time being...

The new MSI quirk flag uses the same bit as IRQ_DOMAIN_NAME_ALLOCATED which
is oddly defined as bit 6 for no good reason.

Switch it to the non used bit 1.

Fixes: 6f1a4891a592 ("x86/apic/msi: Plug non-maskable MSI affinity race")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200221020725.2038-1-yuzenghui@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/irqdomain.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -192,7 +192,7 @@ enum {
 	IRQ_DOMAIN_FLAG_HIERARCHY	= (1 << 0),
 
 	/* Irq domain name was allocated in __irq_domain_add() */
-	IRQ_DOMAIN_NAME_ALLOCATED	= (1 << 6),
+	IRQ_DOMAIN_NAME_ALLOCATED	= (1 << 1),
 
 	/* Irq domain is an IPI domain with virq per cpu */
 	IRQ_DOMAIN_FLAG_IPI_PER_CPU	= (1 << 2),


