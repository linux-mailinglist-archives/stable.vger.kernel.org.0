Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE691A18E3
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfH2Lg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46876 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbfH2Lg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id m3so1427671pgv.13
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDb8snX7fHtHRXPBtLwcic7/q7BlhqslXapsBvvT9m4=;
        b=MxVDtRC9Y4lv4jG9hpAos0s+xIe/ARHMDGnoPf/99+Afqj27WqVXGxDp3whA9QF9rj
         zy6wvMMqo4wV7qE94YEu6uNAYmR1PdZl7H1LI3+jvKB3HAGDQVz2VXLAu5QxQQce/tBe
         tijrc9X0p0SFXFGpn7D1/0Vt2zlF/lfu/jfnPZBOego/s4nfxvYu+221uEN/M+F0kZIQ
         i62nKBUOyZX4z8HEn4x2m79tYCUbVRXtoorbzSgzRr+smMy30rrjJW+3cMfV3nV4jg9R
         RxjZkvAcYmnbOSd/PLmZv80PXkXR0tDFpIGhFn5lfhXWdkjuEyokQp/zUJDuKEjCWkcj
         mPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDb8snX7fHtHRXPBtLwcic7/q7BlhqslXapsBvvT9m4=;
        b=AyVyJHjRgD/VujCzuvgbtOjyeaumZrnhb5kd2LCZlmSqOKjKu1gDJtpfXQ/8x2iZfG
         zjx4hRX+WRMbBd8Cot4ztgYFAu6LDUCMjN3rHst920gVuy12ClpAQS7PLxCqApehCSqg
         SbQJn0GHlRyoX9XW7anusCxkUpczeMHSTpcTNzcU2g5McKejaEdnz4SalFkw2yGJFYlY
         D+FxL/Xsuq+SmHSbHEvz5W2yDfP221YHwXMoRsVrEzveDba6FLtdXqZW1hwv2M/WmM4x
         /M1AUbdkJU6vT/GYCgPOufFJK1r2PgOHLZnidXEsiLbYgkUOvLHEWkoHSCmHzNFa6XVN
         /XiQ==
X-Gm-Message-State: APjAAAVdoO+pqQtl0FFxWsDaDl2BejCt/74p5Lr9fEHyevWWvKhMgokl
        hI+78eU0lkpgxbnasXfo+Xny+oECfo4=
X-Google-Smtp-Source: APXvYqyH8cMp3WI3VBt9ncmvLARVo/vLVagqPQxUJLvSZXGXVCuTfpF8P7BWJIc9lHP6S0Bj2H1TKA==
X-Received: by 2002:a65:6850:: with SMTP id q16mr6555728pgt.423.1567078588390;
        Thu, 29 Aug 2019 04:36:28 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e9sm3945514pfh.155.2019.08.29.04.36.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:27 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 36/44] arm/arm64: KVM: Advertise SMCCC v1.1
Date:   Thu, 29 Aug 2019 17:04:21 +0530
Message-Id: <b3927577b8837116f55cc21a028377d97f79cf30.1567077734.git.viresh.kumar@linaro.org>
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

