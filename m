Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA9C106CA2
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfKVKxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32793 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730202AbfKVKx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:26 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so8110562wrr.0
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aMdmhI1a3eYH/WVtmSydJcMj1XByvjyqY+PnBFpibbM=;
        b=mfwsxBmQFTpr3EA9Pzd4t4wXa0DuQaLEcu4cAf1f2rKo4N83Q0zZQAg5N+7sf8XM+F
         XizUehbATtWhsiqI0fxc8svRBPxWFqC9qb7q4X9BEoKYkjgIryp1YfzQSXoIFlsKrMRV
         UNvnIYlcIT9jnGM9DP5Y7r8GREAR3vN7XSKkpyyBNVwvzMK8a1TLWyUNbtmCZ6He5XJz
         16OJkz7yDUiT40fgz3kAwN0zRpE2MB96fYiGoXFa8msjLFzd9jblkU7SeoOiDcXaSsvo
         NvHQsRdFZht/2xlDF0qxWa3KhWrekbyFVjPoI6mpA9uh9TTmMr/1fdMil6D9HQBGPunY
         b2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aMdmhI1a3eYH/WVtmSydJcMj1XByvjyqY+PnBFpibbM=;
        b=C6hH50dj6EeuNOY0dOqZ4W9oFaVshAt+GFn82AcwkizMl/YNplTDDOuMolaSqH6mI9
         KxfwhDcbb3bC4GsNIZF+wBiw1Dz5tLD/D0PVqU81xoY3WomFxeU8sT27Wk+3GOaBOKSl
         TBfXKhUEiccNGQT1PengpOpUGI1KaTs0TLCb+QEd98IXaLccJ3vOPZqcSrpel5XzoOn5
         1mMVldjdnLPL7iRkWfZrXILIQ3ooW2e6B2ag6FFoDLoyeB4RMytaGnH8nGc790uQnZ8P
         HRk5c0yxKR4/qyUg1ASmvlPsxlARS+ZMEA/gtlqRx4vz3BR0rdjW3+bJyUzgeVr6YhCU
         TCXA==
X-Gm-Message-State: APjAAAVll6rMQ7v2nqT3ElbzzyBtxi6g/OLpdWKTYXFeCcISbwIsnkQz
        kCfJ1T8HPYkq0Jw31rcGXwgtPqxdepM=
X-Google-Smtp-Source: APXvYqy2mdPWXcdPYqW2tSMi0D8cUDixg4Z3A3/WOENKhJo8SYGXBJY5d5+mwXTohoep5hjIosnarw==
X-Received: by 2002:adf:8426:: with SMTP id 35mr15476380wrf.262.1574420004672;
        Fri, 22 Nov 2019 02:53:24 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:24 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 3/8] arm64: fix for bad_mode() handler to always result in panic
Date:   Fri, 22 Nov 2019 10:52:48 +0000
Message-Id: <20191122105253.11375-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105253.11375-1-lee.jones@linaro.org>
References: <20191122105253.11375-1-lee.jones@linaro.org>
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

