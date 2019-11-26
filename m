Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE55109F84
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfKZNsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:53 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37401 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbfKZNsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id g7so1845264wrw.4
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pyCbvIo8RpUhzCaEVpT7tib1z7NzcXxt9oyOApO0ka0=;
        b=NAB4M0f+akwqyQrDCD0Wwi453tZGZuXbxN5ij88a6hKjFb5E7+CtKSnUkPo+Adi9C0
         HZiXQnIWZ5LqUMJoEmqYsx2n7RTv7PMaYq/wKBo1qh4GS/hMZXBLksryERK3y7hXJ01n
         xyM9c+l2Dx6pJJCjb0ZPPUcMYx28Dtbez+tc/rwEoUZkd+j5gpBjqml4gSfwYD5gMFDC
         NLrMppeeWDfzMhmuykH/cYijpFRY0E+BLViO/QsRo5Qz1FNQAS6jKYyYtLfd5OMXBxLW
         O5icZTDrtNEN6oHbj0D/gUY5PgPbxclmfAmMc+pG82/8U6UbzpLKr/QbPfnye/9+zYnY
         ouKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pyCbvIo8RpUhzCaEVpT7tib1z7NzcXxt9oyOApO0ka0=;
        b=IRTkFKX4Kds6dZkukntHGDL6G4pLkK/YCNe2j8Gjf5z/hFzbnybr1tn5tJsg8qLWnr
         MRw0OJF46POqGRqa0rcKe0jmQKMO7z+uOxU5UF7Hu8FWEnOEfLgEbmCoqxMHc0Cp7xbl
         1WgLCyiN8fbiErobB93V9z7XFbp+vcR8obWMHa9EGd6BhiwHufZW98UE2+nHXqGu9JdJ
         M2Ng8fqPaaEPVWEQRZRUfnbXGpvNXiqyN6vZ2+R9Nregxyum4QQgWS+Mf7BsqmKVcrjr
         rycW8L5kM89LM/7iER36v0UXwgMzeFMtrio5ezhqpVaJeZ+8o3mQomm3IBUqdSGhWB6i
         EXFg==
X-Gm-Message-State: APjAAAVJ0m5gfWZ740u49lCa5eBwfNWVmBDMuITrqvUH5X+YcW2RDTIP
        59zwCnztRHngWke2l6+JvBnRaOB0SlE=
X-Google-Smtp-Source: APXvYqwkEBoPCfVbFRFxh/7p3MqdK28DnmKXnPBZrz4xLcKVgaQUCBsvFyL/VgBdo7XqZCUPKs+HLw==
X-Received: by 2002:a5d:670a:: with SMTP id o10mr38581365wru.312.1574776131333;
        Tue, 26 Nov 2019 05:48:51 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id m9sm14374131wro.66.2019.11.26.05.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:50 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 3/5] arm64: fix for bad_mode() handler to always result in panic
Date:   Tue, 26 Nov 2019 13:48:28 +0000
Message-Id: <20191126134830.12747-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126134830.12747-1-lee.jones@linaro.org>
References: <20191126134830.12747-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Vyas <hari.vyas@broadcom.com>

[ Upstream commit 64cd64a02fc8bb23916ee8841ef510f2f1f2540c ]

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

