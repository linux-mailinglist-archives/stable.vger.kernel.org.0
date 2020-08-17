Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD3A246E0C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389394AbgHQRUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:20:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26077 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731457AbgHQRUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 13:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597684843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2KOxcTzA4HjXLrbc8Kis3OZr0Jk9r2f94fOWh6B2JtI=;
        b=Hyn7BbUdWGxMmgQu4fwtLiVcGQMdV3JBqVnqsKBI07Tzhb4XwJbv8ONQleyHOWuZfVFR0r
        CXJvxh9T3PPhmyQQRjJ2E3U4UedAMLE2DprfPLGTcYTveRGaOS2BCbMBxWqxUCObVLunCV
        w7cPdAQ0yhN/XsaPJsDmdWU8b+yheTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-VJjp-ljEPnex_p-WPMyJ0g-1; Mon, 17 Aug 2020 13:20:39 -0400
X-MC-Unique: VJjp-ljEPnex_p-WPMyJ0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 223CF81F001;
        Mon, 17 Aug 2020 17:20:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B33FD5D9D2;
        Mon, 17 Aug 2020 17:20:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Yang Weijiang <weijiang.yang@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] selftests: kvm: Use a shorter encoding to clear RAX
Date:   Mon, 17 Aug 2020 13:20:34 -0400
Message-Id: <20200817172034.26673-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Weijiang <weijiang.yang@intel.com>

If debug_regs.c is built with newer binutils, the resulting binary is "optimized"
by the assembler:

asm volatile("ss_start: "
             "xor %%rax,%%rax\n\t"
             "cpuid\n\t"
             "movl $0x1a0,%%ecx\n\t"
             "rdmsr\n\t"
             : : : "rax", "ecx");

is translated to :

  000000000040194e <ss_start>:
  40194e:       31 c0                   xor    %eax,%eax     <----- rax->eax?
  401950:       0f a2                   cpuid
  401952:       b9 a0 01 00 00          mov    $0x1a0,%ecx
  401957:       0f 32                   rdmsr

As you can see rax is replaced with eax in target binary code.
This causes a difference is the length of xor instruction (2 Byte vs 3 Byte),
and makes the hard-coded instruction length check fail:

        /* Instruction lengths starting at ss_start */
        int ss_size[4] = {
                3,              /* xor */   <-------- 2 or 3?
                2,              /* cpuid */
                5,              /* mov */
                2,              /* rdmsr */
        };

Encode the shorter version directly and, while at it, fix the "clobbers"
of the asm.

Reported-by: Yang Weijiang <weijiang.yang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/debug_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index 8162c58a1234..b8d14f9db5f9 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -40,11 +40,11 @@ static void guest_code(void)
 
 	/* Single step test, covers 2 basic instructions and 2 emulated */
 	asm volatile("ss_start: "
-		     "xor %%rax,%%rax\n\t"
+		     "xor %%eax,%%eax\n\t"
 		     "cpuid\n\t"
 		     "movl $0x1a0,%%ecx\n\t"
 		     "rdmsr\n\t"
-		     : : : "rax", "ecx");
+		     : : : "eax", "ebx", "ecx", "edx");
 
 	/* DR6.BD test */
 	asm volatile("bd_start: mov %%dr0, %%rax" : : : "rax");
-- 
2.26.2

