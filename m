Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A286CA6A5
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 15:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjC0N6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 09:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjC0N62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 09:58:28 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825BE40C6;
        Mon, 27 Mar 2023 06:58:27 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id ay14so6371275uab.13;
        Mon, 27 Mar 2023 06:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679925506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j6S8aoTE4XnnRICI4Cgexe87+BA2EHTmrbOrkOlGf2A=;
        b=MeGA2aX8swVDI8IPhdkrhlR6D4VrY8TSanhpNBzqCzAluqH7Vjsf475BEzj4Y68VU2
         IK4fySExIoLx9D+GhhKkaXQ6N1/WHi8ztzvXxA/VQq3xxWmwQb9xoIS8sOqleTv2kqPa
         DoNVh+eFi0eEuToRiGZd62Mz3IuLc8s6GkCUppnLsptvxdoHaCv8+y6ClhW3ukmW3hqY
         nykWW6FKmy+nPRkRCQnwlIunRNqoxXR4lQLIed2JodP495nRWmn+6yq1H1PlBZqFhGL3
         P/qB/deBFt3fGujcdWC6GWQDjwdDjr3n6iSybxJTnOB/051TO7XlTBwKZ5n6jHRPR8Gh
         dIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679925506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j6S8aoTE4XnnRICI4Cgexe87+BA2EHTmrbOrkOlGf2A=;
        b=D7hqRv2T3DPcdwi+RvBAtSkt+n+iguS0f4KDO5MG+tSH28hb6R99KKnY0v8SLr9x7K
         bv3EwIU30X0kSjIhXl4yVmXCHCQdlC1PfZkVr+MlYSUCltLQmivMrpdQ7Z18V8hq8rOG
         jsduEETX2bHtzoPB/kqXj7WqDnIQAgpZ1GIdX0XttnLYa6OGseZ/Isds5K00leTyuNSV
         EZV7g8hV1IesJd1Igl0VfQRs1xQp8aJ9Dx3ERy5mhIFw17EyjbeR+gJ/Bvuy0Ev9Eie7
         0XHdeA8Cyg1p4REE5yyKSl5AkU8RWVAGOoyeOxQ6vI4bSuHMVrMf84bhxeQeeee58cFt
         nT3w==
X-Gm-Message-State: AAQBX9cXtBWPLbij+kRZXWzjRvKZEqNifrYV6Kgr7x6wKctu/poKwDc4
        0ai3OxV7X1yX6WdKT9L7caU=
X-Google-Smtp-Source: AKy350ajpLrRrIpIks6kZM2w8ItRjpnPJgbVsTQao3G1CbHXQRwBqmUCijkqXBqAKVNgTKtScjYrxw==
X-Received: by 2002:a05:6122:c9c:b0:436:ec6:8840 with SMTP id ba28-20020a0561220c9c00b004360ec68840mr4932371vkb.0.1679925506502;
        Mon, 27 Mar 2023 06:58:26 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id 135-20020a1f198d000000b004367f3393b8sm2731072vkz.28.2023.03.27.06.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:58:26 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Mon, 27 Mar 2023 15:57:44 +0200
Subject: [PATCH v3 2/4] i2c: core: run atomic i2c xfer when !preemptible
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-tegra-pmic-reboot-v3-2-3c0ee3567e14@skidata.com>
References: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
In-Reply-To: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
To:     Wolfram Sang <wsa@kernel.org>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com
Cc:     dmitry.osipenko@collabora.com, jonathanh@nvidia.com,
        richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Bara <benjamin.bara@skidata.com>

A panic() calls preempt_disable_notrace() before calling
emergency_restart(). If an i2c device is used for the restart, the xfer
should not schedule out (to avoid warnings like):

[   12.667612] WARNING: CPU: 1 PID: 1 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x33c/0x6b0
[   12.676926] Voluntary context switch within RCU read-side critical section!
...
[   12.742376]  schedule_timeout from wait_for_completion_timeout+0x90/0x114
[   12.749179]  wait_for_completion_timeout from tegra_i2c_wait_completion+0x40/0x70
...
[   12.994527]  atomic_notifier_call_chain from machine_restart+0x34/0x58
[   13.001050]  machine_restart from panic+0x2a8/0x32c

Therefore, not only check for disabled IRQs but also for preemptible.

Cc: stable@vger.kernel.org # v5.2+
Suggested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Benjamin Bara <benjamin.bara@skidata.com>
---
 drivers/i2c/i2c-core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.h b/drivers/i2c/i2c-core.h
index 1247e6e6e975..05b8b8dfa9bd 100644
--- a/drivers/i2c/i2c-core.h
+++ b/drivers/i2c/i2c-core.h
@@ -29,7 +29,7 @@ int i2c_dev_irq_from_resources(const struct resource *resources,
  */
 static inline bool i2c_in_atomic_xfer_mode(void)
 {
-	return system_state > SYSTEM_RUNNING && irqs_disabled();
+	return system_state > SYSTEM_RUNNING && !preemptible();
 }
 
 static inline int __i2c_lock_bus_helper(struct i2c_adapter *adap)

-- 
2.34.1

