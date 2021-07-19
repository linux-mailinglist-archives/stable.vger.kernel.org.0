Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD18D3CDA51
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242688AbhGSOfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244172AbhGSOcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF69A60FE4;
        Mon, 19 Jul 2021 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707563;
        bh=R1Xihc1NNDZ0fneJ85QhbquZvOMvD+zfFNAFUL88etY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzEPtGwBpX+ONO7L63bpnyrVAXNXfzOUt206ldtkj8kGVTbZBqT43Ks4bcO5D3HJF
         vzZaaA1H41/LiLzx+ecZB9wEbTIq7lcJPlf4awgdtQv6lNPO3wSoRDLJBUWrmNW56V
         GIq2y6cY/9yB2slRsFmmGVrPRkXy8l23IBPIpACE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 180/245] KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled
Date:   Mon, 19 Jul 2021 16:52:02 +0200
Message-Id: <20210719144946.221453777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 4bf48e3c0aafd32b960d341c4925b48f416f14a5 upstream.

Ignore the guest MAXPHYADDR reported by CPUID.0x8000_0008 if TDP, i.e.
NPT, is disabled, and instead use the host's MAXPHYADDR.  Per AMD'S APM:

  Maximum guest physical address size in bits. This number applies only
  to guests using nested paging. When this field is zero, refer to the
  PhysAddrSize field for the maximum guest physical address size.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210623230552.4027702-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -633,8 +633,14 @@ static inline int __do_cpuid_ent(struct
 		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
 		unsigned phys_as = entry->eax & 0xff;
 
-		if (!g_phys_as)
+		/*
+		 * Use bare metal's MAXPHADDR if the CPU doesn't report guest
+		 * MAXPHYADDR separately, or if TDP (NPT) is disabled, as the
+		 * guest version "applies only to guests using nested paging".
+		 */
+		if (!g_phys_as || !tdp_enabled)
 			g_phys_as = phys_as;
+
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		/*


