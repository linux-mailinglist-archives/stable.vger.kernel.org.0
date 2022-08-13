Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9249C591EAC
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 08:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiHNGea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 02:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiHNGe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 02:34:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A89D1E3D0;
        Sat, 13 Aug 2022 23:34:28 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l64so4178999pge.0;
        Sat, 13 Aug 2022 23:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ZIGUpjz3ydr9wZccRyAZfjSeyvseH0rGb11Z9zlxCPk=;
        b=EK9f7yUuOxyzjG2ig0IAIFZU1cibkmegzRqwoEOF9nC6kawQYW3LFGQfsHJTM6TKGI
         /Ws/vQH1lY/r1/PbYWE8tBUP4A0VeY2mTSyaNubgiewEYmlHLsnKn0AoczPLCfi6aFxL
         c1OT6G/S0EH/glUmyygtUvFG792AkCJ/qo8CvTDgO98X+JzjetGP3i0Hs5Tv/jFQ21Sd
         Ob342u6rmAIPhNbsj2xSTUrd76HG1c2NRLrQOP/FcDjWdNLb4vuqsZJ9tNHG2P11Am9o
         D9F4r7sQ20Hr3msJJXpGNnTdT7D3RVVwQPWMYmQqfFbgeqpjF5MO0Of0KuXCOimCaLgv
         7lLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ZIGUpjz3ydr9wZccRyAZfjSeyvseH0rGb11Z9zlxCPk=;
        b=i3ZIfbzVzd5sIiVzm62aJDjedYg1kCgqDOhE7sv3a+BalXspr+IGQExcXYBeocvb56
         J/aapQIyQHazpfqPrb+g/EuPh+iZLxs/vu8GLj3TcxI25rjF/+GkZPuGS7L3t+tSvif7
         P8Qrjy44sSjb+JENFUgtu7Yf9zYAvHoqLKu5z1QykZrmC+8Q9bfMybdmnmAesGBb87e3
         eQOy7/VPq7omb2DQX5WI54kAwvZQ06Hqewv92wa5frs7eoULbrBIS3LI5AiOj5mAK/0g
         oypptar9B0ti5FqaBzCaKJOQcSjBeAsOEBYJNbuIvpdpDpB0SROpMmVZD/G3TGuGS876
         Fxpg==
X-Gm-Message-State: ACgBeo0mb9niR8KZo7wtl+5Qs0k286SstxQsYAoQLHMf/lg8z0PVQhXD
        WqpB6CMdizAaXs2NdCaspuw=
X-Google-Smtp-Source: AA6agR4tmE6gakpcUpzgpRNZ8pfIYCk9TogG33bRWPy3i/kOWZHWco2bxzTRWqXUFi67+5LPZUFsgg==
X-Received: by 2002:a05:6a00:15c7:b0:52e:5a5d:27fa with SMTP id o7-20020a056a0015c700b0052e5a5d27famr10981276pfu.52.1660458868155;
        Sat, 13 Aug 2022 23:34:28 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id j15-20020a170902da8f00b0016f04c098ddsm4754320plx.226.2022.08.13.23.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 23:34:27 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] x86/kprobes: fix JNG/JNLE emulation
Date:   Sat, 13 Aug 2022 15:59:43 -0700
Message-Id: <20220813225943.143767-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

When kprobes emulates JNG/JNLE instructions on x86 it uses the wrong
condition. For JNG (opcode: 0F 8E), according to Intel SDM, the jump is
performed if (ZF == 1 or SF != OF). However the kernel emulation
currently uses 'and' instead of 'or'.

As a result, setting a kprobe on JNG/JNLE might cause the kernel to
behave incorrectly whenever the kprobe is hit.

Fix by changing the 'and' to 'or'.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arch/x86/kernel/kprobes/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 74167dc5f55e..4c3c27b6aea3 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -505,7 +505,7 @@ static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
 		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
 			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
 		if (p->ainsn.jcc.type >= 0xe)
-			match = match && (regs->flags & X86_EFLAGS_ZF);
+			match = match || (regs->flags & X86_EFLAGS_ZF);
 	}
 	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
 }
-- 
2.25.1

