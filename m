Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA59D106C61
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfKVKvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:41 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33508 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730083AbfKVKvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:40 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so8103876wrr.0
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MfKJ/5LhXGWemwyCoLTmrzrTqXxWjUaJEcDcUsWi2Bw=;
        b=ecezFEN5tASpm9yGZqiy0PFAxq9dAZihSqIw8xLd3ulOl4A43rbKLoismCKETZl2BQ
         xbKABtiUqRdQI7Qx75AXrqC8KPqhAMBYabuwsPZanVws3SmthfPZHQHuPfvin7c3aj3f
         KGnVy1Lixo9g6rYMdOL/qwyO0XdYSr/ObVZpSloCPQm/9wRVFMZsYoGKp37GBETsTx8Z
         R0HbqooUVf1hJWzGjvVUkpKV7QFnk2wFHhOPdWeSzBKwntImeY6gLy8Scjw/52SdoTKl
         bdVwlUHqZqBA+5k/dga6IoukJzBbFHcEqF315GD3uk/mYFWSz92Qm2xp+DNkZrvxmTJD
         zxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfKJ/5LhXGWemwyCoLTmrzrTqXxWjUaJEcDcUsWi2Bw=;
        b=GkurZ7KubvywH63/RwRoHE6wr59W74vxOyqAFsA51z/YFECguSO7zFtS97S9/C9nPf
         LITZeBJsDsapFw57aE/sXVJwk+pfRS24EKkn8id13Q+uxlu4Oab5tRs6CfgQKlvdUz46
         S4Epr54aMODA0LBKu5sUPIkIvVQ5o40N7yXHyHeiLHGrWFnipJb0oX7cKSOf/KSW/Hy1
         hCOo3tvvCistAmGJ057M0cnKsxfkDwtD/GZ34rmcDLSx063J3r8XCnpzRLYPx0C+IAHH
         y5GWk7XxRaVDVHYhd/973KZlkhlYvYkWStpgbEeDOTvYfU367JaG0AZrfRxVGMbiyT+k
         Ijvg==
X-Gm-Message-State: APjAAAXzgwlrY7lUUeJrfVkNP3rHKh1zfbyuPnYZ2E8/228sAj5NTkcb
        WxbuthJHT0tAGTt98JeflDHqIQ==
X-Google-Smtp-Source: APXvYqz+EhOre9ua6kmO1go3eiduSIVM39UxUYSMBgFKISQxspyN120gBlNGvbSQMxECDpy5o23ybQ==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr17981459wrm.199.1574419898594;
        Fri, 22 Nov 2019 02:51:38 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:38 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 3/9] arm64: fix for bad_mode() handler to always result in panic
Date:   Fri, 22 Nov 2019 10:51:07 +0000
Message-Id: <20191122105113.11213-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
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

