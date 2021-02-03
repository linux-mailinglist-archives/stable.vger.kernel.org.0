Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA2530DBAB
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhBCNr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbhBCNrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:47:21 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A47C061794
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:57 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d16so24322919wro.11
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Wjtls+pH/GZJVycHEPxwrPZB5Wdwg8gcit7enARmf4=;
        b=f47c4ugfyeITPfmr8BwY4/nuEC3Hx/6feP2Z0MwgBmo5U5B3pGdIFg41B5aR85snq2
         ocRFntQd53/bRbPfauI1keRtHKAgiYbyY5JEXuvxQ8ZlUKZMTMf2X4TW+kwAjizqQRCU
         DnyMk+xjCSyJwf58hiipHsQkzc0OtqRvD1Qo/3NyTtKFyvKijmhV+UDzKGe7cJZkJEpl
         LdwcpSCF0ui/Dqmuq9e1/ukfbH1zEErI4bSokDnS1WamBaUaqoWPKkFMTFXYdIzBaEvZ
         B7rBYFtWrbHqQ9s5ZleAcmBTfyGFZMpgWRXlwApV56RVS39Mjv+GwBBcBRroniRAgnrd
         0jzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Wjtls+pH/GZJVycHEPxwrPZB5Wdwg8gcit7enARmf4=;
        b=ldmlH2FiX6pjx+vX52jlpXEHzlLSF6Yr3Qt9qRl3cJrdpMuvZyaso4zvZ50dpqEtxq
         oloUqtZPaMFtKdSYrUI6o+LD6nKbbvUui4+nCRGAnrqKGTZsZxA+oxIIFcSUggum3EqQ
         O3yFRI3f2J6dKrQChVmF1MypfTu23V2F4t2qDE9RZHWW2/S4C83DcOuTem8FdlhmCZPV
         VKyI/rMQV099LBkmshMF4k4st3V3LWhMA7iQLwlHAXC/KUC/XEmmxreMeyDXeENgL7BZ
         ORn3gF0iyW8l8rqe65WD7oXMhQ5o/jen8sutOSwRgL+ei7Nqs60X0g8GIbqgfS8ZieEs
         oQAw==
X-Gm-Message-State: AOAM530whqWo/k+EF+RMPT5t79kMHv9rG9QBMUGsr8s84rTdx8P120iK
        7457slS8JgY11/qMvp+8BA5rG3i3RhwP2A==
X-Google-Smtp-Source: ABdhPJxZr3wdYaD1di3uYknX8qcbkhjQGI5govMajuNhrezkMhfjuvhr3MeTZSNqltRCMbLyWw3nQA==
X-Received: by 2002:a5d:6a01:: with SMTP id m1mr3544022wru.318.1612359956182;
        Wed, 03 Feb 2021 05:45:56 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:55 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/10] futex: Use pi_state_update_owner() in put_pi_state()
Date:   Wed,  3 Feb 2021 13:45:37 +0000
Message-Id: <20210203134539.2583943-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 6ccc84f917d33312eb2846bd7b567639f585ad6d ]

No point in open coding it. This way it gains the extra sanity checks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 40b9ba24bd9a0..be5e3e927bffa 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -879,10 +879,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
-		raw_spin_lock_irq(&pi_state->owner->pi_lock);
-		list_del_init(&pi_state->list);
-		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
-
+		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 	}
 
-- 
2.25.1

