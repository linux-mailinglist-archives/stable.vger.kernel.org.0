Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042BB5219AB
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiEJNue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244997AbiEJNrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BA0366BF;
        Tue, 10 May 2022 06:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1249CE1EED;
        Tue, 10 May 2022 13:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFCAC385A6;
        Tue, 10 May 2022 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189595;
        bh=VYx/Qn1xfl7ARAKdkKF03gmmvh4hIEeI/UBBC2WRzgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uvj67X8ds7cZz88YjXPmXtUJIRCNMJJVlS+kqS1/u5G99jwkwF9yS2Vlx63X5m0B5
         mUPaeJ+RjIKfiRb84G2dfF0fS9AdIVeJFG6cVGMzxmcvljoBWwYWv82dHGPfTUXIYT
         W/zuOoiEVZyUWqMb6NWCZNRjPjRiAoEZ8c/4AsPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/135] selftest/vm: verify remap destination address in mremap_test
Date:   Tue, 10 May 2022 15:08:03 +0200
Message-Id: <20220510130743.305503241@linuxfoundation.org>
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

[ Upstream commit 18d609daa546c919fd36b62a7b510c18de4b4af8 ]

Because mremap does not have a MAP_FIXED_NOREPLACE flag, it can destroy
existing mappings.  This causes a segfault when regions such as text are
remapped and the permissions are changed.

Verify the requested mremap destination address does not overlap any
existing mappings by using mmap's MAP_FIXED_NOREPLACE flag.  Keep
incrementing the destination address until a valid mapping is found or
fail the current test once the max address is reached.

Link: https://lkml.kernel.org/r/20220420215721.4868-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/mremap_test.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index efcbf537b3d5..8f4dbbd60c09 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -66,6 +66,30 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/*
+ * Returns false if the requested remap region overlaps with an
+ * existing mapping (e.g text, stack) else returns true.
+ */
+static bool is_remap_region_valid(void *addr, unsigned long long size)
+{
+	void *remap_addr = NULL;
+	bool ret = true;
+
+	/* Use MAP_FIXED_NOREPLACE flag to ensure region is not mapped */
+	remap_addr = mmap(addr, size, PROT_READ | PROT_WRITE,
+					 MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					 -1, 0);
+
+	if (remap_addr == MAP_FAILED) {
+		if (errno == EEXIST)
+			ret = false;
+	} else {
+		munmap(remap_addr, size);
+	}
+
+	return ret;
+}
+
 /* Returns mmap_min_addr sysctl tunable from procfs */
 static unsigned long long get_mmap_min_addr(void)
 {
-- 
2.35.1



