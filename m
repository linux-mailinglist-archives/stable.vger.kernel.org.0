Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EA54527B
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfFNDNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42219 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id go2so371380plb.9
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBbWRB3LgLlv2c3U4FxHDhn97v+yXFInuDLMYZ1aFeE=;
        b=yCjy6+SN414F35JKkNjFkyRAIf7YsFvNN+Kz/Mi8AgDN22LOTkEocDlKSGJU+7VWoT
         rd7H6Kwo6rDofcCHG0iiog2QNhUUG793KzKoX2APLWphCziQ9Z0/xaLtnBnUYuMK7Z3A
         YetcuPTD3IMuzeKAl2gn5/DadaRWJl5utXEgxSmdTugAcYNH3N9NfiJ/JOqN1fumuopz
         cSs5wtE9I3gwI3CwTLfm8welw4DW0VNoCNIc3JfQ6880amhcfnmyEuyQYBPf651aQbcO
         554KdaFth8cW5dCOUl05t7MeAl6hsjFFLJvqfZsKX4U3BqTDiEFM/mrfOuo9c+OoANQn
         NYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBbWRB3LgLlv2c3U4FxHDhn97v+yXFInuDLMYZ1aFeE=;
        b=VyjW9p8s7E0y7IB2b2bawUSJu3tGIGA23PrnL1p2xVejU6B3xyrCGZghZngx3/vRZI
         Y6B7RoEvKAIBYbrEJND27KyvTrMa5VwSIha4ewhFRG9dAbbKGTaheAQL9iyvp+XhTbqa
         h8Z1C3HIMvxBIY4Q2me1zS9tB0hjQIJxWqlhutjNMmh8C3vZ2ehlUs2njvbW6iMW9cGT
         p6YjYwePxE6t2EL3My+4gXPUVxEFno1qpzPYl/gv/2MTj1aT2lbt6mXmFnWQh+Tk1YLD
         6+xNMLLrNcViwvQcWLfvO7utLr54zy6n2XvZo1REpL+sEBHgTOh6Q++7z5rD3KvJyFjP
         yjUw==
X-Gm-Message-State: APjAAAUYSxTqw2OPkBJkhyDUpC44wxKhwEqa5X4unXDqikPWCqH4o0wD
        Nc7l7qeMPjKjRZf2JhAhHbtOZQ==
X-Google-Smtp-Source: APXvYqz8IKb1jUFIGu4BsXINQ7hYd13qL7tcvHzLmwIW0Blq8lVI06hDyZgfCOfPA73tJ87WnHnC8A==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr87000779plb.314.1560481985859;
        Thu, 13 Jun 2019 20:13:05 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id o26sm1106132pgv.47.2019.06.13.20.13.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:05 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 27/45] arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
Date:   Fri, 14 Jun 2019 08:38:10 +0530
Message-Id: <92556442f96e9f150663637c363eb892731327b1.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jayachandran C <jnair@caviumnetworks.com>

commit 0d90718871fe80f019b7295ec9d2b23121e396fb upstream.

Add the older Broadcom ID as well as the new Cavium ID for ThunderX2
CPUs.

Signed-off-by: Jayachandran C <jnair@caviumnetworks.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cputype.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index c6976dd6c32a..9cc7d485c812 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -87,6 +87,7 @@
 #define APM_CPU_PART_POTENZA		0x000
 
 #define CAVIUM_CPU_PART_THUNDERX	0x0A1
+#define CAVIUM_CPU_PART_THUNDERX2	0x0AF
 
 #define BRCM_CPU_PART_VULCAN		0x516
 
@@ -94,6 +95,8 @@
 #define MIDR_CORTEX_A72 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
 #define MIDR_CORTEX_A73 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
 #define MIDR_CORTEX_A75 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
+#define MIDR_CAVIUM_THUNDERX2 MIDR_CPU_PART(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX2)
+#define MIDR_BRCM_VULCAN MIDR_CPU_PART(ARM_CPU_IMP_BRCM, BRCM_CPU_PART_VULCAN)
 
 #ifndef __ASSEMBLY__
 
-- 
2.21.0.rc0.269.g1a574e7a288b

