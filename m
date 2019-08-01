Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C987D75E
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfHAIVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:38 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36419 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730803AbfHAIVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so31881265plt.3
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vRfP6jZwD5k91GsO2EtwWgU9vmyZBDy37/lZXGzi3aU=;
        b=uCU3Z3Dd1P1FIooMb8g3/Yirwuf5gsToAiV9JYhukWAquCpOpLJOBCMoG93ZDCjBIJ
         btZaaTRhQMPYjtnilwUJTPxmpmuOa4OSnVouxkTRriItjzbs/k59piXQ+dz0rue37I54
         jWgdNzREAD+kvsjZ7QRuA9AOa7zA0MSwjYD1mwFv3fmmirUdTHnq5OC9tDAS3419s9pd
         +ifs9FqauXsMYjmTt38hWLWb1QTU5UJ0UTt6fYxxN/QGNDipHnlelXreXhCWDUMaVJVU
         1I9iNOsaPNQUDjeRv12Z4tcolTbd3/T/jvKxcOy1d/3XVOBwmdPAitFxF3bblCPruDBv
         yYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vRfP6jZwD5k91GsO2EtwWgU9vmyZBDy37/lZXGzi3aU=;
        b=qIU9QUjNx4ABgSHbYL8v0xz79+x2OvvirK1087rWaN72wrg/UQOUYxMKzJO2kjtqzk
         eSpXkbV4z1XwrENULhDHvUW1v7HHexI2mfbE3uoPQixQ0N5mcamJeuNUUXSxbs+85bop
         4TbtmhlQ5UOxhGE0vo43rCStURO8K+ZJrwubcTtFrfrv2OWZXL1L5J45KKH+FRRMs/73
         SUwrfWDqBI/0LQ7WqFcT9bD0svSeHnzJhAs7LkbNHgWKq/n3tpYhqIDFQ6haqcX8qdDB
         rUlr9jgwlQKD2n7lgQrnw4jTbMIpcz7VQ6ahrXLjgnwACIHYTKFOZTM8O6ZpI15ZdyRg
         btEA==
X-Gm-Message-State: APjAAAWLAvG+hn5uOpGMxaPPEWVlx7GDEtH3mIszkjxy5Ji3u/XKn/N2
        ZWiSEthNuLDCU5DUYIQueWLdkmfyvaM=
X-Google-Smtp-Source: APXvYqy3bdFxraBtYPacUshSMabHdK1w+qknRAhTGD8v1pvTWLe1HAEYxa1g5Dfr6tEWO/e9NGOV3A==
X-Received: by 2002:a17:902:4b:: with SMTP id 69mr123879677pla.89.1564647696697;
        Thu, 01 Aug 2019 01:21:36 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id y194sm47248614pfg.116.2019.08.01.01.21.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:36 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 47/47] ARM: fix the cockup in the previous patch
Date:   Thu,  1 Aug 2019 13:46:31 +0530
Message-Id: <455094dcf249c379282166ebbb866fee091d8c9f.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit d6951f582cc50ba0ad22ef46b599740966599b14 upstream.

The intention in the previous patch was to only place the processor
tables in the .rodata section if big.Little was being built and we
wanted the branch target hardening, but instead (due to the way it
was tested) it ended up always placing the tables into the .rodata
section.

Although harmless, let's correct this anyway.

Fixes: 3a4d0c2172bc ("ARM: ensure that processor vtables is not lost after boot")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/proc-macros.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index d36a283b4099..e6bfdcc381f8 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -263,7 +263,7 @@
  * If we are building for big.Little with branch predictor hardening,
  * we need the processor function tables to remain available after boot.
  */
-#if 1 // defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+#if defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
 	.section ".rodata"
 #endif
 	.type	\name\()_processor_functions, #object
@@ -301,7 +301,7 @@ ENTRY(\name\()_processor_functions)
 	.endif
 
 	.size	\name\()_processor_functions, . - \name\()_processor_functions
-#if 1 // defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+#if defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
 	.previous
 #endif
 .endm
-- 
2.21.0.rc0.269.g1a574e7a288b

