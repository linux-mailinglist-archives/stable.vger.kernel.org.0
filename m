Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58974B0DBB
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 13:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241475AbiBJMoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 07:44:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiBJMoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 07:44:08 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1894E25DF
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 04:44:09 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id o2so10243522lfd.1
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 04:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kYLyrvK0lBlYHTzi+wQsHNbyaWDy5kqoghsteHCo+O4=;
        b=kYbXENzl7JVQX8/fGz513ufsSQRYWQ+FSIXDK+hS0NMudgKgaXcRBcj9yBweMTtlME
         uvgpJf32AGx0ak8tqS6vEO+D8CDQQqzq4uwTCDBRoYpiHQQ080GOsA2KgAUONA7Wwki7
         LjGu2ZDP4aQSSN34Y0Hvr0ei8XlzsXK/5LSWIefrIvAv4ac2kgcMUtENs6bbqQM4IRQb
         8UECuUY1t2SLsVdmVZ4SMalKvQrf1iMdMEi//UuTmMddyz4KtLs4RI4R/Y0AP0eR5G9E
         lRsH5NJRFFe03BHuoU5u1NojOrT4UGluw1pNJH4e7b+sCZKS+ttXueJPsX1pHngDmxDp
         aNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kYLyrvK0lBlYHTzi+wQsHNbyaWDy5kqoghsteHCo+O4=;
        b=tpqlccnSF1fw73IYLZmLMjIn0gJlcM8hk+qGKFzfoAcP6W2J4dUyo6A9S23jHZK5dS
         TbTNwuqVgILW5SMXJK/pGetJLTvWBIy5LfBSwcS6ZKd964vWkO3LbnPrsqh1MsV2RUi8
         IfCcCdLTSzR3Y65QN2qctAsDuwBQfT+KnnrGEoKEmxbmhOH05CBiiNeowQtxKly77Tfo
         6lnDK5TIs0KfDKMFMiD4dbfZ8+8sAlHiMdA6LBjQaNJWye+ZPme2BmBfwYYRYQyJsbmJ
         Er2x8q+oLuq+VQPbxL6OJPqUalqnJuHfFzx5rDENSXWscg8WnbI+6RqUlx4lJ8L708Xv
         ddPw==
X-Gm-Message-State: AOAM5300eg2yalCBCJ+MMhqHqFUmWCG3qFEW7mkMVH751CKOKseWLvCN
        96ZpvGEZBYeLBA8gwDtZw15JyA==
X-Google-Smtp-Source: ABdhPJx96KjqtNknDEz2fAkwXtdH3zsGBS+a/kKIYgOnMOqGX9zLxiwKPQT9pL2LLLkUi27wjDlJVw==
X-Received: by 2002:ac2:4d34:: with SMTP id h20mr5152537lfk.52.1644497047417;
        Thu, 10 Feb 2022 04:44:07 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id z8sm2863676ljn.89.2022.02.10.04.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 04:44:07 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] powerpc/lib/sstep: fix 'ptesync' build error
Date:   Thu, 10 Feb 2022 13:44:04 +0100
Message-Id: <20220210124404.34773-1-anders.roxell@linaro.org>
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

Re-add the ifdef __powerpc64__ around the 'ptesync' in function
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
index a94b0cd0bdc5..d23772f91a36 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -3264,12 +3264,14 @@ void emulate_update_regs(struct pt_regs *regs, struct instruction_op *op)
 		case BARRIER_EIEIO:
 			eieio();
 			break;
+#ifdef __powerpc64__
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

