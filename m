Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624AE6664E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfGLFaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34705 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfGLFai (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so3801093pfo.1
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7GSqiJ6aBNFVvBBcZiH2v3S1Pbs9vo106t8SFNGIe4=;
        b=tcAbB1XCe4vsg0irqnOIM6f7OdPoVlA+nE9DQ3iCELNXazxdKNTX7JqL6YIuNOyzqp
         1gZ0aRWd5itgdDqxNwelzN/3pYqDQ3wm++Lq+c/1GsBgxY+xL97+7R3Dv60KKat1CnmZ
         w+TDTAUdJrCwdEvHHImQh8zsvtQKROHmkviw4P8RSxG8EEK/gtU6buhHkmAvFpf0feFs
         tYltMKt7PUWT3FXC4X0+Ax7SMaZeuaVfPBXvw3yaXl4A/t6jzB/68xxT9lBHbRBWPKWS
         wqnaBGkmWANvWl1F2Jrd5SBRnzP5sywS35J9ObCnqvFWnZDPNVVbvFUyUdKONubvfb8s
         HPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7GSqiJ6aBNFVvBBcZiH2v3S1Pbs9vo106t8SFNGIe4=;
        b=SQLukJosbBW8+sUlhaSL1ZfgmADomhD7TjeK3gi5Ruj2qq9HdILaDUQbrTQ+3oujip
         8FN2FnWfDLXWlSPO/QxccbUrMP4CEgAw3SPWmdKVyFlYustpYzwAYEhy7sDz54IOTaMZ
         Rao0MFqYz/6fe1zwmTqdgbAoH+/uu4XzZZeWFxd7vEW9LEHq7Oab2+9p4nzNbkXeZ/KX
         zy6EhJmkRHoxlWqaDmH2v0xIgDzZVsjgrqe7/s2THJI+DZMVw/Gfd6KibWNoXoj9LIV3
         4dW4N+mRnp+v37Bao6aPcxEgMZ9W+CtNkRzXfoovXd3IzVYIyZS79XOumC04vbr+fwpP
         Z1+g==
X-Gm-Message-State: APjAAAWJveUUaUU6QGmxGe1Jl/2KAC1LAK17nu7L0Q6DO6RBlPrs2WQq
        eFOn0dkqAsdmxhuO8rxmi7dYK6PiqJc=
X-Google-Smtp-Source: APXvYqzfua/WaSi2v/9NaYC4vsYdyiPDgu+cEIj0uEmriPTMu+vUpayzFNtV/AvRJG2dFnn9SZy1yA==
X-Received: by 2002:a65:55c9:: with SMTP id k9mr8788259pgs.142.1562909437702;
        Thu, 11 Jul 2019 22:30:37 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id m4sm9840773pgs.71.2019.07.11.22.30.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:37 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 36/43] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date:   Fri, 12 Jul 2019 10:58:24 +0530
Message-Id: <7dd90325604da1ca7d424aeff0cd86ee3c18fdff.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

