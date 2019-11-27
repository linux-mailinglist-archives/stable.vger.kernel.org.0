Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A818810AB10
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfK0HWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36719 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfK0HWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so269769wma.1
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UkHzamxVtuUS7zemJUdLlEXA8p8MD2PYQZDZcwjFn+o=;
        b=U+OC6opPrUtU67vosJD0CgnLoh9vPISVqDlzzGGINRMwbypZA4NK/O83RmtBCCzqZT
         QZXOYotXfS02yb297VPejf/ipF2EDFl97YCK2D5xXc8Y27MZF/M7/Jcs0A8IZsvVBp6G
         yNenyVPel9Zma9T98xQzFYK+vUkNhYPBzOKSLzuTVmMZWqUx0VgAyackHC7SgkP0mgnx
         C8yC1hbOTl6FYSE+efFA/tQuWl8z7jNv1s7y3tcKtDjBlpeAswA307TnEjneJhXNVGuG
         9dDoFM0T3T+xPBhqpcK48M095ManHCRb7lVuZkdHEPo20lPpXVulU0l+KGyy7M1rv1ue
         M14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UkHzamxVtuUS7zemJUdLlEXA8p8MD2PYQZDZcwjFn+o=;
        b=dc5M4AExKTysXMAE0spfeDA5sQe5ZfRwVs6UOrLlOo/ERhGKJPe24WqoQDkVeE0SvW
         /D0nhFpH9215AmI8hkk2ixPuCRm4gyqECkHdleDhYLJrjHl6NWSvjF1/jBVuCIB5RZ0j
         kbrqbsBYqQpzIR8p/RIurLjREzMV5tnJCwKiN4478/InrMEnUkC3NpRv8RMeHJpEpR2I
         EzlJo5VS3Lq8SG5e76eQd8IMwxWdMMg9oQikK4dd7davOdg+IoYePWx2rZyTe6hgY/p9
         Dd2+VFhCWFAXPbowaSfwdiAWDGndaEDv0cuZh5UwDouwVjgz4J4bNMDHUesesnZ2P1Du
         eq5A==
X-Gm-Message-State: APjAAAWp1YjKINHpv7UOEd2ZZ/wMQCRfL0Le3c24vJKIzU84DKCkdPGF
        QVHYfkVGgKgOb/dgZ/G3W8fg7CygfK0=
X-Google-Smtp-Source: APXvYqytVWiddle3/anK7jjyBGlUA2yJQQ03TaSFlX8Vf8forrmrAZDYRy/fNOdWC6KUqhzn+r9zrA==
X-Received: by 2002:a1c:ca:: with SMTP id 193mr2718360wma.111.1574839338891;
        Tue, 26 Nov 2019 23:22:18 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id d20sm19406915wra.4.2019.11.26.23.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 3/5] arm64: fix for bad_mode() handler to always result in panic
Date:   Wed, 27 Nov 2019 07:22:00 +0000
Message-Id: <20191127072202.30625-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072202.30625-1-lee.jones@linaro.org>
References: <20191127072202.30625-1-lee.jones@linaro.org>
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
index a4e49e947684..5ae9c86c30d1 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -648,7 +648,6 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 		handler[reason], smp_processor_id(), esr,
 		esr_get_class_string(esr));
 
-	die("Oops - bad mode", regs, 0);
 	local_irq_disable();
 	panic("bad mode");
 }
-- 
2.24.0

