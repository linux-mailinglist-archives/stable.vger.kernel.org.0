Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7624219C98F
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389300AbgDBTNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54923 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388499AbgDBTNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id c81so4619312wmd.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yViPn8Fbz3RmNQjEqtPLmElTrNVmdZ3e4vYeMjUnLFM=;
        b=G6md6BCq9I2ZYFqnxb8LDJTMKijQXQ72QMTFmXtniM4l8+q8tJCmWFZMLLAZhm2oQJ
         lUXyK4hxExJNFKUEQoYBMmoNSXTkh2DR7hTuiXpyhb1UR88A63N8MVxgq5wbeX1hKfNp
         2qpe+2MOgbpVKnhsUpKuYmsMGWnn8CcuHwKSxfFRODfXCp7lZDKSqCXMDItz5s5olZEg
         V6OWr2ZMuotInabACHJcSlOxTnv0bpkyXCXw3AVcSzoZk4/PppyYq5kt9r10jPPLZYjl
         Wnw8a3Le5i0oP/EJFE+UoXJt3TRdrZcfUQYfyrvAHqQq49AinLxaNJ/7OPti7UEmt8iK
         Ze2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yViPn8Fbz3RmNQjEqtPLmElTrNVmdZ3e4vYeMjUnLFM=;
        b=qI4AePdAhcoq+0ixp5lfMjG0ISOMOoKEN9uaF+5pzrj2nMuguE7FZ30qkGlHZQbP45
         mASrJG/3ujD+FYLhKZRMM+2kk9rbok3CNdJh3SrRHwZjnYhtwMv8m+2WhTVEa6AdxXRo
         ayH7lLZbsg9QCYnwwjPE36LaAl+4Gm7kH3suWcq3eg9NgTFlFKOhCwY6VVvhIlDpvSCy
         qq6eHUopKFk5/NfO86w7yAZTB5hQj3Q1k/Bdx7DvKIBKA09gI5wzBR8ZrJwrtvsOANo/
         BBDlB+qQ5aWvL8Wf7IZaDpaXHKoX1AeRyuGGLWi13HWMF4vhR98f/ed+LpLST1SzxZJE
         hYcg==
X-Gm-Message-State: AGi0PuYaynJ6wPdcYAT+WZxAX5oRZdK3ZEYuCs76vRsLsuvy+dmPQpeD
        msdx9uI0huvL5j+VJzzgpvdrbK0PMlcPTQ==
X-Google-Smtp-Source: APiQypLDHE3Ei76zp52wiu9P2s+MWDlWy/OiJ/Pr43Q4eF24Uexo1XBWf9Vi6z2tZEiYZRTadmtV/g==
X-Received: by 2002:a1c:6505:: with SMTP id z5mr628889wmb.28.1585854787430;
        Thu, 02 Apr 2020 12:13:07 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 08/33] arm64: perf: remove unsupported events for Cortex-A73
Date:   Thu,  2 Apr 2020 20:13:28 +0100
Message-Id: <20200402191353.787836-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu YiPing <xuyiping@hisilicon.com>

[ Upstream commit f8ada189550984ee21f27be736042b74a7da1d68 ]

bus access read/write events are not supported in A73, based on the
Cortex-A73 TRM r0p2, section 11.9 Events (pages 11-457 to 11-460).

Fixes: 5561b6c5e981 "arm64: perf: add support for Cortex-A73"
Acked-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Xu YiPing <xuyiping@hisilicon.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm64/kernel/perf_event.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 05fdae70e9f6e..53df84b2a07f4 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -262,12 +262,6 @@ static const unsigned armv8_a73_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 
 	[C(L1D)][C(OP_READ)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_L1D_CACHE_RD,
 	[C(L1D)][C(OP_WRITE)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WR,
-
-	[C(NODE)][C(OP_READ)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD,
-	[C(NODE)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR,
-
-	[C(NODE)][C(OP_READ)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD,
-	[C(NODE)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR,
 };
 
 static const unsigned armv8_thunder_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
-- 
2.25.1

