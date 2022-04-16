Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1465850332D
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 07:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiDPCHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 22:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiDPCGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 22:06:09 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD54E17;
        Fri, 15 Apr 2022 19:00:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q12so9258914pgj.13;
        Fri, 15 Apr 2022 19:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8XEJp2R4K25ZYHNS7d51S7Y7FdMSq6LIaDwY2H8Jjr4=;
        b=kQsKyrkT1DWICrd0ptnoiBSDY/8mwSomsBEmcNT+vOSVEupMSVa7wDQ1ZaII+k1i0h
         gm0IbwRP6+tleoe51hK5sIbdaPDAvC6YyKupthbkj5YlKMp7iLJEREukF38JQEVPtmgb
         C7LBkXRLChz/Lo40XLkQVfN/GPl7gjcg+tqcnhe0PNVNjcJTViHuHG1iqkTaL8LY/JNZ
         LOlnRzh+lrxGvmYBtLiA5YbebU0JlWjJjiVqaI1Fax6atGQ6v5FmA/0xqUzOpbyU/oYG
         royS+qDvPJc0ctoWHF4tpf+bBkuVUh4d197rd+TrfLvMug16FupxYFIgCH3cQHx3+O/R
         ulJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8XEJp2R4K25ZYHNS7d51S7Y7FdMSq6LIaDwY2H8Jjr4=;
        b=m8olP9Z1sSkblglZMrxi9rF4/y7hxozHpE15stoiJyBGZpZgjV6WgXnRAauopnTPiq
         sELcnO6nSNUc2xv670dw5I9DlwoP+RiFRLzACcAddBRgy2+632XHIiY9ILkQ+w2+WLFY
         u065JcG9Z+Tt8AOwfhE14FGAeNW39BK51FzvqSRnha7ypAE1gTsn6ld0nq/NgLcnXcZP
         YRyLIuzdX3cD1QVzcWTfNnLUWePEb+t3Uvn0y2alf+W3dOoiKIqJh8PetyHvuMHnKbU8
         4htlwKLdzCfL022ZFJFET4L2A+VfFaOiqldkyq/H+bBFcwYj8JZpy82LHHRsDxkmUWa5
         tT9A==
X-Gm-Message-State: AOAM533qVpxTEN0zBtdz6BI+CQ5OM+TnwwV8+zYTJotzYRSTTt3+TmvV
        Axu5jntQbwU2gepH5PsQWs1DO5NcjWc=
X-Google-Smtp-Source: ABdhPJx+ex28/CxkmPcqU/qGwXQmffQRsGXU8jOdNzZxx9XrSJz0QB9hKwR+mpiU5ton0cWn7TdfxQ==
X-Received: by 2002:a17:903:11cc:b0:151:71e4:dadc with SMTP id q12-20020a17090311cc00b0015171e4dadcmr1428533plh.78.1650073831037;
        Fri, 15 Apr 2022 18:50:31 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:9b6:6aad:72f6:6e16])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm4325957pfl.15.2022.04.15.18.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 18:50:30 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: fix a7 clobbering in coprocessor context load/store
Date:   Fri, 15 Apr 2022 18:50:18 -0700
Message-Id: <20220416015018.2025282-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fast coprocessor exception handler saves a3..a6, but coprocessor context
load/store code uses a4..a7 as temporaries, potentially clobbering a7.
'Potentially' because coprocessor state load/store macros may not use
all four temporary registers (and neither FPU nor HiFi macros do).
Use a3..a6 as intended.

Cc: stable@vger.kernel.org
Fixes: c658eac628aa ("[XTENSA] Add support for configurable registers and coprocessors")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/coprocessor.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/kernel/coprocessor.S b/arch/xtensa/kernel/coprocessor.S
index 45cc0ae0af6f..c7b9f12896f2 100644
--- a/arch/xtensa/kernel/coprocessor.S
+++ b/arch/xtensa/kernel/coprocessor.S
@@ -29,7 +29,7 @@
 	.if XTENSA_HAVE_COPROCESSOR(x);					\
 		.align 4;						\
 	.Lsave_cp_regs_cp##x:						\
-		xchal_cp##x##_store a2 a4 a5 a6 a7;			\
+		xchal_cp##x##_store a2 a3 a4 a5 a6;			\
 		jx	a0;						\
 	.endif
 
@@ -46,7 +46,7 @@
 	.if XTENSA_HAVE_COPROCESSOR(x);					\
 		.align 4;						\
 	.Lload_cp_regs_cp##x:						\
-		xchal_cp##x##_load a2 a4 a5 a6 a7;			\
+		xchal_cp##x##_load a2 a3 a4 a5 a6;			\
 		jx	a0;						\
 	.endif
 
-- 
2.30.2

