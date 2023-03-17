Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790456BF698
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 00:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCQXl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 19:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCQXl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 19:41:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0146B3C7BE;
        Fri, 17 Mar 2023 16:41:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so2410159pjl.4;
        Fri, 17 Mar 2023 16:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679096498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9h8q/I2sD6IvFiDI6TF78QYtvbfIGdc+Oun0JMTRP38=;
        b=pq9Bxlhk1+IeE8xXIpSDkScQMW/qxfsDA7Dgtuy3Cm5vw+w7CKvrTi1/wFguq2FCQ8
         kMQp+aRxDm3RFMTo4ET47/K7KAlqGTwlcR97mDVFaTGzBLQw7nrVZdohyPpvyxM43L88
         LwH2ZsLj47vi5vol7cGlVYGQ/uSc/HxMC5SzKAgv03FgPtZQNA2mt9eMCkL1wrofZduq
         etL5K3yGstdQp+W0dQ6wk/CbYQZHmwsBMJPqY769Q2OZnasKKK3R5HO5DpDszdhCq0L1
         QGUj/t8IzLxMojwpEBFAmI3kV4mSHL5ljIph6OvzjydNudkPH/COzuriZXdFXUV/8SNw
         bKMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679096498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9h8q/I2sD6IvFiDI6TF78QYtvbfIGdc+Oun0JMTRP38=;
        b=WBswT4ZsEetkfu1dOr4AbK/a4N3PXgqsRMYeu9HFSmmW6f7exiv253Q2arVRAs9gpq
         SPnysLno13Z0ULHKfTPkO7cVJg9177IiIDZuJHAX8sMiFuOaATKU1RA6Qos+U38qUV1w
         DGz+/al1DNowFH2pJSd3ejTfCp8r4DX+YklvMXJMLMD5C0f+Y8UnTfIwxy1Zw0EK7pME
         aE8tqDlMkhWxBkqOdHjeOQQgGMmcckdNVfKwfUWiBOxOMPKjOWgi9DSlZxWCPXs6XY2e
         JsLOBb8JiubXN1yOxm/4u9RE9BdTrAuP4UhO6Q7AUEWcCe38Ht9bqwshHKAPRVXtpi+/
         zXTg==
X-Gm-Message-State: AO0yUKWOadVcV+7UttXSu3GogN8GSjkL+VMChPJYcnqSuU09ZM4IfRjH
        UTGRsn2BiZz1fFv0ofMg5jgRk8SAWog=
X-Google-Smtp-Source: AK7set8YUkBnKgmmm03CKldw33fmzNVi6ZtNLNnouiFMVFFMa79c1LbeiXGVVAqXjhjBnanm5/sxYg==
X-Received: by 2002:a17:903:2850:b0:19a:7f4b:3ef6 with SMTP id kq16-20020a170903285000b0019a7f4b3ef6mr7491787plb.3.1679096498224;
        Fri, 17 Mar 2023 16:41:38 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:3222:a57e:6612:daf3])
        by smtp.gmail.com with ESMTPSA id k2-20020a170902e90200b0019c919bccf8sm2078951pld.86.2023.03.17.16.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 16:41:37 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] xtensa: fix KASAN report for show_stack
Date:   Fri, 17 Mar 2023 16:41:32 -0700
Message-Id: <20230317234132.2426441-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

show_stack dumps raw stack contents which may trigger an unnecessary
KASAN report. Fix it by copying stack contents to a temporary buffer
with __memcpy and then printing that buffer instead of passing stack
pointer directly to the print_hex_dump.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/traps.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index cd98366a9b23..f0a7d1c2641e 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -539,7 +539,7 @@ static size_t kstack_depth_to_print = CONFIG_PRINT_STACK_DEPTH;
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
-	size_t len;
+	size_t len, off = 0;
 
 	if (!sp)
 		sp = stack_pointer(task);
@@ -548,9 +548,17 @@ void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 		  kstack_depth_to_print * STACK_DUMP_ENTRY_SIZE);
 
 	printk("%sStack:\n", loglvl);
-	print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
-		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
-		       sp, len, false);
+	while (off < len) {
+		u8 line[STACK_DUMP_LINE_SIZE];
+		size_t line_len = len - off > STACK_DUMP_LINE_SIZE ?
+			STACK_DUMP_LINE_SIZE : len - off;
+
+		__memcpy(line, (u8 *)sp + off, line_len);
+		print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
+			       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
+			       line, line_len, false);
+		off += STACK_DUMP_LINE_SIZE;
+	}
 	show_trace(task, sp, loglvl);
 }
 
-- 
2.30.2

