Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7EB521B19
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242814AbiEJOIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343751AbiEJOHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8311F63B1;
        Tue, 10 May 2022 06:41:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B0961937;
        Tue, 10 May 2022 13:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCB4C385C9;
        Tue, 10 May 2022 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190074;
        bh=g9pNUFd+Po/y6lsMmMGBAgpvwsInn4kXThXwqDSMj9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eb0fJ5eiAmGokXWf/PUS9yYj/qkvc6keF8z4ktI5zXBxmOVEsDJCjMQuy8HymgblG
         ab4j+PqwH+IzXPABD6KyxZGUsn5aLZ+AKAToiBmEuP7Ra2pFzYU4mSZcvpRguGiLwi
         6npyBnBCAKAGssmUiC7lPun3b/n5DVybd2vwdh7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 119/140] selftest/vm: verify mmap addr in mremap_test
Date:   Tue, 10 May 2022 15:08:29 +0200
Message-Id: <20220510130745.005993511@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
index 58775dab3cc6..380a4593dbd6 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -65,6 +65,35 @@ enum {
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



