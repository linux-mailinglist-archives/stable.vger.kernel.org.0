Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43F75080E8
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 08:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359478AbiDTGTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 02:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352763AbiDTGTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 02:19:06 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AC8393ED;
        Tue, 19 Apr 2022 23:16:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bx5so998939pjb.3;
        Tue, 19 Apr 2022 23:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2dxv6RubXnlfeYakjpCeec9ZN/h5ACRQKP6ziPSuma8=;
        b=mfgT9TDjWycX6jagA/wAxWk1CAjj0aRkoTY2GTgubsCHWMPRBXCang1Aeh6p/I7w1a
         D8JpH+9FLclpmBzPOVqAa5WIxeuQDJnptbKAnpUb10iAyUPovc1mCCh+RTX0sXarI7ea
         Q903WV8NeYuX7uLnY2QfXia77F/27inTI65yMb8IaVmuvnFUXOrjh4dAHtH0+2AjJ719
         hDJNcopvXsITOm004vk/l2D/Re2KkN2XPIXfLIZfaUdpHNKjQp2+KOj1wrow+Br/QwZN
         0fxl3TbiddD3Z2pfikWzFaTEWVkFNhP5gdqTjgUqyMbCJ3PQQ2A/KNLZ5B5WxqK8pyGN
         5tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2dxv6RubXnlfeYakjpCeec9ZN/h5ACRQKP6ziPSuma8=;
        b=Yy9m/8XpymsdfrMgfdh9RylN+GziHCXq1EtlxXN17CJgm7fb29kamjA/MLnHQeeC/u
         etmPpRqlCrTCO8Ke6khOfFDtBTzm0mwZdnzRIkfsJfq5QBt9OfWLS4Je2iLS962UJQNA
         QnqGQcXQBA/NZe1LIvOpWCljx2XA8HxogXOxLm5AaPJwlQdTdnTVEEXwSyUoA+enNin2
         IploOyWLzBQLeYb4F/xg8JNRPzXLnXJ91/zWRoPij4LWQ1AblRS4zYwgs/AjbK9DrSq/
         oyhXuTemHwvsIOQBxm5qARiJvKorQA0zUaI3gzGXvuWwkpD4P2MCZ73Ly1Oh8Gp/f0B1
         nM8A==
X-Gm-Message-State: AOAM531+m2bnCrTRzsjvhHe8UEj8AUpCrUjn1tTzq/UfSifwK/4haO44
        akocnTxhxiEahGB186UlhYA=
X-Google-Smtp-Source: ABdhPJzG+wVAFIuExUHG6CpD9iDe9gZtDe1vAMHP4GPC1VJolBlAaA+c1igU59Mkkq+e7NFhq0xrPg==
X-Received: by 2002:a17:902:b941:b0:14d:af72:3f23 with SMTP id h1-20020a170902b94100b0014daf723f23mr19596035pls.6.1650435381733;
        Tue, 19 Apr 2022 23:16:21 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:daec:60d:88f6:798a])
        by smtp.gmail.com with ESMTPSA id k22-20020aa790d6000000b0050a765d5d48sm9798778pfk.160.2022.04.19.23.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 23:16:20 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        Chris Zankel <chris@zankel.net>,
        Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>, Max Filippov <jcmvbkbc@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/3] xtensa: patch_text: Fixup last cpu should be master
Date:   Tue, 19 Apr 2022 23:16:09 -0700
Message-Id: <20220420061611.4103443-2-jcmvbkbc@gmail.com>
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

From: Guo Ren <guoren@linux.alibaba.com>

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Fixes: 64711f9a47d4 ("xtensa: implement jump_label support")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
Message-Id: <20220407073323.743224-4-guoren@kernel.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/jump_label.c b/arch/xtensa/kernel/jump_label.c
index 0dde21e0d3de..ad1841cecdfb 100644
--- a/arch/xtensa/kernel/jump_label.c
+++ b/arch/xtensa/kernel/jump_label.c
@@ -40,7 +40,7 @@ static int patch_text_stop_machine(void *data)
 {
 	struct patch *patch = data;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		local_patch_text(patch->addr, patch->data, patch->sz);
 		atomic_inc(&patch->cpu_count);
 	} else {
-- 
2.30.2

