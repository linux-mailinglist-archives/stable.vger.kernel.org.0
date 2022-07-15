Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9396576A82
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 01:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiGOXQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 19:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiGOXQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 19:16:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1DD90DAB
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 16:16:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31cbe6ad44fso50313617b3.10
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 16:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g0XoXi75JFkDSc5LJU74KD8RUMjLW6aoMjU9k/GNp4o=;
        b=fhZSntKUtnryQu8alwiyIG4KiiEIR414SUUPvQ9jOTTod4XWDysqZKIpx+f8wOantn
         CBj5+bhYcFDHc1QzYseEEluzK0aAktkGeQuLHdfRz6t88Nx/eSuus6V21IKxORYwlCWe
         EgEj82A7Ravah6b3MPMYM6kQXSs2PlRINh+K3Zbyzp9C9Gdvf5Lks95qkbI1X1FtSZ5h
         030ctEAPsaBgKDJaEZpDTtc/gKewuS1d5u0MlrbGtR0cavlbFK7ZzsEmUwVS3A7DN1mG
         Bcs1ZcLJAzvGm2RxTDFG0bAYcmhne2v7nZWWugT8gXDrJDWbYTzAwNBgXZ+NU0+Bjd34
         XvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g0XoXi75JFkDSc5LJU74KD8RUMjLW6aoMjU9k/GNp4o=;
        b=09gxXrsYLl7XrR2GeluaoxbNbR/RnAo887ZKHBv2uObHU8+gO6WYwZSRx45qLnrbbD
         VrKZ1ayf69+u8KRwqObQzWICWY1q4GpDpZAiltEa/s2jrmCbRjReGk35voOlU/JO59zG
         xZ3Fkwp+yHg0P/oisfzBcEbfFiPBlvd/dMJPzd3jmvD0TenfK2C0KGed8FvNYA6jRh9F
         hihtmXp/2s9IYhFnLXenbbZnWSRf+Pp+DkMblXjyxqL5sllbS/d5qgrq1w3FyfX93Y81
         dinuCK1xm3D9iIY70PXian+MnjanFL9cC7o/xGYrgme5gWbfm6+UeHmkDCB7D0YA3TTe
         KrcQ==
X-Gm-Message-State: AJIora+uMranJHf22HZxwiC43KCd0wqF0Xt1JC5UHqhmVeG3IrO5jbSl
        uzjSE/mPqLIpQaXuYpMXkhMIjvI=
X-Google-Smtp-Source: AGRyM1uF9UfWQ59Z/De26ioThIPIrtkbm8GOUHHNY7LXUJSNfdg3AoIUAgR37ZX8QsXJNoYuDeWQ/wo=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a05:6902:1366:b0:66e:38d6:74d with SMTP id
 bt6-20020a056902136600b0066e38d6074dmr17267303ybb.217.1657926978211; Fri, 15
 Jul 2022 16:16:18 -0700 (PDT)
Date:   Fri, 15 Jul 2022 23:15:41 +0000
In-Reply-To: <20220715231542.2169650-1-ovt@google.com>
Message-Id: <20220715231542.2169650-2-ovt@google.com>
Mime-Version: 1.0
References: <20220715231542.2169650-1-ovt@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 1/2] Revert "selftest/vm: verify remap destination address in mremap_test"
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     gregkh@linuxfoundation.org
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org,
        Oleksandr Tymoshenko <ovt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 0b4e16093e081a3ab08b0d6cedf79b249f41b248.

The upstream commit 18d609daa546 ("selftest/vm: verify remap destination
address in mremap_test") was backported as commit 2688d967ec65
("selftest/vm: verify remap destination address in mremap_test").
Repeated backport introduced the duplicate of function
is_remap_region_valid to the file breakign the vm selftest build.

Fixes: 0b4e16093e08 ("selftest/vm: verify remap destination address in mremap_test")
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
---
 tools/testing/selftests/vm/mremap_test.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 8f4dbbd60c09..efcbf537b3d5 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -66,30 +66,6 @@ enum {
 	.expect_failure = should_fail				\
 }
 
-/*
- * Returns false if the requested remap region overlaps with an
- * existing mapping (e.g text, stack) else returns true.
- */
-static bool is_remap_region_valid(void *addr, unsigned long long size)
-{
-	void *remap_addr = NULL;
-	bool ret = true;
-
-	/* Use MAP_FIXED_NOREPLACE flag to ensure region is not mapped */
-	remap_addr = mmap(addr, size, PROT_READ | PROT_WRITE,
-					 MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
-					 -1, 0);
-
-	if (remap_addr == MAP_FAILED) {
-		if (errno == EEXIST)
-			ret = false;
-	} else {
-		munmap(remap_addr, size);
-	}
-
-	return ret;
-}
-
 /* Returns mmap_min_addr sysctl tunable from procfs */
 static unsigned long long get_mmap_min_addr(void)
 {
-- 
2.37.0.170.g444d1eabd0-goog

