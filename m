Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4497D746
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfHAIU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:47092 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHAIU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id k189so14686584pgk.13
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+tEIHvT2/jri72b3g9sp066ia6oUWHcxPpBllqXMUPw=;
        b=zstarAAhY7wWmMaGY6D6L8D4JUjQWl1LpQDoGnw+W3hdCIJFeJzHRMBiPHafBsJN9l
         eZzvWMX/PZj6qV0aTkXMvuu43Wh3x673EnQCOEqPk197LcpNJFabikbGb65LoN4kOhsx
         WP8ba6yc2hAueRfZnHaWcCbYiVJiL13J4NUyBdoWUvmrtKDhtXrlXNWbiiOfVNIyZM1y
         /vNp/Yte3Jw4v6bpd1KDd53erL5yT9SmyfuxiqQAeLn/V5g/OTR1qSREfhWIZH/aBV/k
         qU8xqXAtcEchEEN/j5oB4C/dILnMiiNADOiXy9RhZkxWQGvOMs8ISwdONHMl0lypJqzS
         V+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+tEIHvT2/jri72b3g9sp066ia6oUWHcxPpBllqXMUPw=;
        b=Kg+6fUzXWWaJQeFkw784qkMpV/VM888NUOUa1zV8NPCa4lX4dHhVFUlp5gmomQIujN
         HtV31nXK7VpYnZcK0NqnFF8eyRPSR0RareCpKbgi29Siho+qoJCvVf7Lcpngyt4OK4YP
         FLymb0dyFXIvMtr4ypCQpyX/PLwGxv3Ongewx2nehkOjD3xTwMAxhIUB7Uq7aBFAVHLH
         OnMuZRz3hmgfiE+GPWNjUwzA7SxYZsCWamR0Savu2w7MuFU2N7SZhYBFv8M9VHpp87Aw
         cSNiI2q5jdtpFCjY5UkStowgqYecuLStbyBuVidRF54fAD6JPIi4i8ril8LQKS7SaOZX
         oGjQ==
X-Gm-Message-State: APjAAAXn1SSJs73vZFIsZRoqSNJBJEl6+88NUO8qWEqefit+W8Rc+SrX
        X55LozgjERCWRTVKfyZyyh8gI4Zvy5o=
X-Google-Smtp-Source: APXvYqxf8BTnCquHpLYCvNUaNkn8x4u4LXcuJcRGMZOEAmDPdYlWD3TQ4h+IWrvNS6AN8KeE4afqWw==
X-Received: by 2002:a17:90a:8c06:: with SMTP id a6mr7401352pjo.45.1564647655514;
        Thu, 01 Aug 2019 01:20:55 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 5sm2004064pgh.93.2019.08.01.01.20.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:55 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 31/47] ARM: 8793/1: signal: replace __put_user_error with __put_user
Date:   Thu,  1 Aug 2019 13:46:15 +0530
Message-Id: <8aaea1bd07c7c54db7efc732ac3a041c32d3bb4a.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 18ea66bd6e7a95bdc598223d72757190916af28b upstream.

With Spectre-v1.1 mitigations, __put_user_error is pointless. In an attempt
to remove it, replace its references in frame setups with __put_user.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/signal.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 6f0bd90f6d93..4a4ab72d27ba 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -301,7 +301,7 @@ setup_sigframe(struct sigframe __user *sf, struct pt_regs *regs, sigset_t *set)
 	if (err == 0)
 		err |= preserve_vfp_context(&aux->vfp);
 #endif
-	__put_user_error(0, &aux->end_magic, err);
+	err |= __put_user(0, &aux->end_magic);
 
 	return err;
 }
@@ -433,7 +433,7 @@ setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 	/*
 	 * Set uc.uc_flags to a value which sc.trap_no would never have.
 	 */
-	__put_user_error(0x5ac3c35a, &frame->uc.uc_flags, err);
+	err = __put_user(0x5ac3c35a, &frame->uc.uc_flags);
 
 	err |= setup_sigframe(frame, regs, set);
 	if (err == 0)
@@ -453,8 +453,8 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 
 	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
-	__put_user_error(0, &frame->sig.uc.uc_flags, err);
-	__put_user_error(NULL, &frame->sig.uc.uc_link, err);
+	err |= __put_user(0, &frame->sig.uc.uc_flags);
+	err |= __put_user(NULL, &frame->sig.uc.uc_link);
 
 	err |= __save_altstack(&frame->sig.uc.uc_stack, regs->ARM_sp);
 	err |= setup_sigframe(&frame->sig, regs, set);
-- 
2.21.0.rc0.269.g1a574e7a288b

