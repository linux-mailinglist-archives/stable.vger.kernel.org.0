Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A253DD8C7
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbhHBNz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235379AbhHBNxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83AB561152;
        Mon,  2 Aug 2021 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912324;
        bh=kLQyYho5OEJBNTSuOy5Qaz0n86WVDzpbQPXSzpVPAZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mo+lvmKyj3/4ZpU/tXhQ3NZY9X1gBm8cfFKSpMLL8OyZeBvpsmYlVNtQwzTnqx1LZ
         S6BIKMlaCSWOXsbHrO/ZBuq1voPVEaUsR4LmtsDaSSe2phmooyQvg3NELkOUmvaDay
         d8TWTFqiejlIEUGT88yzJdc6fEnrTOODbSfXGDyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 06/40] x86/kvm: fix vcpu-id indexed array sizes
Date:   Mon,  2 Aug 2021 15:44:46 +0200
Message-Id: <20210802134335.604829665@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
@@ -91,7 +91,7 @@ static unsigned long ioapic_read_indirec
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
 
 


