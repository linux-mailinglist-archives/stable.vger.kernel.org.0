Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD30582DD2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbiG0RDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiG0RDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:03:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3606D572;
        Wed, 27 Jul 2022 09:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595BA601CE;
        Wed, 27 Jul 2022 16:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D5AC433D6;
        Wed, 27 Jul 2022 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939911;
        bh=+kCkmqrmQ+ezg/La72IVCkAR8CRuOOBy4ZA/yaCOHtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TD49W+aqMwWTUmQvgk18oduiuVI0WnBY90Y2k4fehujqGHGN03xTC59+lBtyD/V5j
         vxg4A7LCaQGTbUJIkTatO41BlEbxYBK0s8sMjDgEi/dA4AF9cgOrAY49jREAhgyGwa
         28WGMDiqVBqaCB3WxcI8nQSr1guEv/U3pTaI/sx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "sidhartha.kumar@oracle.com, stable@vger.kernel.org, Oleksandr
        Tymoshenko" <ovt@google.com>, Oleksandr Tymoshenko <ovt@google.com>
Subject: [PATCH 5.15 008/201] Revert "selftest/vm: verify remap destination address in mremap_test"
Date:   Wed, 27 Jul 2022 18:08:32 +0200
Message-Id: <20220727161027.294082875@linuxfoundation.org>
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

This reverts commit 0b4e16093e081a3ab08b0d6cedf79b249f41b248.

The upstream commit 18d609daa546 ("selftest/vm: verify remap destination
address in mremap_test") was backported as commit 2688d967ec65
("selftest/vm: verify remap destination address in mremap_test").
Repeated backport introduced the duplicate of function
is_remap_region_valid to the file breakign the vm selftest build.

Fixes: 0b4e16093e08 ("selftest/vm: verify remap destination address in mremap_test")
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/mremap_test.c |   24 ------------------------
 1 file changed, 24 deletions(-)

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


