Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257CEA8F62
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387995AbfIDSDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733108AbfIDSDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:03:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4992339D;
        Wed,  4 Sep 2019 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620201;
        bh=/vVKWsKr8PHXAd2ZBVyb90mfEjgyJ4hEIGBSG27XaME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QB6YRvpny1gWQcjTqkUgTNA0tiAoICVWPAzAfHJtMwGL3CRebtSoqE8UX7L3U+XHq
         /mZ8pz5KBCSA9S6CXlBXrrId+W0HIqD01bEPx3Ts59tUR9GmPwnYDuCThFV6ZGWhL6
         dKKEZZkNXFIo8wyaYs+c9dudxBD3xEJ+LXtQHB3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bandan Das <bsd@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 27/57] x86/apic: Include the LDR when clearing out APIC registers
Date:   Wed,  4 Sep 2019 19:53:55 +0200
Message-Id: <20190904175304.578424876@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
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
@@ -1148,6 +1148,10 @@ void clear_local_APIC(void)
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


