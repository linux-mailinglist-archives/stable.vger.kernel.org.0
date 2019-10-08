Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD07CFDD7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfJHPkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:20 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:43217 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfJHPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:20 -0400
Received: by mail-wr1-f53.google.com with SMTP id j18so19167774wrq.10
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v1fBkRqeoTupUy6r5T5rATOuRaKZb5JdrMIl3ut6gZ4=;
        b=xU2wdODr8d5X7dO32U+0Xy2v/2R1Jt2O3m/Ge4vhJfa4x+17e27cA0zf/njfbrm6DA
         JjgXqRWl82p3KQkz0fs8X2l/WOemYKT2Ch5LYgRcdCfKR43sdLoW6+3UQbeIcNEHpqhC
         NW2xqnvDkQ6PTjnf8gGVi8cOEKDochDeWTSYiBY8G6z9ZVbjOkJHVc1T42ahU/WDhNO2
         vlro6LEEauaVgYwsCGPzsk+1n4J3pdMyjsT42qfLl9lzDIAyeLqS35qi2RGgioVpTpML
         k1l5zi52Jj63exxuxIK2XHoL02cQyQGNCQadFGokMyyqV/zAs/LT/Vum0rZLtNXlQDI7
         Vbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v1fBkRqeoTupUy6r5T5rATOuRaKZb5JdrMIl3ut6gZ4=;
        b=iMtYPjYunF+lWwZjv1jbStHW6G7vN5XJ01XOuIzTfR+u5Jy1vuKD8DZgCIxpfl+MIT
         Qa/6Nc15o1t+b6M3jEPDEIxt50q8uuxnSaRkgYmiTvVbaORK2sjmhhP+VONsjL4DLzkh
         Hm6UbPq19neT4nvN6LOGFx814RKcdMAo1gvI6GVXURP/vxwQzR/b83e33cjPYwAzLAXT
         t3M4l8+rTyhc9kBTlPqgWotXnOOKyUMtjR3p1eg8289Sc2ZTXAXZfj2/5mLNJr1FRRE0
         RMLyZDVXTuSYfZwIEuEV/fT8L6luUx9YYsez9u/vMzTIF6uvivP0EQ2UIoQMN4f/2sEn
         YaOQ==
X-Gm-Message-State: APjAAAVW68a/LGynDxcqic7YOX8XcY7UDmDzNMNUh5by3+Cvi/dU/Xeb
        AM7foIInCOGpUxeJFBLDtUPbag==
X-Google-Smtp-Source: APXvYqyywOaE3CjTPedvbAFrXAEhFioEYVtqA9mttFRLJwPQ/CPg+yGIKHdfigNxBVx/+6Z1fEQPCQ==
X-Received: by 2002:adf:f2c4:: with SMTP id d4mr7855414wrp.108.1570549218180;
        Tue, 08 Oct 2019 08:40:18 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:17 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 08/16] arm64: enable generic CPU vulnerabilites support
Date:   Tue,  8 Oct 2019 17:39:22 +0200
Message-Id: <20191008153930.15386-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit 61ae1321f06c4489c724c803e9b8363dea576da3 ]

Enable CPU vulnerabilty show functions for spectre_v1, spectre_v2,
meltdown and store-bypass.

Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e3ebece79617..51fe21f5d078 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -84,6 +84,7 @@ config ARM64
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_CPU_AUTOPROBE
+	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IRQ_MULTI_HANDLER
-- 
2.20.1

