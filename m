Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A133CE42F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348202AbhGSPmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236201AbhGSPhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38B5D6120A;
        Mon, 19 Jul 2021 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711465;
        bh=uCErFtZRdNF5y07pqjRLmpl62TcxkfILFvZUtKYpVLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxtjBFBJDVwZIP8nM5heLY6ZFMh6wasWn8A9xDLBHS5G6W0vaTss/reTbWH8EKvwT
         BB5RPL0oPXIOUTT4a6iD6e4H+y+bZqSOUEAQiZOkKIjocc1kPSlEaRcrIpBx1Z6CYu
         PGk8CUcB12GXI5CPpDx1iP/P7tiZXFKGV3Da8HhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 005/292] KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled
Date:   Mon, 19 Jul 2021 16:51:07 +0200
Message-Id: <20210719144942.694837936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
@@ -844,8 +844,14 @@ static inline int __do_cpuid_func(struct
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
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);


