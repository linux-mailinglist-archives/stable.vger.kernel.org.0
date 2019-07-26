Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B59B7644C
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 13:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfGZL1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 07:27:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:47063 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfGZL1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 07:27:12 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so51240504ljg.13
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 04:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZeEPeRDOknxPoC0/mlXSl8BxnaCt+PLZvPwsv+/Wqg=;
        b=oFWvs4MvlL5GP1gOZX6EZCUM2DYpnzic9Y3aW+lbwp2ZlxCnqCK7T5Bah4HG/joNOs
         hV63e0w5+svVL8XhftgWoWP/xCsWoblTf6/31WWKzPb/CwML3ON89eWY42RteRNyjwNS
         I197pa9xb3Qz6rxDm9hDLNq5ZbkJvSiwlFXcR8fDGrI/kDNBHrhXDuf88fagsz5HwmT7
         MpJtdv/j3qYcrqljuvU0aunOcizbibYaxbPC/XFelw2VXEj2hKS0CyZoB45ls2x83PYh
         RbSW/E8DfU+T4TjCdPusX2d4I4gsNutKuwZXekucTrsBKtxPwVCvIaPHjB+M/RwiEKaA
         KCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZeEPeRDOknxPoC0/mlXSl8BxnaCt+PLZvPwsv+/Wqg=;
        b=pRm5P4+kNE8Yi7/kIJp7fzOgFwkFOyOzHKc4rVbFq+2PvoMf5VHXr6pMfRuPne2eTf
         wRTGejUbXWEy4r9Usqn6HEgTMUpOwGy2x/ZA14NmPfZ7xveNQR2/rwo4eB40OfGWG2l/
         fgDNFqpyr4U6fcmGbbHZpSXdSP4Caa/Mx/CUk2Kc5wq4H5cE0xDFWmhzV92zrllqNjGF
         fkIQME8fzyGC/iN2Lxq7nlf307RHjtVX4gURlkeCSzHzdGeguIM6n2a8O6rG73vB+3fF
         Bwbz+y9faH43h6wocsD8EeF0qj5evvWBEInyhWy3mTNeC8JyyRwKNohzHTmjpj0Bi6CP
         x/Ug==
X-Gm-Message-State: APjAAAWn9VnMqySxRrGDpDER6DP7YCPKRiE9ibpBHgWRfkpvVJkzsJy1
        NvIokkQlBaChcQlCzFPyYUHDNQ==
X-Google-Smtp-Source: APXvYqzBzw39/qTQ5qot67rMP7b47yVgMBStFTk75r4a7FEttMNWySTKLQVrAfua6AJQua/mT8NDOA==
X-Received: by 2002:a2e:9593:: with SMTP id w19mr1978301ljh.69.1564140430346;
        Fri, 26 Jul 2019 04:27:10 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id q2sm8196273lfj.25.2019.07.26.04.27.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 04:27:09 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     maz@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] arm64: KVM: regmap: Mark expected switch fall-through
Date:   Fri, 26 Jul 2019 13:27:05 +0200
Message-Id: <20190726112705.19000-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When fall-through warnings was enabled by default, commit d93512ef0f0e
("Makefile: Globally enable fall-through warning"), the following
warnings was starting to show up:

In file included from ../arch/arm64/include/asm/kvm_emulate.h:19,
                 from ../arch/arm64/kvm/regmap.c:13:
../arch/arm64/kvm/regmap.c: In function ‘vcpu_write_spsr32’:
../arch/arm64/include/asm/kvm_hyp.h:31:3: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
   asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"), \
   ^~~
../arch/arm64/include/asm/kvm_hyp.h:46:31: note: in expansion of macro ‘write_sysreg_elx’
 #define write_sysreg_el1(v,r) write_sysreg_elx(v, r, _EL1, _EL12)
                               ^~~~~~~~~~~~~~~~
../arch/arm64/kvm/regmap.c:180:3: note: in expansion of macro ‘write_sysreg_el1’
   write_sysreg_el1(v, SYS_SPSR);
   ^~~~~~~~~~~~~~~~
../arch/arm64/kvm/regmap.c:181:2: note: here
  case KVM_SPSR_ABT:
  ^~~~
In file included from ../arch/arm64/include/asm/cputype.h:132,
                 from ../arch/arm64/include/asm/cache.h:8,
                 from ../include/linux/cache.h:6,
                 from ../include/linux/printk.h:9,
                 from ../include/linux/kernel.h:15,
                 from ../include/asm-generic/bug.h:18,
                 from ../arch/arm64/include/asm/bug.h:26,
                 from ../include/linux/bug.h:5,
                 from ../include/linux/mmdebug.h:5,
                 from ../include/linux/mm.h:9,
                 from ../arch/arm64/kvm/regmap.c:11:
../arch/arm64/include/asm/sysreg.h:837:2: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
  asm volatile("msr " __stringify(r) ", %x0"  \
  ^~~
../arch/arm64/kvm/regmap.c:182:3: note: in expansion of macro ‘write_sysreg’
   write_sysreg(v, spsr_abt);
   ^~~~~~~~~~~~
../arch/arm64/kvm/regmap.c:183:2: note: here
  case KVM_SPSR_UND:
  ^~~~

Rework to add a 'break;' in the swich-case since it didn't have that.
That also made the compiler happy and didn't warn about fall-through.

Cc: stable@vger.kernel.org # v3.16+
Fixes: a892819560c4 ("KVM: arm64: Prepare to handle deferred save/restore of 32-bit registers")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/arm64/kvm/regmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index 0d60e4f0af66..a900181e3867 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -178,13 +178,18 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
 		write_sysreg_el1(v, SYS_SPSR);
+		break;
 	case KVM_SPSR_ABT:
 		write_sysreg(v, spsr_abt);
+		break;
 	case KVM_SPSR_UND:
 		write_sysreg(v, spsr_und);
+		break;
 	case KVM_SPSR_IRQ:
 		write_sysreg(v, spsr_irq);
+		break;
 	case KVM_SPSR_FIQ:
 		write_sysreg(v, spsr_fiq);
+		break;
 	}
 }
-- 
2.20.1

