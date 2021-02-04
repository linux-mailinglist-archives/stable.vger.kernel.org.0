Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50C30FA0C
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbhBDRpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238505AbhBDRbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:31:04 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4181C0617A9
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o10so6360631wmc.1
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jt6ppsBFHDM6FBIc6eMl8p62XKsDCQzpsx3kuToeRvA=;
        b=C8kl80gOrI7VtnIXjE6O1j2+YqM/p5AY+wSB0/y2Zm6L4PXwqtc5uCcba4NzXR6ewy
         y7yebs2smS8wL+54kG0bwlRcSwajvoL/9yhlDgSxGvKrXBtCca+L501bYVVqROJoey1d
         WaMqLVZhDs67W5/ZFl7kB3Z7QnUQ31PMn2VTN1tbJYMElXQp/vciUUAkuWtdn8+KAW0t
         KR5Xg2cVQUfqs0Cdz+H3t9MxHzW48bSC9Dmz78sybyfCaEwDdrE5Mdu7mOY6lod2OGy3
         ZDdSrlu0hD6Dga7i0f4iNfV2wMxnZ+84xJilL111lNp6BR7TkseZ4Olfb9HTSUbLvaBE
         m5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jt6ppsBFHDM6FBIc6eMl8p62XKsDCQzpsx3kuToeRvA=;
        b=mNkNEFNeaPgYyauTPPKiRrHltklxVAW5nBi8aMgSZQxrQVUnCLkPQlrGMGEJFeolb5
         oL/lxfRlpa/Yi8Wm2uOaGxx8l+HqTtag4X5U2brzM2+RHD9sqiJcEXK3feJs5YLSK8FW
         O6xb3ybaG51JUlmyrfsUa26EcEZyGiTof7edAr7juBNu2eterKjZGJ4pAHIOmIr4X1qi
         WWCNIKvnKwgZHC37Qnm1jvohvD4UIV6/b6E/fKShVuSW+XA2dD8JhaHMdLA5B0kw74Fp
         y2sKhHcckkk5n4g6WN3bRkqI34Q26XK4qHDn0x/d092wssXAueKMx+jOJ87yim/RWpad
         Rkww==
X-Gm-Message-State: AOAM532yoKWdL5PrP8Rq8wpbcD05uwizhjZFZHwZtqGbcAiGA6w7iTXV
        lzKqYiYwMqJhHnd3VocFPBdojjXr9A5i2A==
X-Google-Smtp-Source: ABdhPJxZ48nxPCFgg32fR4z8Z5c+fm1JwT3RxePguoyECKODPqIyPD7Pef4eIZdPtdDvKctXsLb2YA==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr238175wmc.136.1612459757185;
        Thu, 04 Feb 2021 09:29:17 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:16 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/10] futex: Use pi_state_update_owner() in put_pi_state()
Date:   Thu,  4 Feb 2021 17:29:01 +0000
Message-Id: <20210204172903.2860981-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
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
index bf40921ef1200..d9bec8eb60969 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -874,10 +874,7 @@ static void free_pi_state(struct futex_pi_state *pi_state)
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

