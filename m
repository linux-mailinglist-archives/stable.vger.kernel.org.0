Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD29F2076C9
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404140AbgFXPID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403831AbgFXPHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405D3C061796
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:14 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j18so2650319wmi.3
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g3Z/1Sd7KiUmvxa4jor9PLam8Q3K0QVIvvAftZ1YelI=;
        b=Dbjw8KGXNnJR4/Cv9UY5wql6tvwgAVUE3t+Ql2V7uqKucZ/2lLic1lPgg7arybg/Zv
         BPvQSpSjk+WFFTm6Ryjn5CCh5S44hDzHQealupKltEpkDgvluJwY4Vyyh1+bDYHsLFvR
         XxeB3/USF+YNB0BiW+2J7WhBAPKe9YtuzvMBzMUN5NaIjjygKhjsdMOwmU1NEwTHTPVk
         0Jo2DMHgKs557saxVmYCP4vImoVwz7KcSk9WdMgBLHj74Kyjb9GIOtjBuAtNQ9VIRtoD
         V8K7Mx1uw2+Lt9rme1GVEtyg99f/y8opZ4jln0sKsUb/oiikPgu5OzLfhFqUCfbTBiNF
         3qIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g3Z/1Sd7KiUmvxa4jor9PLam8Q3K0QVIvvAftZ1YelI=;
        b=UsWxhxdC8eAGne2sNSKJilsJgAAfHa0wX3fR8inIBNQGRGhZNs7+F4D4/PwIwvypTz
         DDtBRqntkiV6EopvGgXP9MkVgATkjCGdqf/iBFcJ6zggUqQUPccjJSnCmUtw5d7GB9wr
         rbczHmsR0y7Cpi0q9J7cvPJmqONycGL+p1+Gb3Tn9rtIepe8+uxcYpaqNKELRl4mqGSy
         xybFDMWOXv0ld7J5+Le/5fMnlS6KjlZzbdXMiPx7x1UEYX5rGNAxz+8DTaAfFFlmKU6a
         5y0147rnRPwHJpEqQW2vMfsvqMR+p1bZALCzVn+m4D0YrmQAqTJH7qccOOBvYClDiFH4
         +5pA==
X-Gm-Message-State: AOAM531Z3qjJyvmxz52vTiWAOvn23i8cwe5Eib1+Q5fkSM8NQy/cTfa7
        Sl0lPPDyWm4aSHfynkF5P5nVpw==
X-Google-Smtp-Source: ABdhPJzVLUwK2s/MOqSCAQcZkXnN+fggMvRKgafQCLwEIMyGzj3cCIhqWF3b0Km0Am8CCXEcMFz0HQ==
X-Received: by 2002:a1c:4e1a:: with SMTP id g26mr29750762wmh.148.1593011232892;
        Wed, 24 Jun 2020 08:07:12 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Kai Svahn <kai.svahn@nokia.com>, Syed Khasim <x0khasim@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 01/10] mfd: twl4030-irq: Fix incorrect type in assignment warning
Date:   Wed, 24 Jun 2020 16:06:55 +0100
Message-Id: <20200624150704.2729736-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Silences Sparse warning:

 drivers/mfd/twl4030-irq.c:485:26: warning: incorrect type in assignment (different base types)
 drivers/mfd/twl4030-irq.c:485:26:    expected unsigned int [usertype] word
 drivers/mfd/twl4030-irq.c:485:26:    got restricted __le32 [usertype]

Cc: <stable@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kai Svahn <kai.svahn@nokia.com>
Cc: Syed Khasim <x0khasim@ti.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/twl4030-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 910a304b397ce..d05bc74daba32 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -477,7 +477,7 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 
 	if (agent->imr_change_pending) {
 		union {
-			u32	word;
+			__le32	word;
 			u8	bytes[4];
 		} imr;
 
-- 
2.25.1

