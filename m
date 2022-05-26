Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AD8534D06
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 12:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347001AbiEZKL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 06:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346978AbiEZKL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 06:11:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8B921AB
        for <stable@vger.kernel.org>; Thu, 26 May 2022 03:11:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso1369608pjg.0
        for <stable@vger.kernel.org>; Thu, 26 May 2022 03:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wbBG7lEDJH2LFVXucK5oQ/R2hCfil/fSiH5Kza4Gi8k=;
        b=V5XR0cYmYpPHz45TXlrQdMJrLi9mC6lsy2W+x/KJ31gATxWb3Jcl0MrAB+D24bI7f3
         4cWVas5pCyylxxCZLBWe4mQfSoke/VDU2WYlrymgElTYZAOaG723fCyOoELiQShkPJOT
         1JZwGsy0Lp23kfxFyXK4dhbP3HKfGwYOKkJB0bxLkU+akzyGUbizbF/W22JUzStz/kvb
         /YZE17RoALpfuH1WSU7xai3fAWdlXw2P6hUoIe1PwT4W09BwfsX4JWi9svdHWlFZSnTi
         XZgvOErgNi8zbTcAf6Ej1LPhdSLC9CuCpS7dDMCmuN5koT27cwVrnYTiCV3TrhPaZwT8
         /aOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wbBG7lEDJH2LFVXucK5oQ/R2hCfil/fSiH5Kza4Gi8k=;
        b=xle5URKYU3WeUWymTupS6Ose+lZ873eRK3Kzzgk9nrWAC8brVwQCWERqJxXJ9LjBtc
         FazXdn6eX9Amr3eGUqWaeZCxtJGSw79HMcJ9oOsbJIALlwfpw207CdCDlHNWtTTjhBRF
         4n8u9AhK8Lp4wooZvTF0Exa4VKgctTk8FBPn2+evXd52JXwloHjbERAz1hA3EAnPEQFG
         4J3gYeqrA89LndLmQkfIQnQuBQt4GTAHf4IhuQSLuJweTOmCXPf5P+G3saoHbbUM8Nph
         5MNEKN7E2Fk4WHvPufg3bddb4Iq4xozjLOsrjTjb5phgHTTU+QCvWekCu/AFZYqPlFpb
         +R2g==
X-Gm-Message-State: AOAM533tijKJTC1xGxaPrzSAUtyp4C/URjTZ9mWpD1Slo/d5PBMTUFJ0
        htB5oko0p1RO/+jUtCpafNVo7Q==
X-Google-Smtp-Source: ABdhPJwr+qQVKMcopGMW+cRM74SlJB+kkVtaSsSNVzIL44tSlSNiDBT302sF2fUP6vTOWuit+8GjCQ==
X-Received: by 2002:a17:902:d50e:b0:163:80b4:30a3 with SMTP id b14-20020a170902d50e00b0016380b430a3mr937520plg.159.1653559907098;
        Thu, 26 May 2022 03:11:47 -0700 (PDT)
Received: from kerodipc.Dlink ([49.206.9.238])
        by smtp.gmail.com with ESMTPSA id z17-20020a170902d55100b0015f309f14d0sm1114861plf.56.2022.05.26.03.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 03:11:46 -0700 (PDT)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Atish Patra <atishp@rivosinc.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <apatel@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Sunil V L <sunil.vl@gmail.com>,
        Sunil V L <sunilvl@ventanamicro.com>, stable@vger.kernel.org
Subject: [PATCH V2 2/5] riscv: spinwait: Fix hartid variable type
Date:   Thu, 26 May 2022 15:41:28 +0530
Message-Id: <20220526101131.2340729-3-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220526101131.2340729-1-sunilvl@ventanamicro.com>
References: <20220526101131.2340729-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The hartid variable is of type int but compared with
ULONG_MAX(INVALID_HARTID). This issue is fixed by changing
the hartid variable type to unsigned long.

Fixes: c78f94f35cf6 ("RISC-V: Use __cpu_up_stack/task_pointer only for spinwait method")
Cc: stable@vger.kernel.org

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
---
 arch/riscv/kernel/cpu_ops_spinwait.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c b/arch/riscv/kernel/cpu_ops_spinwait.c
index 346847f6c41c..3ade9152a3c7 100644
--- a/arch/riscv/kernel/cpu_ops_spinwait.c
+++ b/arch/riscv/kernel/cpu_ops_spinwait.c
@@ -18,7 +18,7 @@ void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
 static void cpu_update_secondary_bootdata(unsigned int cpuid,
 				   struct task_struct *tidle)
 {
-	int hartid = cpuid_to_hartid_map(cpuid);
+	unsigned long hartid = cpuid_to_hartid_map(cpuid);
 
 	/*
 	 * The hartid must be less than NR_CPUS to avoid out-of-bound access
@@ -27,7 +27,7 @@ static void cpu_update_secondary_bootdata(unsigned int cpuid,
 	 * spinwait booting is not the recommended approach for any platforms
 	 * booting Linux in S-mode and can be disabled in the future.
 	 */
-	if (hartid == INVALID_HARTID || hartid >= NR_CPUS)
+	if (hartid == INVALID_HARTID || hartid >= (unsigned long) NR_CPUS)
 		return;
 
 	/* Make sure tidle is updated */
-- 
2.25.1

