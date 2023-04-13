Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FB36E0823
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 09:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjDMHrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 03:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjDMHrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 03:47:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2192C900D;
        Thu, 13 Apr 2023 00:47:04 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id j17so25519715ejs.5;
        Thu, 13 Apr 2023 00:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681372023; x=1683964023;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ClcmwgNB66OteygA0EuqrobbOiZGS0nq7YJHw1f4dDg=;
        b=AjV+zXJEMNBunp6eQPdpjpUMGFi+BxNghu1MZ8+Vfc/09jHQ3bbpP2cbklQKhxkITv
         zcAKoZsXYu7toqkZOPr7OGhPtadWXuUQ9eMBbxU7d4uSHn7xP0aPwlvGyofuCFJ02EuD
         oVgVYhxicMPdRJJ+GngviwUkuvetX7r7jHP0LzzKGd74d4PBxpOxAp1vAgeVM2Q8LQZh
         JFEd7fHwi9J/6SegvCRRrcqDZCJ6a4K1udQrrIt+yLjen2ZCxwBoq7R6qi0ftriNONVp
         QOL+ZaxEx4KeCC+QLa94aONq3QUq9EXpIKfqwg3LR7nkZ25jiQWNUBHD4KuoXsY++gWU
         gTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681372023; x=1683964023;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ClcmwgNB66OteygA0EuqrobbOiZGS0nq7YJHw1f4dDg=;
        b=L2q7hjsAv59Z5PJ+M9eoOnIumvwySg/gdG9UevBqhG8H3rQeAZsY7b3XyOSPIH2tvb
         rSs1gXoVTaQ6QWZuyHE5RBC3KvllIHlAyQuAOhdpJnZidZcMtj3xuWsMzRBiAcl3BbaJ
         +Nd7BMn05HDjucg8DyH7p+ylaDxeAExNE/Un88jB+G6492cFbZOmB60fsTfkX2AUepd/
         8WwRDphjHX//JOSA2/i2ZRAGX4QeFq/dl9EGH0cYsZPpurzRnlsugHS2JXvucvg9BuL1
         WZN6oB6g9Nsfi6TXngZ6DIOypcF8WIyHkyOaFghAY9Ar6ciie5qmdkWs9iuNhgq2W58/
         EAyw==
X-Gm-Message-State: AAQBX9dA6s0SX6r5J17iBJyMG7/bLbjm7UUBkunkLi+5CwtljEY68bPJ
        eMuZux609M680LswXddU4DwDWjoKiPiWdg==
X-Google-Smtp-Source: AKy350ZCJvHHcsvJfua+Fuuwrd/Mk2JeDg4EvWaPxTuZLD+ESaVwF3Du2cr0Ew2MTlxiq5x4YSIV8w==
X-Received: by 2002:a17:906:5490:b0:94a:6897:88bd with SMTP id r16-20020a170906549000b0094a689788bdmr1551168ejo.60.1681372023246;
        Thu, 13 Apr 2023 00:47:03 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id q16-20020a1709060f9000b0094e954fd015sm565620ejj.175.2023.04.13.00.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 00:47:03 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Thu, 13 Apr 2023 09:46:39 +0200
Subject: [PATCH v4 1/4] kernel/reboot: emergency_restart: set correct
 system_state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-tegra-pmic-reboot-v4-1-b24af219fb47@skidata.com>
References: <20230327-tegra-pmic-reboot-v4-0-b24af219fb47@skidata.com>
In-Reply-To: <20230327-tegra-pmic-reboot-v4-0-b24af219fb47@skidata.com>
To:     Wolfram Sang <wsa@kernel.org>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com
Cc:     dmitry.osipenko@collabora.com, peterz@infradead.org,
        jonathanh@nvidia.com, richard.leitner@linux.dev,
        treding@nvidia.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Bara <benjamin.bara@skidata.com>

As the emergency restart does not call kernel_restart_prepare(), the
system_state stays in SYSTEM_RUNNING.

Since bae1d3a05a8b, this hinders i2c_in_atomic_xfer_mode() from becoming
active, and therefore might lead to avoidable warnings in the restart
handlers, e.g.:

[   12.667612] WARNING: CPU: 1 PID: 1 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x33c/0x6b0
[   12.676926] Voluntary context switch within RCU read-side critical section!
...
[   12.742376]  schedule_timeout from wait_for_completion_timeout+0x90/0x114
[   12.749179]  wait_for_completion_timeout from tegra_i2c_wait_completion+0x40/0x70
...
[   12.994527]  atomic_notifier_call_chain from machine_restart+0x34/0x58
[   13.001050]  machine_restart from panic+0x2a8/0x32c

Avoid these by setting the correct system_state.

Fixes: bae1d3a05a8b ("i2c: core: remove use of in_atomic()")
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

