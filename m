Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7CB6C569F
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjCVUHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjCVUHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:07:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEF374DE3;
        Wed, 22 Mar 2023 13:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC76622CB;
        Wed, 22 Mar 2023 20:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36937C4339B;
        Wed, 22 Mar 2023 20:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515278;
        bh=jiBHGv/Qc37ebIMDLVhnDSbtaYWP9xZ76vBBWTmM94I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlySb8iSp9kTPfEH5LJUjaLliP3T4Cioayc5256OBdRgH8x+kqJ1EP3CGPBlV/4DK
         NXQ8T5AfRh8i/fgG7fbXN1Fgi2OfjYZnVL+A+gFSypPiETOQNnwBZcozjL1oi5Hrmy
         YuAlQvBBjqRnhyhm7q5c7WVsS7/j6Mlo8EsXax98Ss8rG2rn3jKMZw1a849MT3sPsB
         jdA8n8dDuSDBvu6vTb+Z38VP2+wvpoxZgMjhHvq6tqnmAQ6vU5qoZsY2gUMejwQGYg
         TFR55GgHg5I1+m8IJg/7NXLQKAw9YRbVDQLWZ117H4pSGsYrDfaxt+tv/UUt2Vg9ja
         MkrKgclV9KUTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antti Laakso <antti.laakso@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, lenb@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 33/34] tools/power turbostat: fix decoding of HWP_STATUS
Date:   Wed, 22 Mar 2023 15:59:25 -0400
Message-Id: <20230322195926.1996699-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antti Laakso <antti.laakso@intel.com>

[ Upstream commit 92c25393586ac799b9b7d9e50434f3c44a7622c4 ]

The "excursion to minimum" information is in bit2
in HWP_STATUS MSR. Fix the bitmask used for
decoding the register.

Signed-off-by: Antti Laakso <antti.laakso@intel.com>
Reviewed-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index c24054e3ef7ad..c61c6c704fbe6 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4426,7 +4426,7 @@ int print_hwp(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 
 	fprintf(outf, "cpu%d: MSR_HWP_STATUS: 0x%08llx "
 		"(%sGuaranteed_Perf_Change, %sExcursion_Min)\n",
-		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x2) ? "" : "No-");
+		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x4) ? "" : "No-");
 
 	return 0;
 }
-- 
2.39.2

