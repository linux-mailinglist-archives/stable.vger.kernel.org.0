Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D625F7D716
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbfHAITm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42755 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730392AbfHAITl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so33724193pgb.9
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDb8snX7fHtHRXPBtLwcic7/q7BlhqslXapsBvvT9m4=;
        b=lj9Gf1glakTXRPzaABcp+dSTirE8tmaZ6Td74cA3BogQQOFnDfrZx9oEj0Hnu8zmf7
         I54TfGtBNyKO+fzt/7SB7xyYp1p4K8QLFUWbHq2Go+7iSwTcEIBwjplWtA/b6ot5RZGD
         7Ejsf7yCr1FZcsZOTEXCXfaLdFA2Ee/138F9K3VmN6GopU0+0ZREjPK+4GNwcUa4QIpo
         n0qcmsR2ExwcIsWajm8cidxMF4XetBAN/apkVA+G1DBoLILahesp6c9blZQkIM3Azh4S
         2LRU0HSJJAZfiApfsG1OijZOdJzf2a4NKzlEumfazVW8XkjdyZFVaHxoXrZvSRpZ3mvp
         eSlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDb8snX7fHtHRXPBtLwcic7/q7BlhqslXapsBvvT9m4=;
        b=AQ47EL84f77wToo4JY5p+cOp5NaGWrNO9dwKecIS4k0aHeznnet50RHJwKH6CqSFNL
         0+rwG/Q+/qpkFeM2YWdhnF+fNRuRLrEFBmj8nJZtuva8xjF7wswyB2qkavQLle6PrpIc
         Hkmfsa6QgkUCIgxZrAukg4vJi8m6LcSUd+8D6hNyc0FCb/EPKP5nxeHX2dzz2RBe5+wX
         tEkZLkXZWlW22+0RNio32mVi7f3qjIQ0dh307Y6JCDFftQGVj3VtLHEwAVSzy2zbHv3i
         ljkqpO+8nZipaTYniRgoNV9zilAuG4TBiV45fAt5xGFktQ0XwTX1trsfjRssL9j6CxWQ
         T4yw==
X-Gm-Message-State: APjAAAXCFnVHgQqwdXPSrIdEsbw5IIeq0kHf+mmH0z2APINcZERyJQ5F
        PtdzKnoV/PPsFBDRUAiLgowtA88ngCo=
X-Google-Smtp-Source: APXvYqz75WheTZoQVD/460prqttSQRePB4YDUm2PEp53etTwQK58Z/AF5zDWQURXBRL/9/WSyqVsVg==
X-Received: by 2002:a62:750c:: with SMTP id q12mr53419702pfc.59.1564647581009;
        Thu, 01 Aug 2019 01:19:41 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id u1sm67243723pgi.28.2019.08.01.01.19.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:40 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 02/47] arm/arm64: KVM: Advertise SMCCC v1.1
Date:   Thu,  1 Aug 2019 13:45:46 +0530
Message-Id: <9f53c355f58717a810f74b72ab6982d723fb621c.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
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

