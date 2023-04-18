Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709366E5F6B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 13:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjDRLKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 07:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjDRLKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 07:10:41 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903D38A45;
        Tue, 18 Apr 2023 04:10:27 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ud9so71931986ejc.7;
        Tue, 18 Apr 2023 04:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681816226; x=1684408226;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WbgVQUp/vUincJRkcsp/7lCVaCrW8ZOrNJHo4G9adBQ=;
        b=WHN88Vc9KjwSakLtGnGRxSGwAb5hfpAeWjrK647q2A6PsNe5izO5GzkcJPGI6sW6uj
         jB3D7Irqtyf8vjBNUGd/V5iWbc33CbakCySOYjxTRlG2vwGY74x31/Nrsu/rKr9/4xFT
         92cYgR8Bh9Ety6g/cq9dARHDFOqjXBmeFGqwQdzNsTNwlv44D/61gPvXcw9MEUeIPOBS
         wmNeAvp4LasaHVBPseGpSDFceiHLT9vSdnbCtPtgmuDbOGE0vV4l0Ns3FXceRcZY8k9u
         WFml/gABit3ZGZtcXwQK9BvXEA+W1gI15Hf6JETIxj6FWY9QezjNL7mcKmYdE5zXwBEd
         30ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681816226; x=1684408226;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbgVQUp/vUincJRkcsp/7lCVaCrW8ZOrNJHo4G9adBQ=;
        b=LE/WloCH2Wq6UpxrwpBwpbVT9GjDzoIQA1LkdBGl3MHIIZoiERHioZI843jkUp7ctp
         U6QirwDGMN87AX0p//k7Y5E42FT00cwU2Xqsn+UpEOAoD5enL5D8hv9tP/pPXMBKmc8+
         2s2/BrT04GwS5H6hC24GJ7rN0nVR/qCpdvnQJQwDyH60pFN5EVgUlYs8xL1m7FA7fSR9
         PYzzycwYW+3d6Kns7WB6OckL1xAxtOtG+PgwwsgOrTuW6cRP9R+4KESQwGF7LyS+OSEE
         A76zsn4j1wq62XUo4tM6xnmZGwgk7A9kSm6rSRZ2wzmrI1ORcTMU2pat8PSlmzmHQopz
         0XSA==
X-Gm-Message-State: AAQBX9doFR5taJzWOrrj5VECH8i9ZUAQGwqTj5h+qi1rD8EBYdXerspc
        1fa8uNemTJwK/liJSD+VgsC2zsYT3BV/Mr4a
X-Google-Smtp-Source: AKy350ZuIdjnhggkyP+eOiGXyizYmsnDJvuabPw9yGecpbmmPdEmaRx0JM48/q9ZC1e4KuZrdXMHYA==
X-Received: by 2002:a17:906:240f:b0:94f:1a11:e08b with SMTP id z15-20020a170906240f00b0094f1a11e08bmr9336774eja.20.1681816225496;
        Tue, 18 Apr 2023 04:10:25 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id n26-20020a170906379a00b0094eef800850sm5954554ejc.204.2023.04.18.04.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:10:25 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Tue, 18 Apr 2023 13:10:01 +0200
Subject: [PATCH v5 2/6] i2c: core: run atomic i2c xfer when !preemptible
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-tegra-pmic-reboot-v5-2-ab090e03284d@skidata.com>
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

Since bae1d3a05a8b, i2c transfers are non-atomic if preemption is
disabled. However, non-atomic i2c transfers require preemption (e.g. in
wait_for_completion() while waiting for the DMA).

panic() calls preempt_disable_notrace() before calling
emergency_restart(). Therefore, if an i2c device is used for the
restart, the xfer should be atomic. This avoids warnings like:

[   12.667612] WARNING: CPU: 1 PID: 1 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x33c/0x6b0
[   12.676926] Voluntary context switch within RCU read-side critical section!
...
[   12.742376]  schedule_timeout from wait_for_completion_timeout+0x90/0x114
[   12.749179]  wait_for_completion_timeout from tegra_i2c_wait_completion+0x40/0x70
...
[   12.994527]  atomic_notifier_call_chain from machine_restart+0x34/0x58
[   13.001050]  machine_restart from panic+0x2a8/0x32c

Use !preemptible() instead, which is basically the same check as
pre-v5.2.

Fixes: bae1d3a05a8b ("i2c: core: remove use of in_atomic()")
Cc: stable@vger.kernel.org # v5.2+
Suggested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Acked-by: Wolfram Sang <wsa@kernel.org>
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

