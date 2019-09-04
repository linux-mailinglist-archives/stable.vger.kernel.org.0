Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E92A8F02
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733156AbfIDSBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388533AbfIDSBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:01:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E792339D;
        Wed,  4 Sep 2019 18:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620076;
        bh=d+AOmtSRkPLxq726y6RApsJJKUrt5FlgLRur9jxsM3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAwR+zVYg/UJ28mhB7LkQH0EX5ebOrsAcHI4S6bDi4XWUkrpQPvTYUqi6qmeMZ+WM
         UT+2yJTIr0dNhNCx6Y0mdg70NTCk0hGelHUA+Uf1tXwfn9q2Et9y8LGS74H8unai5F
         mLB37yKOaNP+NW7vHBp+IlXv0yiUqGcZhBbCy7aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bandan Das <bsd@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 63/83] x86/apic: Include the LDR when clearing out APIC registers
Date:   Wed,  4 Sep 2019 19:53:55 +0200
Message-Id: <20190904175309.164387222@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

commit 558682b5291937a70748d36fd9ba757fb25b99ae upstream.

Although APIC initialization will typically clear out the LDR before
setting it, the APIC cleanup code should reset the LDR.

This was discovered with a 32-bit KVM guest jumping into a kdump
kernel. The stale bits in the LDR triggered a bug in the KVM APIC
implementation which caused the destination mapping for VCPUs to be
corrupted.

Note that this isn't intended to paper over the KVM APIC bug. The kernel
has to clear the LDR when resetting the APIC registers except when X2APIC
is enabled.

This lacks a Fixes tag because missing to clear LDR goes way back into pre
git history.

[ tglx: Made x2apic_enabled a function call as required ]

Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190826101513.5080-3-bsd@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/apic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1067,6 +1067,10 @@ void clear_local_APIC(void)
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 	v = apic_read(APIC_LVT1);
 	apic_write(APIC_LVT1, v | APIC_LVT_MASKED);
+	if (!x2apic_enabled()) {
+		v = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
+		apic_write(APIC_LDR, v);
+	}
 	if (maxlvt >= 4) {
 		v = apic_read(APIC_LVTPC);
 		apic_write(APIC_LVTPC, v | APIC_LVT_MASKED);


