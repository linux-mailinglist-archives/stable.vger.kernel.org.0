Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F373DD7F9
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhHBNsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234474AbhHBNs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E06E361029;
        Mon,  2 Aug 2021 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912099;
        bh=RUh4AusaX0Jn78izoGVYrMovVe91oBO13ieA2j5M3WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/G11u0s+WmdTAkzotxDhI+mG1tiJ62JVjkZkUWsr+aDNfvsWE2YsZjKFkit1KA/D
         IAtrZZEZTsNXgN9L9Ya3Iq+D9J2C0pwqwOuvaBYg4+MHd4XQVlTpWnLDGLAyzL3Tsr
         A8mv9FhsMD68fyywbFza6a24uLku2g+L+KlvPgCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 16/38] x86/kvm: fix vcpu-id indexed array sizes
Date:   Mon,  2 Aug 2021 15:44:38 +0200
Message-Id: <20210802134335.346946965@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 76b4f357d0e7d8f6f0013c733e6cba1773c266d3 upstream.

KVM_MAX_VCPU_ID is the maximum vcpu-id of a guest, and not the number
of vcpu-ids. Fix array indexed by vcpu-id to have KVM_MAX_VCPU_ID+1
elements.

Note that this is currently no real problem, as KVM_MAX_VCPU_ID is
an odd number, resulting in always enough padding being available at
the end of those arrays.

Nevertheless this should be fixed in order to avoid rare problems in
case someone is using an even number for KVM_MAX_VCPU_ID.

Signed-off-by: Juergen Gross <jgross@suse.com>
Message-Id: <20210701154105.23215-2-jgross@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/ioapic.c |    2 +-
 arch/x86/kvm/ioapic.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirec
 static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
 {
 	ioapic->rtc_status.pending_eoi = 0;
-	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
+	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
 }
 
 static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -43,13 +43,13 @@ struct kvm_vcpu;
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
+	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
 
 	/*
 	 * Vector sent to a given vcpu, only valid when
 	 * the vcpu's bit in map is set
 	 */
-	u8 vectors[KVM_MAX_VCPU_ID];
+	u8 vectors[KVM_MAX_VCPU_ID + 1];
 };
 
 


