Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DEC6C56DD
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjCVUKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjCVUJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:09:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D90C15D;
        Wed, 22 Mar 2023 13:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF52622C5;
        Wed, 22 Mar 2023 20:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B284CC433A4;
        Wed, 22 Mar 2023 20:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515324;
        bh=d2kJloD1m/EvDPqToiYYJTD3x8xotyhjKibguqq2vME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LATwYJ2jLYJF5W8/sA+9KyUvPHUI6cFoCDm0ojwPFJ5QlDCWaIBTz/68juhZRsg5C
         Ej0xrIEbAi/5yV+Ugn96FoCqgGRAYMC66WwsPyWWy8+DOBkt7VoWE/ix1HyUVW98Dl
         koaMAD4VG9qwJqHDjTLd5LYxi64tpTfG5tHeolfavYWSIcMiLdyZtnwf+S79P1Q/de
         2yHn83orTGJIXQAcifWeQpyaW6fr/CJ1SILctn48Ylw3gLz1Vii5lT2slDm5cWootG
         ZOOhtWgPmS0ElttoIgbew6WTBZcFdRoqBL8fxbVJ8aV+k9/eh2ikpbY04SSqfs4K5y
         K+lUEeAJPT4Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antti Laakso <antti.laakso@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, lenb@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/16] tools/power turbostat: fix decoding of HWP_STATUS
Date:   Wed, 22 Mar 2023 16:01:19 -0400
Message-Id: <20230322200121.1997157-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200121.1997157-1-sashal@kernel.org>
References: <20230322200121.1997157-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 84b8a35c91972..a3197efe52c63 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4241,7 +4241,7 @@ int print_hwp(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 
 	fprintf(outf, "cpu%d: MSR_HWP_STATUS: 0x%08llx "
 		"(%sGuaranteed_Perf_Change, %sExcursion_Min)\n",
-		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x2) ? "" : "No-");
+		cpu, msr, ((msr) & 0x1) ? "" : "No-", ((msr) & 0x4) ? "" : "No-");
 
 	return 0;
 }
-- 
2.39.2

