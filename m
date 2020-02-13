Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A806D15C15C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgBMPWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgBMPWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:49 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE5D624693;
        Thu, 13 Feb 2020 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607368;
        bh=/yrbXLuKTNJ+NhfvCzfSoPXRN5DYKogpAK801Iam9+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fj2Fauz5Ueu7vkSyOIGdrlIyy8PrORKuJ7aDehSfFdUN5NNJ5twdml4NXfSPT4BSI
         BesKiWHAT9yNsQv2VMCS4auebUxUMyf48l8hWzANsAkMWy65Uxnpwxqg+5QobnTpoO
         xEpRObdK3KSM3FZUYvtW2U7QfkfVcuL8Cu4vMR7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 42/91] KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:19:59 -0800
Message-Id: <20200213151837.986856794@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 3c9053a2cae7ba2ba73766a34cea41baa70f57f7 upstream.

This fixes a Spectre-v1/L1TF vulnerability in x86_decode_insn().
kvm_emulate_instruction() (an ancestor of x86_decode_insn()) is an exported
symbol, so KVM should treat it conservatively from a security perspective.

Fixes: 045a282ca415 ("KVM: emulator: implement fninit, fnstsw, fnstcw")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -23,6 +23,7 @@
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
 #include <linux/module.h>
+#include <linux/nospec.h>
 #include <asm/kvm_emulate.h>
 #include <linux/stringify.h>
 #include <asm/debugreg.h>
@@ -5146,10 +5147,15 @@ done_prefixes:
 			}
 			break;
 		case Escape:
-			if (ctxt->modrm > 0xbf)
-				opcode = opcode.u.esc->high[ctxt->modrm - 0xc0];
-			else
+			if (ctxt->modrm > 0xbf) {
+				size_t size = ARRAY_SIZE(opcode.u.esc->high);
+				u32 index = array_index_nospec(
+					ctxt->modrm - 0xc0, size);
+
+				opcode = opcode.u.esc->high[index];
+			} else {
 				opcode = opcode.u.esc->op[(ctxt->modrm >> 3) & 7];
+			}
 			break;
 		case InstrDual:
 			if ((ctxt->modrm >> 6) == 3)


