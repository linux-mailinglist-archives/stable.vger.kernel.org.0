Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FCF15C620
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgBMP53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387426AbgBMPZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:17 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118A6246B8;
        Thu, 13 Feb 2020 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607517;
        bh=IN7l4G+4LWj95121YEyH+9pMzUm77MeEanL247j7Jiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Nc3obp8rvsF+UE6t/fxHtm1mBeNrA5lBR76KHtKEB28Sm8nZO8s6DGvIOJPEjN7Q
         wVagWENrLG6giFXu3Hkm58+pOiyk3vheIhHVQEm8bK/3MsOUg3G2ybnqxlAQT7Ce1t
         QJputerjHRvZGWwHq+lgf2yWZB+rnueKXL0c3SF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 081/173] KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:19:44 -0800
Message-Id: <20200213151953.902767159@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 4bf79cb089f6b1c6c632492c0271054ce52ad766 upstream.

This fixes a Spectre-v1/L1TF vulnerability in kvm_lapic_reg_write().
This function contains index computations based on the
(attacker-controlled) MSR number.

Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1754,15 +1754,20 @@ int kvm_lapic_reg_write(struct kvm_lapic
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
 	case APIC_LVT1:
-	case APIC_LVTERR:
+	case APIC_LVTERR: {
 		/* TODO: Check vector */
+		size_t size;
+		u32 index;
+
 		if (!kvm_apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
-
-		val &= apic_lvt_mask[(reg - APIC_LVTT) >> 4];
+		size = ARRAY_SIZE(apic_lvt_mask);
+		index = array_index_nospec(
+				(reg - APIC_LVTT) >> 4, size);
+		val &= apic_lvt_mask[index];
 		kvm_lapic_set_reg(apic, reg, val);
-
 		break;
+	}
 
 	case APIC_LVTT:
 		if (!kvm_apic_sw_enabled(apic))


