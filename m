Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9663F45273
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFNDMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34384 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so384369plt.1
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7MRMdAKqkkU6zuM8WMZXIs4D8fug3sxafZUJy2Rr9SE=;
        b=zIBaeowzCoFmP6lTOOtVqg/coHbsWzGE6IBagj6ylKyIvZwnD6kH8rzh4+Rv3ir17v
         1Iv/Z0kG2fU8wIp8nOT0hJqzoN8Hkd4pviocn6TLwNgf4OfMlC16x+V8vN8XjM+4i2aU
         lDKKqPw1NWmXYS/R5KBvQ/FLkaSYfma/KfVvfIAd/ZUfK2O1lFmzB/hNohE6YPUSH5vJ
         fMSmeop/Yiwuzr680e0cWfbIKBAYuRran7/zaMqPOok2xS7XSbcibw6dL3UX0yaskt/q
         bkLWeBgRG96yH33aA4S6a33qUazKKP4YfaEZInOrc9MPcryBfcvP6y28zmRVLTTNNzJ2
         5KeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7MRMdAKqkkU6zuM8WMZXIs4D8fug3sxafZUJy2Rr9SE=;
        b=AspAuBnDRkv1REaAEfaAj4dRMriWglikDRiksAaco/Zbs6U5dNAO0aq+a5SdQDtgt5
         QTQ8HwM/lNnuzUt8G+WOOqN5HNApLHop/qeMUWcvzlPahrIfOAyh3iIzc/5Q0QkIcJE4
         Y77x3PPn0lw9vMcGs21vWQYVswhoNpv/apOcpVwX6rQgA3+SQjRJ4g40zkaZKvsLmPyv
         e9ozNwX3OIAxVm3HahFhP2mx53sHFxO8d8Nx71weNp1BFU80+yQHrkL6KpcTGEY+QU3P
         X4GHMqEQHFs+SKw7gUU1nrqJaw2QuuhU82j6l3CCcUosKYdkLRJ1m216Rfos+UzI8Mft
         RbOw==
X-Gm-Message-State: APjAAAUFtQgDJDguqFfbIw/MgFpGLYwOzNVHF4gwzmhIiTWwQ26Mg4fI
        zBMRRilCK/6gleoZuVgCWC4IqA==
X-Google-Smtp-Source: APXvYqz6RhgMc8g8mnKBOwmoxjNrQ1nJMlP61xQip6ol8kykbvXyf74BhFBqpojp8hF+tY1HAFnpPw==
X-Received: by 2002:a17:902:e582:: with SMTP id cl2mr76144694plb.60.1560481964343;
        Thu, 13 Jun 2019 20:12:44 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id k11sm1008499pfi.168.2019.06.13.20.12.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:43 -0700 (PDT)
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
Subject: [PATCH v4.4 19/45] arm64: Move BP hardening to check_and_switch_context
Date:   Fri, 14 Jun 2019 08:38:02 +0530
Message-Id: <c1008ca215c8ad08528e8de8f0634e2b8ea5a0ed.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit a8e4c0a919ae310944ed2c9ace11cf3ccd8a609b upstream.

We call arm64_apply_bp_hardening() from post_ttbr_update_workaround,
which has the unexpected consequence of being triggered on every
exception return to userspace when ARM64_SW_TTBR0_PAN is selected,
even if no context switch actually occured.

This is a bit suboptimal, and it would be more logical to only
invalidate the branch predictor when we actually switch to
a different mm.

In order to solve this, move the call to arm64_apply_bp_hardening()
into check_and_switch_context(), where we're guaranteed to pick
a different mm context.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/mm/context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index be42bd3dca5c..de5afc27b4e6 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -183,6 +183,8 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
 switch_mm_fastpath:
+	arm64_apply_bp_hardening();
+
 	cpu_switch_mm(mm->pgd, mm);
 }
 
@@ -193,8 +195,6 @@ asmlinkage void post_ttbr_update_workaround(void)
 			"ic iallu; dsb nsh; isb",
 			ARM64_WORKAROUND_CAVIUM_27456,
 			CONFIG_CAVIUM_ERRATUM_27456));
-
-	arm64_apply_bp_hardening();
 }
 
 static int asids_init(void)
-- 
2.21.0.rc0.269.g1a574e7a288b

