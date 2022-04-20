Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E045080EE
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 08:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359487AbiDTGTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 02:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359484AbiDTGTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 02:19:09 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C1D393DB;
        Tue, 19 Apr 2022 23:16:25 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j17so1015633pfi.9;
        Tue, 19 Apr 2022 23:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8XEJp2R4K25ZYHNS7d51S7Y7FdMSq6LIaDwY2H8Jjr4=;
        b=CqEHDfVth2SZNnvBCwXpvmd6rbXdFGJqBERrT7dtwrUFgTDo60j6hyDZTbDmB1ADXE
         a3UnFt63E9yNhfqXq5GYE8L7zZzDLX8BJ7EB+A1lW/VMA7R9lMhZgK7EM3mas6+HQ5pg
         vJmJdR1D0/LRDvYUKOpbX3HX9r1olMPhF+AC2h1lA4XcpI/fL838JEPWQhDTbFoH3Vuf
         m/yON1qaFowxbhCmM5aaotBekQxCgbq8jF86jjPZRQF+huuovksEjFMphWhp5NRsPaEA
         AEeFLDjgb0NKAPTqfw9qWz1Npa0SC7sLR07id7TnwYZ+dDzhbCANwxW4PTInmk3O8/fy
         XiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8XEJp2R4K25ZYHNS7d51S7Y7FdMSq6LIaDwY2H8Jjr4=;
        b=dkQg2cQ6rx8ike+hzdgUEmo00U1nLNk1ktRGSQ/NZgaV2ncaFTn2Hik+4TXK/NxY7v
         wsY+a6ECVEBZEU/sRMhwxDtixHyNKBHKoUkDCu0xBwPGe8uB/rCYfl40M8/LGptgRp5F
         KB8I9CDNDzA7/HAoulFsuH4HtBA0RulVpgH7svbK4/X/ffMuPWhcTZ2LOWb9dcmi4EiM
         DIrCkpufHu5HPJXG9eGJAg+mCaPdT8DFYu4RoXEqVvNGp7LvODr5JQQC94XeGTBcIURk
         X3WiePIA2sJCqBSC8QzuM7GqdfRuz0Gytwe4c5lMI3owlYykKNv1hq8DwBBeFia4QqVY
         USyw==
X-Gm-Message-State: AOAM530JORLMHUipN9D3R+8QcK6NjdXoUQxu5JXkcvRxjS2KtoQcMSnp
        RUB36e9rjSYSgHMByLF9dqRaPXJ+BEjolw==
X-Google-Smtp-Source: ABdhPJx6BmH11OdCkrvs7y7Wlz4oKOOhwV/WA8UZNjUBwJd+BMtI++dJBOS0FIsBOU4yEeWcL8YoFg==
X-Received: by 2002:a05:6a00:16c7:b0:4f7:e497:69b8 with SMTP id l7-20020a056a0016c700b004f7e49769b8mr21618014pfc.6.1650435384472;
        Tue, 19 Apr 2022 23:16:24 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:daec:60d:88f6:798a])
        by smtp.gmail.com with ESMTPSA id k22-20020aa790d6000000b0050a765d5d48sm9798778pfk.160.2022.04.19.23.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 23:16:23 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] xtensa: fix a7 clobbering in coprocessor context load/store
Date:   Tue, 19 Apr 2022 23:16:11 -0700
Message-Id: <20220420061611.4103443-4-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420061611.4103443-1-jcmvbkbc@gmail.com>
References: <20220420061611.4103443-1-jcmvbkbc@gmail.com>
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

