Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A3A5E7102
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 02:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiIWA7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 20:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiIWA7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 20:59:34 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966A921BD
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 17:59:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 9so10879356pfz.12
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 17:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=zUURCqFsPJ0++1UISwKVFigZFjRPyYFwg3WX49XZqB0=;
        b=fm+3chTmqI62okWG0kjgJIfWMf5N0zHMQ5ViiaK0O3QpRW1tfmCkPQdYvX1265kzMF
         4wG1JJFpAx6xkb/kl5ViWHvCXt80CcJBcOPRwA02jgctV554ZhijstpICZU0yycnCw8A
         bz1iym1Owjvo4okvjhR5qSfw0bd+24Ljukg2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=zUURCqFsPJ0++1UISwKVFigZFjRPyYFwg3WX49XZqB0=;
        b=zZ7GOnQwprDF2Nk5iBEDVnEFv3GNFViXKWQuN2nSNJOJwxRhpxDt0OLgi7jbYup0vx
         +gHLmRPkWm5iLTzmagbeiHBdssxa03wu+bNOyYfKcCsClCbN3uPxhNhNZ+8JxrnqwTmX
         j8mKPmEmLzt2XZYHdUyDQ3sMmp5pS1yMo/5I1BhpQpVEKQZ16H6g/ALl80hCLCwHodC5
         PvBVjvDV7WvQcjAPMk//OXQvsqoh/jhQOHr7KyWtbatv9b/C8NT4CJJd+qp1zREdhtCv
         wsBGywrti1wjTKJxv6vzIZgU2km7/UoeQ9wGum6Wv7PoHZoEP/48IkGlz86ecZwjAiq+
         a5tQ==
X-Gm-Message-State: ACrzQf07PAysepDvD4i2SBQqG96dIEJI7YZmg9tQPVDBcDJ/p7DvMDDd
        xsRKGPjO1pbD/wJC/+DuY6RkRA==
X-Google-Smtp-Source: AMsMyM5MooqD6aywJFynn+PaY22Xz0manESWBePduvhYSPk3ktw+blBKFMUWBvtXxWlfzex13+22/Q==
X-Received: by 2002:a63:1554:0:b0:43b:f03d:8651 with SMTP id 20-20020a631554000000b0043bf03d8651mr5269327pgv.422.1663894771119;
        Thu, 22 Sep 2022 17:59:31 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:626:f1d5:7c9d:6576])
        by smtp.gmail.com with UTF8SMTPSA id e16-20020a056a0000d000b0053b208b55d1sm5066933pfj.85.2022.09.22.17.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 17:59:30 -0700 (PDT)
From:   Daniel Verkamp <dverkamp@chromium.org>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Daniel Verkamp <dverkamp@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] x86: also disable FSRM if ERMS is disabled
Date:   Thu, 22 Sep 2022 17:58:27 -0700
Message-Id: <20220923005827.1533380-1-dverkamp@chromium.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the "Fast Short REP MOVSB" path of memmove, if we take the path where
the FSRM flag is enabled but the ERMS flag is not, there is no longer a
check for length >= 0x20 (both alternatives will be replaced with NOPs).
If a memmove() requiring a forward copy of less than 0x20 bytes happens
in this case, the `sub $0x20, %rdx` will cause the length to roll around
to a huge value and the copy will eventually hit a page fault.

This is not intended to happen, as the comment above the alternatives
mentions "FSRM implies ERMS".

However, there is a check in early_init_intel() that can disable ERMS,
so we should also be disabling FSRM in this path to maintain correctness
of the memmove() optimization.

Cc: stable@vger.kernel.org
Fixes: f444a5ff95dc ("x86/cpufeatures: Add support for fast short REP; MOVSB")
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
---
 arch/x86/kernel/cpu/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2d7ea5480ec3..71b412f820c7 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -328,6 +328,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 			pr_info("Disabled fast string operations\n");
 			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
 			setup_clear_cpu_cap(X86_FEATURE_ERMS);
+			setup_clear_cpu_cap(X86_FEATURE_FSRM);
 		}
 	}
 
-- 
2.37.3.998.g577e59143f-goog

