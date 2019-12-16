Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052661216B3
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfLPSMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730428AbfLPSMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87900206E0;
        Mon, 16 Dec 2019 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519923;
        bh=BwSct2I91Z70qutOSsbyocDgk2SHOEB2uZh27rDiUZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncTSSfwdiBs02bZD2O2ZrGcsnIl0Vo6lerEz1CLDzQCtgV2pV09SJGhBuTcZ5llaF
         FWVEOYH6bESBYObHIs5Hpiv+YnEvI2wqpQV13cm0CzKw6zLNLSMDBzhunrC9Q4VTbV
         pqV036XhS7E7O53KJV9yD/msXBsEYwTTDXAPzFYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 125/180] powerpc/xive: Prevent page fault issues in the machine crash handler
Date:   Mon, 16 Dec 2019 18:49:25 +0100
Message-Id: <20191216174841.211849622@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit 1ca3dec2b2dff9d286ce6cd64108bda0e98f9710 upstream.

When the machine crash handler is invoked, all interrupts are masked
but interrupts which have not been started yet do not have an ESB page
mapped in the Linux address space. This crashes the 'crash kexec'
sequence on sPAPR guests.

To fix, force the mapping of the ESB page when an interrupt is being
mapped in the Linux IRQ number space. This is done by setting the
initial state of the interrupt to OFF which is not necessarily the
case on PowerNV.

Fixes: 243e25112d06 ("powerpc/xive: Native exploitation of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191031063100.3864-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/sysdev/xive/common.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1000,6 +1000,15 @@ static int xive_irq_alloc_data(unsigned
 	xd->target = XIVE_INVALID_TARGET;
 	irq_set_handler_data(virq, xd);
 
+	/*
+	 * Turn OFF by default the interrupt being mapped. A side
+	 * effect of this check is the mapping the ESB page of the
+	 * interrupt in the Linux address space. This prevents page
+	 * fault issues in the crash handler which masks all
+	 * interrupts.
+	 */
+	xive_esb_read(xd, XIVE_ESB_SET_PQ_01);
+
 	return 0;
 }
 


