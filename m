Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E45F593C1B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344368AbiHOTkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343957AbiHOTiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:38:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F36031DC4;
        Mon, 15 Aug 2022 11:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D383611DB;
        Mon, 15 Aug 2022 18:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A48FC433C1;
        Mon, 15 Aug 2022 18:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589189;
        bh=6He/nieo34FbAoePLRcPRcoYRJZGQDmNooBT9RKLjkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvUpYPVKjemBDeYkrXCZ3T1uEnx1+CPE0cK9rJpnpu+f22sm3q3mgJ0qIkcq7vR4r
         x7JUWK0Qdih6lR5T8tfabyjpm38sN1lFUpBMtMe250goGMgV0oJUmQaFW+bw5BVgiE
         eolfAxp/8gzC5eJA4H0zLdxiFugMG0b7bMFd3PuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 641/779] s390/smp: cleanup target CPU callback starting
Date:   Mon, 15 Aug 2022 20:04:45 +0200
Message-Id: <20220815180404.755545770@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit dc2ab23b992c9d5dab93b9bf01b10b10465e537e ]

Macro mem_assign_absolute() is used to initialize a target
CPU lowcore callback parameters. But despite the macro name
it writes to the absolute lowcore only if the target CPU is
offline. In case the CPU is online the macro does implicitly
write to the normal memory.

That behaviour is correct, but extremely subtle. Sacrifice
few program bits in favour of clarity and distinguish between
online vs offline CPUs and normal vs absolute lowcore pointer.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/smp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index e57eb2260b90..982b72ca677c 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -328,10 +328,17 @@ static void pcpu_delegate(struct pcpu *pcpu,
 	/* Stop target cpu (if func returns this stops the current cpu). */
 	pcpu_sigp_retry(pcpu, SIGP_STOP, 0);
 	/* Restart func on the target cpu and stop the current cpu. */
-	mem_assign_absolute(lc->restart_stack, stack);
-	mem_assign_absolute(lc->restart_fn, (unsigned long) func);
-	mem_assign_absolute(lc->restart_data, (unsigned long) data);
-	mem_assign_absolute(lc->restart_source, source_cpu);
+	if (lc) {
+		lc->restart_stack = stack;
+		lc->restart_fn = (unsigned long)func;
+		lc->restart_data = (unsigned long)data;
+		lc->restart_source = source_cpu;
+	} else {
+		mem_assign_absolute(lc->restart_stack, stack);
+		mem_assign_absolute(lc->restart_fn, (unsigned long)func);
+		mem_assign_absolute(lc->restart_data, (unsigned long)data);
+		mem_assign_absolute(lc->restart_source, source_cpu);
+	}
 	__bpon();
 	asm volatile(
 		"0:	sigp	0,%0,%2	# sigp restart to target cpu\n"
-- 
2.35.1



