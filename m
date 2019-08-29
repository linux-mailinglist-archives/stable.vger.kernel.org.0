Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1899A18D6
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfH2LgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33366 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfH2LgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so1887636pfq.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7MRMdAKqkkU6zuM8WMZXIs4D8fug3sxafZUJy2Rr9SE=;
        b=vVyItguL9T0AvEViFa6gaLhPAmahCHeVKFUQUra0d6N2G4hqPollf08VuWeFOE9cBh
         Lsiwu15etnFK2vSd1r9aUQUNXxmm0bhzIYLZwOJM7YJ4e4EvoyopMk/sgq61pF/ASV0K
         pk0M6I87Fr5urQifhikKA380i6Xgyuom8EGazvueaXiErtGr4mHYKTvQFTHaxX4sDDlW
         7uvild1QJG9MTTWygJwfV97GnKpUuSMtUFOWRAS4uNRqB1j1Fh9WCQt+4ROoHyM3Pmdt
         MVTvnqSQ/CVD5sBY6HXUP6/L2I2sVz9vd6NhfpQgBGFIL4nnAfEI6C00IosmJAddGp48
         Pw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7MRMdAKqkkU6zuM8WMZXIs4D8fug3sxafZUJy2Rr9SE=;
        b=dLjBX/wf59wN0swS/JDkW6G1uTr88sM1qFDF7IH0rhvyCoTq++XyWCOxza7d/CsqdE
         FPHyqi42jlNk9s7dmJdLQYUL8fbzsyjwtmCa8S72XnzaaZcxGKKFcdSbMlVXC+1JHJET
         J1g0Lcz3KkqPmIjLqeNuvXV2m/s7SLyH1u2JM0yABp5/lFQr48QmboO9js31TidEgbDp
         4YCOjVBGqZQdyq/qFzDQntIqUx/rautEurQuMfrRF7+87p+5MNT+XMS4bb3nTM7doGVG
         CSGoo2aeYs+VXwDDjoZbE8hPqzXVJcSm8yVfoqXoIDZWKAqnus+2p5QZYNwO/MpigPOU
         zJCA==
X-Gm-Message-State: APjAAAWt5ZeZGgwWxTi+nrM92KVyDfzpsSYk58ZznEC0u4fk+VazWHFn
        XEtargTwJfJmjl0DqySb3gwfX7mJqKg=
X-Google-Smtp-Source: APXvYqx09NvbWyJDyhBqvJWFlmQUkCvuPwXDQHyszuIuaqDXtBbe1WI75BVFuKEHVWUqerklEQkg8g==
X-Received: by 2002:a63:ff66:: with SMTP id s38mr8030413pgk.363.1567078561992;
        Thu, 29 Aug 2019 04:36:01 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id a5sm1939293pjs.31.2019.08.29.04.36.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:01 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 26/44] arm64: Move BP hardening to check_and_switch_context
Date:   Thu, 29 Aug 2019 17:04:11 +0530
Message-Id: <d2f9dccdd85950989be37aebdaece9aef0a6a9b5.1567077734.git.viresh.kumar@linaro.org>
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

