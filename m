Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8005B4B1AB5
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346531AbiBKAvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 19:51:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbiBKAvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 19:51:22 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8895F86
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 16:51:20 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id o2so13613523lfd.1
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 16:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=US4EJyI61Chwwwjh7fTMLFf0K8eLU8HLJNw4j3h5APA=;
        b=FzIp0sPYDlh2ARdqWPqRObIpKCKhmRMqWrlDWmfa7ZtO4aijq98amCVqJ5QSWU9BWh
         dC1pf1GpIJaalULogZDQi7AW6ilGaxWvZj8FJIilfP385GYufGkm+yMkloEIv4oNjTIw
         bneWChfRGwR5FpEhDwJefTgopwjeg9XdJNrAkhjZFU1vHrEtPRvX+4DFtEc9S6NwrVyi
         4ujOuXJqO0/fNaWJhTqtDx3sTXJraT2DzOl9UaxVDF5zsSlXtzKJv7OWZHcuX/4rNFOO
         2mNROUZ1rN9iAkqaPcUBALcyK0ormI4G3Jb3Tq6gX3KMGiS3pz1bSwB4FkbrjZEoYSLU
         LR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=US4EJyI61Chwwwjh7fTMLFf0K8eLU8HLJNw4j3h5APA=;
        b=o7A2YLiHMOLKRsjQJEIgKQq+ijJkIP8pGU6sUafG8gD16IYLRUmaxtnreNsPP+plGv
         8ctrG15I0RCf+mSl1tiJwfnRVGYxVYHfOkczam/aFxeeNEN02m53HpjDCp7JtgJl0mO7
         A8JeOlB76wvc5bTClcC0ZQtpuYBJ/G/QLAZDqAAiGIB9NLjYQAo+gyrWhd+YcVdzFu6W
         m8kmOJ0+3h9aTtKCK3pSEpMbAHo55FBaCJFTOiM+X0GWOHFS4960eTZsL7Huitj8fPsW
         UxqzRT6uUsnIaU8ycAD0CAAyAsLLrxJ+b9a+kkGo71H4LTZs+6b5+wxglMIdJSKIGgAw
         Gj+A==
X-Gm-Message-State: AOAM533pptbz+FfSFtVEnUi0sU7av7onFQLiz5FlCYiPIfGuWACz6URQ
        Oi6EAgd0JF0bLfqyawESJ5rigFrTNl4now==
X-Google-Smtp-Source: ABdhPJxAZ7c6mrEQDtvfnjS/yAfpykqcD4PeognSn9ictkDAmdOvpGT/nlb5H4gDZ3y5MibeXkp5GA==
X-Received: by 2002:a05:6512:2821:: with SMTP id cf33mr6818251lfb.37.1644540678921;
        Thu, 10 Feb 2022 16:51:18 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id cf26sm2948725lfb.277.2022.02.10.16.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 16:51:18 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     mpe@ellerman.id.au
Cc:     christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv2] powerpc/lib/sstep: fix 'ptesync' build error
Date:   Fri, 11 Feb 2022 01:51:13 +0100
Message-Id: <20220211005113.1361436-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
2.37.90.20220207) the following build error shows up:

{standard input}: Assembler messages:
{standard input}:2088: Error: unrecognized opcode: `ptesync'
make[3]: *** [/builds/linux/scripts/Makefile.build:287: arch/powerpc/lib/sstep.o] Error 1

Add the 'ifdef CONFIG_PPC64' around the 'ptesync' in function
'emulate_update_regs()' to like it is in 'analyse_instr()'. Since it looks like
it got dropped inadvertently by commit 3cdfcbfd32b9 ("powerpc: Change
analyse_instr so it doesn't modify *regs").

Cc: stable@vger.kernel.org # v4.14+
Fixes: 3cdfcbfd32b9 ("powerpc: Change analyse_instr so it doesn't modify *regs")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/powerpc/lib/sstep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index a94b0cd0bdc5..bd3734d5be89 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -3264,12 +3264,14 @@ void emulate_update_regs(struct pt_regs *regs, struct instruction_op *op)
 		case BARRIER_EIEIO:
 			eieio();
 			break;
+#ifdef CONFIG_PPC64
 		case BARRIER_LWSYNC:
 			asm volatile("lwsync" : : : "memory");
 			break;
 		case BARRIER_PTESYNC:
 			asm volatile("ptesync" : : : "memory");
 			break;
+#endif
 		}
 		break;
 
-- 
2.34.1

