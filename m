Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79147548CEE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354573AbiFMLdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355249AbiFMLa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:30:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997C941F80;
        Mon, 13 Jun 2022 03:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 457A9B80D3B;
        Mon, 13 Jun 2022 10:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716DEC3411C;
        Mon, 13 Jun 2022 10:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117216;
        bh=hcNVpNBGg8Koejpa/anU9b11/KPcDjzDRqKFTWJ2jRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6/7UKc3vTwyNFJ36b4owAAYrlDkGSZJK/aN0EF7OdPHM0aIa2y5lF0KVN3+PaFRz
         LYH5mmui5DaCJObUBTaxHO7LiXX0QXCFW/UCa/PrUpURWXPEEubIJMJCbgmZpRICiV
         sPjEctgLI1yPKHAKWqaUeFz40tN81tH5YdOXcuUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Joe Mario <jmario@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 336/411] perf c2c: Fix sorting in percent_rmt_hitm_cmp()
Date:   Mon, 13 Jun 2022 12:10:09 +0200
Message-Id: <20220613094938.794349093@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit b24192a17337abbf3f44aaa75e15df14a2d0016e ]

The function percent_rmt_hitm_cmp() wrongly uses local HITMs for
sorting remote HITMs.

Since this function is to sort cache lines for remote HITMs, this patch
changes to use 'rmt_hitm' field for correct sorting.

Fixes: 9cb3500afc0980c5 ("perf c2c report: Add hitm/store percent related sort keys")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Joe Mario <jmario@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220530084253.750190-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index d3e0ea06d78d..29d460c30176 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -953,8 +953,8 @@ percent_rmt_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
 	double per_left;
 	double per_right;
 
-	per_left  = PERCENT(left, lcl_hitm);
-	per_right = PERCENT(right, lcl_hitm);
+	per_left  = PERCENT(left, rmt_hitm);
+	per_right = PERCENT(right, rmt_hitm);
 
 	return per_left - per_right;
 }
-- 
2.35.1



