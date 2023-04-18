Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683126E5F67
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 13:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjDRLKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 07:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjDRLKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 07:10:39 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5232F26AD;
        Tue, 18 Apr 2023 04:10:26 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a5so15607855ejb.6;
        Tue, 18 Apr 2023 04:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681816224; x=1684408224;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ClcmwgNB66OteygA0EuqrobbOiZGS0nq7YJHw1f4dDg=;
        b=OOrwxdJ+TptltfgKD7mdKkIfYgYrnRqhR5f1CHF0y/M/cOfoGgcypaJxvFgBGWCyMJ
         XiiKwzwdlRHbvaR9iZ9EL1Hr/bGOKMRXPsu+bnYu1VG1c1lEaphNWpAoEgtNWioZhElL
         i9CnT9jfNk0Y+DriIrt/bagd6+bkUhFg+U/z2kqaWju2YLt4/4lvo1Copw6hb1sxddKW
         QcuCU5vTjM5BsACMOz3PxcAT1swrk5VJ1eXCLnyJpcxGtExdTDJ2AzpFZkyCP2pQXRts
         1tjDmmAlYVkNfhuGyoGlqXZBc70TgtmNWngQQ7x+Rww98Dyh9bwiCloZfg/hnCXq21sj
         3A+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681816224; x=1684408224;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ClcmwgNB66OteygA0EuqrobbOiZGS0nq7YJHw1f4dDg=;
        b=AtQUxRBS+PL7CXK/9KnTUhC1PY+xtJjhzE8+Sw+a5ETgR+qtqs23DZLHvPMt7JK4Ew
         mI+azvezqiK58+8DYlNfgmEDIQlqkhlTo71bwHGDzHPGaBTB5cfvxYGpRaqaJw8qVYh7
         zpzFCgMhySi8JJT8/+Pl7O2OhJZmageDmfcH19qxjUrElbK2tY6MW33rZYnpMwyKQ3+W
         TQW569LefCCQqRO+V4pW7/fTg1kjhYPIODmrm1V9AyZQNyae7fziArtBohc9h30OFudx
         fdIBfKFM6omg54FdopLAjRlEq7YhqYnJyYgqZbvIUxgWxS4H37R5kn6GgpOGel+5wTOW
         ItGQ==
X-Gm-Message-State: AAQBX9d+qZ0XxjN9Szy5q6+7hsInmcmW2ZG64ObezJWVlpgw5kPH3KAw
        GjlG5eRGS67Y7aIT7HYtxNs35D1OET8s4Rkt
X-Google-Smtp-Source: AKy350YUcWUslAB83rGB1sJiMcb3ESb7iU6P49FaB2iONWpAlFBAnGQY6ghGDMjz1mpDQHpmzUgnJw==
X-Received: by 2002:a17:906:1354:b0:94f:6d10:ad9f with SMTP id x20-20020a170906135400b0094f6d10ad9fmr6280009ejb.42.1681816224592;
        Tue, 18 Apr 2023 04:10:24 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id n26-20020a170906379a00b0094eef800850sm5954554ejc.204.2023.04.18.04.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:10:24 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Tue, 18 Apr 2023 13:10:00 +0200
Subject: [PATCH v5 1/6] kernel/reboot: emergency_restart: set correct
 system_state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-tegra-pmic-reboot-v5-1-ab090e03284d@skidata.com>
References: <20230327-tegra-pmic-reboot-v5-0-ab090e03284d@skidata.com>
In-Reply-To: <20230327-tegra-pmic-reboot-v5-0-ab090e03284d@skidata.com>
To:     Wolfram Sang <wsa@kernel.org>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com
Cc:     dmitry.osipenko@collabora.com, peterz@infradead.org,
        jonathanh@nvidia.com, richard.leitner@linux.dev,
        treding@nvidia.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

