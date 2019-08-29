Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AA2A18E4
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfH2Lgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38962 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfH2Lgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:32 -0400
Received: by mail-pf1-f195.google.com with SMTP id y200so1866593pfb.6
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7GSqiJ6aBNFVvBBcZiH2v3S1Pbs9vo106t8SFNGIe4=;
        b=HgYnyGY4Rvd7slKtSgD2nVDXkz275HIQ36S3JKlkT4lokdLsPwPgvEl64gMOtQhwoR
         BCCxQ+H8X4Q+NI9D0eL8DYKBL/D6asVeu/EasBxUJowSJkoZH1OWjViiWuabjArYWvxb
         JyBBiReJRZcnDI2MUi4QOmTpU7cwrvuG+CKHjEZt4AwbbvERYwCk+KslDSJq+IZ5qrDo
         Lhs2nja4pa1NBi/PzS5RBmkR4KhGIicqAWPrDVId+QPTpBD48VQ2aU3ImZ+honyRF5lK
         Mufu0YHo7Tumu/1P9ZdZS6SiFlTgbuXwyrghtoZuVcxDypApPLumFMO6kc7c9ez0a6WL
         9GAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7GSqiJ6aBNFVvBBcZiH2v3S1Pbs9vo106t8SFNGIe4=;
        b=nnrva1os1hCDdAv3IUe9odhpBUMMudY6lLRxVyfqzifeCioYoGqH4EoYn7gXS5NIaf
         1/Pui2+hAV6vLqutc2YPR1NBahwI4Kn69kxrCBbv9S69+EyZYHXNipO3MfMNI58d0sm7
         vJXMF3UUelLE5K1+h+YSRJaVcOsdr4/to+DzqjtRqcfHIkHypqOKf3D9LPups7Kxtlom
         Xsc8gVWRzOHT7anJZ3Z5hTpmyLJckfaSIlLY3kENqn1sgc5VsdRv9OSBQOG6q0cj08r4
         zxzgEnKJ+yi1QIG+QgrFlC+RHl9jWXbStbNCWaW5iAYqiVmT4WsI7NNgBh8fnLCzvmhm
         phTA==
X-Gm-Message-State: APjAAAWYhEx6gKZoFCkYjfN0R6KAMhyK6HN2jmXXwv9pm6WHDexnjMCk
        J0gZWys2ATtSAqJ6ubIgMj6w15XD5V8=
X-Google-Smtp-Source: APXvYqzmk7md9jQJV+ApWtMrsLlocKHDNdnxUDcrnOu1rs1/rBoLz9mL+zo3xlPKf8O+tfPSI4BZ/Q==
X-Received: by 2002:a65:68c8:: with SMTP id k8mr7774608pgt.192.1567078591024;
        Thu, 29 Aug 2019 04:36:31 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id t4sm3412949pfd.109.2019.08.29.04.36.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:30 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 37/44] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date:   Thu, 29 Aug 2019 17:04:22 +0530
Message-Id: <d41b4ecd51a3337b41c41b67c4adc704f7a766ed.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 6167ec5c9145cdf493722dfd80a5d48bafc4a18a upstream.

A new feature of SMCCC 1.1 is that it offers firmware-based CPU
workarounds. In particular, SMCCC_ARCH_WORKAROUND_1 provides
BP hardening for CVE-2017-5715.

If the host has some mitigation for this issue, report that
we deal with it using SMCCC_ARCH_WORKAROUND_1, as we apply the
host workaround on every guest exit.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Viresh: Picked on only arm-smccc.h changes ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/arm-smccc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index da9f3916f9a9..1f02e4045a9e 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -73,6 +73,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 1)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
 #ifndef __ASSEMBLY__
 
 /**
-- 
2.21.0.rc0.269.g1a574e7a288b

