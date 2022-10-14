Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13F45FEF6B
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJNN6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiJNN52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:57:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6092945F58;
        Fri, 14 Oct 2022 06:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74BD161B4E;
        Fri, 14 Oct 2022 13:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D91C433D6;
        Fri, 14 Oct 2022 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755672;
        bh=L8JkAShHK1tslhN7a3wdPGT9UdCrJ2TNiWURcqWGhpQ=;
        h=From:To:Cc:Subject:Date:From;
        b=i80PeZFAqhB6/Zr3m2JuP8G61pn93cud3QX3Mazw5jU9YFusqNPhHUvDaY3ndJhsT
         oXEy1sO45lWiG4+SBN6bo/1EdFLbtM8KlaUWktHIoUZgeHfgG5Us54uOa3jAxxacyi
         IGzkZj931RM0x2RxnVCpiCJmnK5/r+8aXyC1Ay/3nNAAm0ZTvdqdWWbpb1hGE100HT
         qzwYg2tO68SmD186YmeJtD2ZQBFeWml307YYrHVtmIkNCSlwMBUDeGkbH3hmamfIvk
         4SIPqa4i/pEr1b+LKnxIIGo8WCC5q4JyzFzDzglT1vZzr9fEvTbZWcaxXKSAJdDbow
         QgUNliJcTDr0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/5] powerpc/selftests: Use timersub() for gettimeofday()
Date:   Fri, 14 Oct 2022 09:54:24 -0400
Message-Id: <20221014135430.2110067-1-sashal@kernel.org>
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

