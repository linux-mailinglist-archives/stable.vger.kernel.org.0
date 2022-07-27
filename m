Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14622582DD0
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiG0RDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiG0RDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:03:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF8F6D574;
        Wed, 27 Jul 2022 09:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19C4F601D6;
        Wed, 27 Jul 2022 16:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241D2C433D6;
        Wed, 27 Jul 2022 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939914;
        bh=vTlGGWAnLSpNTe7twsSarNTbWCHfWyWaJ4QfxcvQ92Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTX68yfT+6v4bcYaeMlgk4IYFgHRwPel/d9HtsVsNmqouIB++X5jHorIBkUQ+Gnr6
         U4KY5bT9lkNSn6xaXQe4isl2XdC5+fAK5g0mjstFAfTc4YEiRJktefTPYxad9ZhaAi
         dYNmPFaz6gBe9zKbsF+OVYrOTyUBgNBbPu5Xkq5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "sidhartha.kumar@oracle.com, stable@vger.kernel.org, Oleksandr
        Tymoshenko" <ovt@google.com>, Oleksandr Tymoshenko <ovt@google.com>
Subject: [PATCH 5.15 009/201] Revert "selftest/vm: verify mmap addr in mremap_test"
Date:   Wed, 27 Jul 2022 18:08:33 +0200
Message-Id: <20220727161027.337601368@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Tymoshenko <ovt@google.com>

This reverts commit e8b9989597daac896b3400b7005f24bf15233d9a.

The upstream commit 9c85a9bae267 ("selftest/vm: verify mmap addr in
mremap_test") was backported as commit a17404fcbfd0 ("selftest/vm:
verify mmap addr in mremap_test"). Repeated backport introduced the
duplicate of function get_mmap_min_addr to the file breakign the vm
selftest build.

Fixes: e8b9989597da ("selftest/vm: verify mmap addr in mremap_test")
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/mremap_test.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -66,35 +66,6 @@ enum {
 	.expect_failure = should_fail				\
 }
 
-/* Returns mmap_min_addr sysctl tunable from procfs */
-static unsigned long long get_mmap_min_addr(void)
-{
-	FILE *fp;
-	int n_matched;
-	static unsigned long long addr;
-
-	if (addr)
-		return addr;
-
-	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
-	if (fp == NULL) {
-		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		exit(KSFT_SKIP);
-	}
-
-	n_matched = fscanf(fp, "%llu", &addr);
-	if (n_matched != 1) {
-		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		fclose(fp);
-		exit(KSFT_SKIP);
-	}
-
-	fclose(fp);
-	return addr;
-}
-
 /*
  * Returns false if the requested remap region overlaps with an
  * existing mapping (e.g text, stack) else returns true.


