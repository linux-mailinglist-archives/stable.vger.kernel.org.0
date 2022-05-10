Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E273952199E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244370AbiEJNt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244977AbiEJNrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ACD2380E9;
        Tue, 10 May 2022 06:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA9226188A;
        Tue, 10 May 2022 13:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0610C385C2;
        Tue, 10 May 2022 13:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189589;
        bh=RrY/267cCvZ+Zw6/oIJgYru9TUR3Qifk5FHKotJx9AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQP7gr2VxCVOLZdYNXvinIbdhuL7E5XUAekHoUtc1PPBZKMqT5NhFF5fhQinCgBDB
         PVijrBIO4NZbk9f8P3EhM+AdrZepMK/ynbP8JMDdFgkqYDSlc2bzfpt6y+ZFq0elzG
         MxHgG3y2IQaAiOs5eD4q8pT55sPoau2Ce21HOIow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/135] selftest/vm: verify mmap addr in mremap_test
Date:   Tue, 10 May 2022 15:08:02 +0200
Message-Id: <20220510130743.277550432@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit 9c85a9bae267f6b5e5e374d0d023bbbe9db096d3 ]

Avoid calling mmap with requested addresses that are less than the
system's mmap_min_addr.  When run as root, mmap returns EACCES when
trying to map addresses < mmap_min_addr.  This is not one of the error
codes for the condition to retry the mmap in the test.

Rather than arbitrarily retrying on EACCES, don't attempt an mmap until
addr > vm.mmap_min_addr.

Add a munmap call after an alignment check as the mappings are retained
after the retry and can reach the vm.max_map_count sysctl.

Link: https://lkml.kernel.org/r/20220420215721.4868-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/mremap_test.c | 29 ++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index e3ce33a9954e..efcbf537b3d5 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -66,6 +66,35 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/* Returns mmap_min_addr sysctl tunable from procfs */
+static unsigned long long get_mmap_min_addr(void)
+{
+	FILE *fp;
+	int n_matched;
+	static unsigned long long addr;
+
+	if (addr)
+		return addr;
+
+	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
+	if (fp == NULL) {
+		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		exit(KSFT_SKIP);
+	}
+
+	n_matched = fscanf(fp, "%llu", &addr);
+	if (n_matched != 1) {
+		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		fclose(fp);
+		exit(KSFT_SKIP);
+	}
+
+	fclose(fp);
+	return addr;
+}
+
 /*
  * Returns false if the requested remap region overlaps with an
  * existing mapping (e.g text, stack) else returns true.
-- 
2.35.1



