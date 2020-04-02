Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4416A19C979
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389092AbgDBTLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42517 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389074AbgDBTLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15so5559785wrx.9
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+qhXDspqzMy/AjzcIY5DO4b+V5ek/qsdVK5p3wmyDGc=;
        b=nRTlfCtxh8R+Xsr8S/GGhQawNSlBDgKQDrA81PnsqxO8bll9BdxG2OdHpZGEJbm/ZD
         mzACxZTy1SoQj++8D1dVc3XqZgEWi2YCmbCRGj1vzEUovvt/W4wCeUJutdTAS4eNEPND
         g5yCFm4Oq7rmqYuuG3YIPHbF2WBpBP9NIIix4WRMQiu2hnFp8AiNFsyWMB9nK6fpQIWw
         bunxAGmtnSERUgoThBIoRqD4nPm3vIkwCrhtDsvrc6puGiiFcJb5OM6+/FVM/DAZEY9D
         /l+TX30Se7021Id0x7/qIyQybcLliMwC/yCqwBjFTuvHzlELWn7MLb1bRQ4iZt8Ckeun
         e0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qhXDspqzMy/AjzcIY5DO4b+V5ek/qsdVK5p3wmyDGc=;
        b=BqWECWiFSa/6ajNAk+z/3eU+9a9O46GV2kGEuWY3Jl1pE79diDkfGvhgwDZvMAxbTH
         2oQm1rTqWr2mrEwitcgcMTqwz7+u8wDx6QkVca0leOD2gLf5it1+ILsiK34Q6V0UY5a2
         KYHtg674rfLGDBJD1LwOn5jRCizduwbJyZeoTSWfWUABnXr5saWEDrOOrq/MS5wamzwO
         aoeVhgtnoYHUPgvlmuQ0uj2LT3c+etj8A4I6C8W4KcJXgXxgFbK5EdQWIwfSwcEOzqCP
         skYSOKvqiKb4GM5+pm2ZmHfhEYt/9hZC6ch6HQSWG3p5tJocQEzuXmsmTk093B1iEG0N
         YiTw==
X-Gm-Message-State: AGi0PuY/LKXVbemVkHIp+bHHt5II37Yhoy9d0YN351c2vWtvOsr3lGMR
        66ztml9lHk8s779+kA/LIZmsXaDkw2daFw==
X-Google-Smtp-Source: APiQypJ7iSyoLb4OfeEET68pkp5ItMoMPynZI9EqngYhJX3pJniJa9AjKMhYf3QGzdpsaK4Lp4U4pA==
X-Received: by 2002:adf:ff8b:: with SMTP id j11mr5215654wrr.117.1585854689602;
        Thu, 02 Apr 2020 12:11:29 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:28 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 03/14] arm64: Fix size of __early_cpu_boot_status
Date:   Thu,  2 Apr 2020 20:12:09 +0100
Message-Id: <20200402191220.787381-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun KS <arunks@codeaurora.org>

[ Upstream commit 61cf61d81e326163ce1557ceccfca76e11d0e57c ]

__early_cpu_boot_status is of type long. Use quad
assembler directive to allocate proper size.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Arun KS <arunks@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm64/kernel/head.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 06058fba5f86c..d22ab8d9edc95 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -667,7 +667,7 @@ ENTRY(__boot_cpu_mode)
  * with MMU turned off.
  */
 ENTRY(__early_cpu_boot_status)
-	.long 	0
+	.quad 	0
 
 	.popsection
 
-- 
2.25.1

