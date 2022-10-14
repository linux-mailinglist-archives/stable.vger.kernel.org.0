Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD47C5FEF87
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiJNOBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiJNOBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:01:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894D51C90B;
        Fri, 14 Oct 2022 07:00:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E30BBCE266F;
        Fri, 14 Oct 2022 13:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68084C433C1;
        Fri, 14 Oct 2022 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755705;
        bh=L8JkAShHK1tslhN7a3wdPGT9UdCrJ2TNiWURcqWGhpQ=;
        h=From:To:Cc:Subject:Date:From;
        b=A+ZmDU0D81M0xTs1g6cj6WIu0E4fgsyzz4UmhmfrQhStGpl43iB5ppBcaLFT8lZ9Y
         Tdp70JQa7EP77fM0RFXEbQ69QvNJl4kYILzRIZYY4znBwCzgGYU8/UAgmyvjHoECaX
         DPBbBgQfrI7KlLlrXDionAWdhf0oNChaWtPnZ+OgoERu6LLam/OTMeIcWiBP5X1dY3
         yDIpNegG4jX4GpwtTuj20ebZjdJ73LmSgf7TvouIx/fXjSY9bqwnhEt4AKGxJOVMju
         5BbLTO06ayF1w9vIV0LccTYqfQP07+HG4VUxzq8DMAmupqT1ElgApQPJYAKk5YHypX
         ZBnHvCOz/RQzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/3] powerpc/selftests: Use timersub() for gettimeofday()
Date:   Fri, 14 Oct 2022 09:54:58 -0400
Message-Id: <20221014135502.2110218-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

[ Upstream commit c814bf958926ff45a9c1e899bd001006ab6cfbae ]

Use timersub() function to simplify the code.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220816105106.82666-1-ye.xingchen@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/benchmarks/gettimeofday.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c b/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
index 3af3c21e8036..7f4bb84f1c9c 100644
--- a/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
+++ b/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
@@ -12,7 +12,7 @@ static int test_gettimeofday(void)
 {
 	int i;
 
-	struct timeval tv_start, tv_end;
+	struct timeval tv_start, tv_end, tv_diff;
 
 	gettimeofday(&tv_start, NULL);
 
@@ -20,7 +20,9 @@ static int test_gettimeofday(void)
 		gettimeofday(&tv_end, NULL);
 	}
 
-	printf("time = %.6f\n", tv_end.tv_sec - tv_start.tv_sec + (tv_end.tv_usec - tv_start.tv_usec) * 1e-6);
+	timersub(&tv_start, &tv_end, &tv_diff);
+
+	printf("time = %.6f\n", tv_diff.tv_sec + (tv_diff.tv_usec) * 1e-6);
 
 	return 0;
 }
-- 
2.35.1

