Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BD66E081E
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 09:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjDMHrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 03:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjDMHrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 03:47:11 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72159019;
        Thu, 13 Apr 2023 00:47:05 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id z9so8154509ejx.11;
        Thu, 13 Apr 2023 00:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681372024; x=1683964024;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ow1G+6M3ovTb8LY2mz6EmTo6+VyZI/HlronVRfHttzk=;
        b=GnvONpBdSzXOAXoZJpTRHIbJdQrjSB5inw+RRtcfkCmHeJFmJDBg2sgEYAARICKqro
         ZW4dbsZKCAqW1HI7aFBJYhnhCdfz1T//GdFyIputq6XULQtjR7NdJO+wdCm6jV0PGdjE
         CgqdCLChrFO6jKCUDncpBn0Cpmc1p79rjlcr92/cfY24YWqavVQ/Z24eepOGtI7hxMm8
         CPkyAbB/Xg47O5Ecs94EQ2vxSLNE3C10O8azgQ9ECFBg+j0cYiyD1fDr3X31ySPqWHt1
         ZaIm03+6miNeeTNAmowltZ34CV/Q78D+7XmkcnN7FIMNGVMS+ejwbDpKYCjKHFnitI+B
         W+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681372024; x=1683964024;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ow1G+6M3ovTb8LY2mz6EmTo6+VyZI/HlronVRfHttzk=;
        b=kBn9Ou+KGsXQPr6pcu0zcAdQUW55ByNwRC0YlSn9ohE0uJoGqV1WWBhcgoIgIh2Zxw
         oH5yvRFnytcXLltchYwhQrJfKzheq9nkM+FLq7TVjnppToxx/Fn8FkCgpIRgBA9bC959
         7tItfo2A1OkQZ7AJ6KZqpMA3xjCpOSDjD/O0rTTekBVJcsLA8CVYpXg1HfnbQLkWGhRU
         ogTog7ADkK44uW4RbZeLUjhfFjI/5XiTKsihRpgOULeoJS3bf3cxwgXfhdHmr+wWMULj
         TolrTdgOdr2eimKi4Njli5uUowDN2lFlEdsrzZZjJqj//e2SGtUOrV3ebV76z35Lcc+K
         /26w==
X-Gm-Message-State: AAQBX9dDr9DlNhJnMbDqbzgfwB9mws62SxEoN78HnJCeA8GgMq5GAXtX
        HXZHyUrP3XcDbeEzVqhZiWTTlV7OZKP0gQ==
X-Google-Smtp-Source: AKy350YtiC1xMPHzs5BOzuwlhrD6gtaQLKTdEhArz/ivGdRBLWpD/KnbyEhxP3x541KorlKZsF9XJg==
X-Received: by 2002:a17:907:72c2:b0:94e:6edc:71bc with SMTP id du2-20020a17090772c200b0094e6edc71bcmr4612049ejc.25.1681372024165;
        Thu, 13 Apr 2023 00:47:04 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id q16-20020a1709060f9000b0094e954fd015sm565620ejj.175.2023.04.13.00.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 00:47:03 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Date:   Thu, 13 Apr 2023 09:46:40 +0200
Subject: [PATCH v4 2/4] i2c: core: run atomic i2c xfer when !preemptible
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-tegra-pmic-reboot-v4-2-b24af219fb47@skidata.com>
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

