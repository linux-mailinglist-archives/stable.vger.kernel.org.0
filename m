Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6F311BE58
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfLKUsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:48:24 -0500
Received: from mail-qv1-f74.google.com ([209.85.219.74]:56526 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfLKUsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:48:23 -0500
Received: by mail-qv1-f74.google.com with SMTP id q17so9903758qvo.23
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U1oRaOu4UKf7viNh4ANM8AYZUjuVHiI8DgaphOB3TV4=;
        b=ICYTPZ7c3Ur5ji8A/GJ8r6Yn1LPj2qOZ9iFVliX5y5EvvrQPEtD5bKeM/hIMzjzCdK
         9C7fqVZq5Dodo44qG4g3RI5a3sa9BWGW4OF6fXSYHtZClT+iMYX/X7zQKDgdGl5FTZkD
         VuZu07R6o/rPbJPedX7bDEBazLxwFoDm24MpXgvIBQCPXX+zjyDwOiwiKP7NdG7Y8ssE
         iFJNFPbtO5ZxdEojvVvyHPe94c+j7EC7ZLrgvsLPknHsYHF2CixJ3hzKeK60f4Z4F/aZ
         BGyVsAd4TsviSx5CLpkcieupXvevViyqB0BurofDUPCmizeEZDllBrv/MNt6YYaQr4Hx
         bbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U1oRaOu4UKf7viNh4ANM8AYZUjuVHiI8DgaphOB3TV4=;
        b=IE2VpaMeCOzh0qdC4PUH66lgOzD6xvJmn1YGFNqEk9ZJqp08pqLh2yoExcvgpXFdtH
         KaN0LY+tpBTgCOw75njueFz0jP9HTjO6vKHULc7RLiTbJ0vcltQo/KFRA+YZVmayaDGr
         O9YFTi0XWym9JDLAAMMFXeLgeBeVuY6cIL+Zl4lXub2h12TP+Dh7CaaRplA6ijBdH+Zb
         8u/pwLk2DgSKGLRgxvxNIWosRdt4+YMlqonNVKvFguCGvZ9hpBWgRgxtIKnTBEkvlxhZ
         zAKzeiHxD7SKfg7cQINE4F0bu5YnTn0i5cwV4likG/1Q/Q6VafAEQzz6AcwXmVPDtyG4
         7szA==
X-Gm-Message-State: APjAAAWNtJHX6wi3X2a4yqAqmgwxQ7Jj7x2/8dExfFwYC32YRafYA/gO
        HzvPk+hhhAxnZE3C8Aq4yQTv4BzqzlrQ
X-Google-Smtp-Source: APXvYqwORnaDd0KerPCPPUjx9L0EkYqP+ngKokQFztfluoaxHnjP5honJKrXV1BllWzCwrUlPRfMnV7hPMj/
X-Received: by 2002:a37:9ace:: with SMTP id c197mr4955885qke.482.1576097302014;
 Wed, 11 Dec 2019 12:48:22 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:41 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-2-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 01/13] KVM: x86: Protect x86_decode_insn from
 Spectre-v1/L1TF attacks
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a Spectre-v1/L1TF vulnerability in x86_decode_insn().
kvm_emulate_instruction() (an ancestor of x86_decode_insn()) is an exported
symbol, so KVM should treat it conservatively from a security perspective.

Fixes: commit 045a282ca415 ("KVM: emulator: implement fninit, fnstsw, fnstcw")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/emulate.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 952d1a4f4d7e..fcf7cdb21d60 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5303,10 +5303,15 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
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
-- 
2.24.0.525.g8f36a354ae-goog

