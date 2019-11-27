Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA2910AB0A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfK0HWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:07 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39459 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfK0HWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so6147693wmi.4
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aMdmhI1a3eYH/WVtmSydJcMj1XByvjyqY+PnBFpibbM=;
        b=LLZaJFtbEGV+rlO3FJCGbAUCCKQRegFJJ7EpzzHN9oXXjTwIXOONT3+P13pF9mTnM6
         OBKSr2nYX8DGaNH2AI0tbRvaJULHmasw2pd6TWbAmN3mTx+2ym0Z1w4deB0pLxcG6hq6
         d3Fp+CR6NQmkGIzwaGEqF/7vddiPicAJunT/7uVF9vT7zRdSyxT9yww0XjIgeHdxeDe+
         b85vQK8yCtNlUG5e4quSZF+1qLzDOiN2S93OgVH/ot9G6Ipk/3YytQfxA2WITeRuccEi
         t3aza+rxNJx2Z++0kOctYvt1xgq+SZXzaSqYtnFHCfmzuOD1/HWOIM1G5GBr/efLmUPc
         qA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aMdmhI1a3eYH/WVtmSydJcMj1XByvjyqY+PnBFpibbM=;
        b=CfaM1R18iGyMtrKgcszfZvlvxxXM/S9KAx7tvV0EYW1dPmnskQazJBQ9oblOD5ZXr8
         XMHHtB4SIaqjvt3OOxFqf4POLaAMdYyK5ekZiipldM4iVy6qo35CcYvcjZT5o/98VaWU
         9witF4rP/Py9pHpeqY5/YUR2+SoGjb/206fkS+D0niB9LLtkmBr+wTzI0ST1Nh1rvOH+
         SBWo4m+SD+4Emwlo4Wgow8dAogLxqYamKTTB/JrZCclLotnY/njelVaRNbRT7MvEN2Oa
         Z55KVlbQKZNWo2M+/Lpf/r/g3TQn5oi+aBt22qL2UknekdGzOh9sXWuwTyvZ2wwUlYTN
         /HhA==
X-Gm-Message-State: APjAAAXnCW6zpjI2E0e0yw6ctwISORh40IkGZoPCaw+Z8wcoiSJkompG
        decmZCGPUTX9wrRtd/9l7BWoLqK1Txs=
X-Google-Smtp-Source: APXvYqwLGEUg+1JVMJM0LuOa43qKDpcOWLaNe+DqXXO4glmGRlZ64P151W1D5u93G5ooHaea6gd5AQ==
X-Received: by 2002:a05:600c:2410:: with SMTP id 16mr2651853wmp.36.1574839325138;
        Tue, 26 Nov 2019 23:22:05 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id e16sm17983130wrj.80.2019.11.26.23.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:04 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 3/6] arm64: fix for bad_mode() handler to always result in panic
Date:   Wed, 27 Nov 2019 07:21:41 +0000
Message-Id: <20191127072144.30537-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072144.30537-1-lee.jones@linaro.org>
References: <20191127072144.30537-1-lee.jones@linaro.org>
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
index 28bef94cf792..5962badb3346 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -611,7 +611,6 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 		handler[reason], smp_processor_id(), esr,
 		esr_get_class_string(esr));
 
-	die("Oops - bad mode", regs, 0);
 	local_irq_disable();
 	panic("bad mode");
 }
-- 
2.24.0

