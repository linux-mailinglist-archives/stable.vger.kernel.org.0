Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9583F30DBB4
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhBCNrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbhBCNqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:46:43 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE95C06178B
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:54 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id o10so3996600wmc.1
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=shpeaE1Az2Txha1mF0lLFgmVrxxkpcKGoNrqgxMpIXg=;
        b=Qa3hzvqV8OBIHpAT4INGETBQtIOw7lrqD8+uUkzmqDN9yuM1J6fdHHbL+lGLyTNEKb
         MEd/TUFRyRhoPvolmxnAHLgR5cRZTRgIp8DXVhnLdbrd9P+Zue2cu+qcYW6LJsQlHHSn
         b5ceLNWqOQIay0GXUVSHBCPJSBUak4uH3dLaW1xnzgszVICQ73F2jzPBopB88Ir4pnIE
         DAD2m6V+2sBxnVs5M43Mh6URUsJTvhtK57w2XrcN7w4/4FVuV5MaXfPDMjGcKchjIjoZ
         Xntw4c0j4zNTNfzHM4di1q09hD+caDnaLDkCMO0KLeC518svncoadT3VKEi3HzIcoq7F
         SCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=shpeaE1Az2Txha1mF0lLFgmVrxxkpcKGoNrqgxMpIXg=;
        b=NXkh8crWVCeosaqUsfEREltd2S0TxC5TIRkWtgcKCBe+nyWAI473A+cq9suVrdEtwS
         Hqk0DS1buJpGv7rotw8Vpsszgrzde5L2XgcFJ7wpTgPwsGW7ZZZG8tTBjSOeMHiQzhZJ
         Zxwd/a4cl1VChu4zzM7SuELXPf8fTFhc0oAenLB+rtdwTdhxjRkG2Y2RA2Rdgoykg/dE
         dYaL+EByXMQd1/NQ823nl+Q8kSeXWXw58nBTHD4SD2uaKkgm2LxDZvR8X4TUTLY4xhCP
         skAc65LCR/QoHNhAeC2q7QFw7A2Vs7jbXES/+av3sGLsJQ0H7pHfkK0Te+2NJcy+oHEM
         a/Wg==
X-Gm-Message-State: AOAM530z1loKexfl+5iTapIBj2vI+Tus9CDlZHN+qtPFzORqwAxgpYFP
        Huz49K0SExGB1J7jedVypX5A6MIGdQvBfA==
X-Google-Smtp-Source: ABdhPJzG4cRSduQyNzF+d539IO2tXgf6BGUGAnFG37XeTlHAewEemsTcN8uGlsnSpjWqSMSRY/+J2w==
X-Received: by 2002:a1c:25c2:: with SMTP id l185mr2905518wml.62.1612359952877;
        Wed, 03 Feb 2021 05:45:52 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:52 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/10] futex: Replace pointless printk in fixup_owner()
Date:   Wed,  3 Feb 2021 13:45:34 +0000
Message-Id: <20210203134539.2583943-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 04b79c55201f02ffd675e1231d731365e335c307 ]

If that unexpected case of inconsistent arguments ever happens then the
futex state is left completely inconsistent and the printk is not really
helpful. Replace it with a warning and make the state consistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 8b137505fb502..e44203956d54c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2447,14 +2447,10 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
-	 * the owner of the rt_mutex.
+	 * the owner of the rt_mutex. Warn and establish consistent state.
 	 */
-	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current) {
-		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
-				"pi-state %p\n", ret,
-				q->pi_state->pi_mutex.owner,
-				q->pi_state->owner);
-	}
+	if (WARN_ON_ONCE(rt_mutex_owner(&q->pi_state->pi_mutex) == current))
+		return fixup_pi_state_owner(uaddr, q, current);
 
 out:
 	return ret ? ret : locked;
-- 
2.25.1

