Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3323D10AB03
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfK0HVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:21:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:32921 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfK0HVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:21:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so4181254wmi.0
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MfKJ/5LhXGWemwyCoLTmrzrTqXxWjUaJEcDcUsWi2Bw=;
        b=c657nsNxD6nOQLg7WIu9zeDoxAnWqYvzCSy8lAO6VxGKn/hAU9huTL3S5nZZ/VREyS
         KrCJkjYnwG4aakAbtEk8/HfW4PENQpk6rOJnOADm2E4tzF7gt5L1/SX4UoxH9QDjl3eJ
         BQ1b9xNsD1Tyq2K57Tf3LFSPmtXt4+Jc0ZFXJ978zhOQGmwv7Yhf44Xm1ZCEYfiT8Ydm
         hX+CKVNpw+f8jtwmKQcIR+NGUg9nb8O02y7exroWyiBYUXkaKBowoV9YYuNsQ6iaQR6k
         nNTeDo8UHLwoan4/olH6KTG1Mp+hFqFPm6M7c4pbnLVI4l6zlbukc8+uhIiWW6Qc9OMH
         Ao6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfKJ/5LhXGWemwyCoLTmrzrTqXxWjUaJEcDcUsWi2Bw=;
        b=r5E9W0mM3OEA82gGWSwB1PWIzZ4ZPvFqzmLmOvVweL5L4HDRR6/cOLzpVXHzNXvFH7
         rSo0nouHsrUEL+dcjOs/T/TXj/tmkw7Fso/5pv7AQPmr88CdGcD2eAVa/Cqyh5ZIMkej
         xTjCqMeUC+7DC/e4VeK1C/SYiNXNvyzkfmNPK0CuaiQynB3FV5ft22LTJJ2Hj7LhyBIy
         x1/WHB+QANOoota78dakYNMVxAA/DDqjTvI8W2hsso0Ipfcz56AkKYdOaTmFRuwpBrHq
         UOwfW/b1JuCFG0v9nAp42V3LcdxquhuWlyU1QpAlCZLDO67egMv8PBhcypRIwAQSY8pS
         9ADQ==
X-Gm-Message-State: APjAAAUZqGilB+w0JWBoZZpXkDiMwkk2jdDs7kxDp0XhoSOqyk8MybIE
        JM+/wG2uQ58cH7zz5YZfe12ESOuGzCQ=
X-Google-Smtp-Source: APXvYqzb3zX0EUUGnVlreRohJBA/Fyw45stEzs9OfuUaZo+FSDig5xWaOjrXfA81+ZgHingU7o0r8w==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr2620937wmk.133.1574839310696;
        Tue, 26 Nov 2019 23:21:50 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id y6sm18151872wrn.21.2019.11.26.23.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:21:50 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 2/6] arm64: fix for bad_mode() handler to always result in panic
Date:   Wed, 27 Nov 2019 07:21:20 +0000
Message-Id: <20191127072124.30445-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072124.30445-1-lee.jones@linaro.org>
References: <20191127072124.30445-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Vyas <hari.vyas@broadcom.com>

[ Upstream commit e4ba15debcfd27f60d43da940a58108783bff2a6 ]

The bad_mode() handler is called if we encounter an uunknown exception,
with the expectation that the subsequent call to panic() will halt the
system. Unfortunately, if the exception calling bad_mode() is taken from
EL0, then the call to die() can end up killing the current user task and
calling schedule() instead of falling through to panic().

Remove the die() call altogether, since we really want to bring down the
machine in this "impossible" case.

Signed-off-by: Hari Vyas <hari.vyas@broadcom.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm64/kernel/traps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 6b4579e07aa2..02710f99c137 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -448,7 +448,6 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 	pr_crit("Bad mode in %s handler detected, code 0x%08x -- %s\n",
 		handler[reason], esr, esr_get_class_string(esr));
 
-	die("Oops - bad mode", regs, 0);
 	local_irq_disable();
 	panic("bad mode");
 }
-- 
2.24.0

