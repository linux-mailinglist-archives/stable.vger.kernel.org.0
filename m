Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78046664D
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfGLFag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39495 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFag (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so4003697pgi.6
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDb8snX7fHtHRXPBtLwcic7/q7BlhqslXapsBvvT9m4=;
        b=eiibal9GFko1a+tgQN3krnXtrWdBZuqF3op4VIu+Wf3BT3yWBoqbTx9WQb/SIzb2Pv
         nU+5d2riU9FFB7ZObi6T0/FmOiVAW5aGYEmZjvrkkPJ2g6yeqttaBIBexfwHx+XltErC
         Y3DQoi4yokam/JVK9tv8g0c/tsQBw2y1zMoB/JHCIAUoY1gZtZBgHuw03VTQnbdwe9kP
         Pt6+p3ZXg8pzKllRVC4QKdzpBSOhLptnFhC4kPw4VLGxf9zD3HLpNXMD2tlXjktOiBhV
         WavqlMtulcslGCSBKhXOA08M969cG9OWXlkrqjc6vZeeITO1cX9t1Zu5KT2rCDtkxCAx
         U0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDb8snX7fHtHRXPBtLwcic7/q7BlhqslXapsBvvT9m4=;
        b=RcMLI8Mgk6ZJwQwceFaBbx0YaqypKGclDONy8pwb9N6uQNW1Cz3C7zaMOL1mbT75P8
         Ht1yCTV6hmgMPEHC2VZEMvO+pl0C3IF4lppFkmf2qdpaiS3nuTmH0DNTcCJswAEWlOnO
         JdhbtwhWvxpOhhy5sLJpeslvJVyKXQw/dC6+VwJxGxxJlXTkri2uYGTddA48q/UpBonF
         bvpQKNEKY9RF5BKU+5RlkvGq5IVj+KIh/rJsnkoVHq/S616U22+PvfHjsLOcvnCzL3sH
         IJOjqhC9f1qP0hyuXThlIzxHumgCfTVHxbkYLCzwpOkQTFYSSg7pPHaGs5arrK2XyftR
         KPyw==
X-Gm-Message-State: APjAAAUnpHuuNMD0mhzCaS5709RZldKU+bVbRBsaHLM9deZZ0JQZZQFz
        0itpCkyJKzZq9sdfZvSUbFgfMQcubp8=
X-Google-Smtp-Source: APXvYqyVf+gr+WKeb4pE+MswfAdJZHG+738tsKvri0lovTW3p6PsP27qAGYoMO8DaGXARfDH0ncu6A==
X-Received: by 2002:a63:d04e:: with SMTP id s14mr8225037pgi.189.1562909435104;
        Thu, 11 Jul 2019 22:30:35 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 143sm12297066pgc.6.2019.07.11.22.30.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:34 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 35/43] arm/arm64: KVM: Advertise SMCCC v1.1
Date:   Fri, 12 Jul 2019 10:58:23 +0530
Message-Id: <7c5975b0d2850d2b728f4688a3fedfed6bcbe75c.1562908075.git.viresh.kumar@linaro.org>
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

commit 09e6be12effdb33bf7210c8867bbd213b66a499e upstream.

The new SMC Calling Convention (v1.1) allows for a reduced overhead
when calling into the firmware, and provides a new feature discovery
mechanism.

Make it visible to KVM guests.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Viresh: Picked only arm-smccc.h changes ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/arm-smccc.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 611d10580340..da9f3916f9a9 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -60,6 +60,19 @@
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
 #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
 
+#define ARM_SMCCC_VERSION_1_0		0x10000
+#define ARM_SMCCC_VERSION_1_1		0x10001
+
+#define ARM_SMCCC_VERSION_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0)
+
+#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 1)
+
 #ifndef __ASSEMBLY__
 
 /**
-- 
2.21.0.rc0.269.g1a574e7a288b

