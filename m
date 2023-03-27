Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1826CA699
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 15:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjC0N6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 09:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbjC0N6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 09:58:25 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D8F40C6;
        Mon, 27 Mar 2023 06:58:25 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id r7so6422367uaj.2;
        Mon, 27 Mar 2023 06:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679925504;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RbQS5zutEzfJYNaqkxdL9nLc8p49ExIzbuyhSxQJkfQ=;
        b=p5LsK61hvAoejly5RT/XyubS4vTQm18wYHk3CjXYFXxwe5WX8NNfuS7Dr+gaiJkmks
         tkTOXdg6tNNvzI0lITqEyBjFK3TjIT6dSnriLci/3Vj96A1VGpXj1UG3oh2YWpyewNI9
         D6Z8tbVj+drESfGNNqNPucxVRUq0PqKP0crtiLdrbDq28wXsArvatYR8o7YB0bqa2LSk
         gb6Aqs5nulHXHo/GOZl4zXkr7bIbCwzGdLScArHGNYNM/5ZRhjm8v8grrl/m3TfdoMz7
         7Gv1XJmoLRIPN0198jz3giDHmhJZPS5ozrhk0fbu3RBqfXxgEJ3PaW32WXmRrFc1iq5i
         fUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679925504;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RbQS5zutEzfJYNaqkxdL9nLc8p49ExIzbuyhSxQJkfQ=;
        b=Sb8GRT7XkIR0g69wStEboFMNTzqwlsSg+tWIxdNzZGl+Xn4m7Jj6+aIh5azBxWkPmZ
         KAC9J1DB1alHlZ5dY3yeqMEZQeYvbh0ha2jyTruPRWNuzyfGqpMmPYBaanHlXlBvMwE6
         9iwZQ79fNutVyoCg/6pMHGX/c4kJw25wmqKAIHt7cpaie7MYYXfedrovXN0gWnp+/nPA
         D93ahTmoxO7caDXvhs6AQeODOUOlWQ1o4dW4yId1JZuXOSV1mLmG0n3UZwifJWVpQXkD
         gyD1M/CJAH2FxAAwdXiZMAPq89I70AbSlM3Q31POjJHmEl1x/dJfdNIVDZjrK6C+cE+g
         Lm2g==
X-Gm-Message-State: AAQBX9dn1/VBg3/GirkIlFCDkr8yRoMfx7p0Ui2oEjo6k/1F43LKuscD
        YNjXZYTyKFpqNbu+bIfFBb0=
X-Google-Smtp-Source: AKy350ZiGz6J6WdYGaWwBybCjOYrebAiX4r6AxIV7zwim3JCF77bw+CD865zxEPZs31aNSsbUPWBDg==
X-Received: by 2002:a05:6122:1801:b0:432:6c1:3aa8 with SMTP id ay1-20020a056122180100b0043206c13aa8mr4715979vkb.16.1679925504296;
        Mon, 27 Mar 2023 06:58:24 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id 135-20020a1f198d000000b004367f3393b8sm2731072vkz.28.2023.03.27.06.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:58:24 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Mon, 27 Mar 2023 15:57:43 +0200
Subject: [PATCH v3 1/4] kernel/reboot: emergency_restart: set correct
 system_state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-tegra-pmic-reboot-v3-1-3c0ee3567e14@skidata.com>
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

As the emergency restart does not call kernel_restart_prepare(),
the system_state stays in SYSTEM_RUNNING.

This e.g. hinders i2c_in_atomic_xfer_mode() from becoming active, and
therefore might lead to avoidable warnings in the restart handlers, e.g.:

[   12.667612] WARNING: CPU: 1 PID: 1 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x33c/0x6b0
[   12.676926] Voluntary context switch within RCU read-side critical section!
...
[   12.742376]  schedule_timeout from wait_for_completion_timeout+0x90/0x114
[   12.749179]  wait_for_completion_timeout from tegra_i2c_wait_completion+0x40/0x70
...
[   12.994527]  atomic_notifier_call_chain from machine_restart+0x34/0x58
[   13.001050]  machine_restart from panic+0x2a8/0x32c

Avoid these by setting the correct system_state.

Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Benjamin Bara <benjamin.bara@skidata.com>
---
 kernel/reboot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 3bba88c7ffc6..6ebef11c8876 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -74,6 +74,7 @@ void __weak (*pm_power_off)(void);
 void emergency_restart(void)
 {
 	kmsg_dump(KMSG_DUMP_EMERG);
+	system_state = SYSTEM_RESTART;
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);

-- 
2.34.1

