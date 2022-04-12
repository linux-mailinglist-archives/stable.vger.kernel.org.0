Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615B14FD094
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiDLGsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241616AbiDLGpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:45:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FB13B3ED;
        Mon, 11 Apr 2022 23:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B7B96190F;
        Tue, 12 Apr 2022 06:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312E6C385A6;
        Tue, 12 Apr 2022 06:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745538;
        bh=F+acL3xa1EfkY2fawv6oA63W8PIk67kvrjKFqX9XmFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3jyCSIP0KrCjaronRYhFpUQj7SofD1BdfmqC5DtwJvxEf7Kv9Mdfduem8RPBbTbA
         MAjv4stkHA6ilAfVmH5gWHd/z8DbeWbvFc3oNgSwCYkdaa1pN5yCtK9zbAfOIGsn47
         w+iKKaxThAHzxZCVRdzfXVEu6pRW26WMKWNi9iI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        German Gomez <german.gomez@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        John Garry <john.garry@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/171] perf: arm-spe: Fix perf report --mem-mode
Date:   Tue, 12 Apr 2022 08:30:22 +0200
Message-Id: <20220412062931.675777785@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: James Clark <james.clark@arm.com>

[ Upstream commit ffab487052054162b3b6c9c6005777ec6cfcea05 ]

Since commit bb30acae4c4dacfa ("perf report: Bail out --mem-mode if mem
info is not available") "perf mem report" and "perf report --mem-mode"
don't allow opening the file unless one of the events has
PERF_SAMPLE_DATA_SRC set.

SPE doesn't have this set even though synthetic memory data is generated
after it is decoded. Fix this issue by setting DATA_SRC on SPE events.
This has no effect on the data collected because the SPE driver doesn't
do anything with that flag and doesn't generate samples.

Fixes: bb30acae4c4dacfa ("perf report: Bail out --mem-mode if mem info is not available")
Signed-off-by: James Clark <james.clark@arm.com>
Tested-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220408144056.1955535-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm64/util/arm-spe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/arch/arm64/util/arm-spe.c b/tools/perf/arch/arm64/util/arm-spe.c
index e3593063b3d1..37765e2bd9dd 100644
--- a/tools/perf/arch/arm64/util/arm-spe.c
+++ b/tools/perf/arch/arm64/util/arm-spe.c
@@ -124,6 +124,12 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
 	evsel__set_sample_bit(arm_spe_evsel, TIME);
 	evsel__set_sample_bit(arm_spe_evsel, TID);
 
+	/*
+	 * Set this only so that perf report knows that SPE generates memory info. It has no effect
+	 * on the opening of the event or the SPE data produced.
+	 */
+	evsel__set_sample_bit(arm_spe_evsel, DATA_SRC);
+
 	/* Add dummy event to keep tracking */
 	err = parse_events(evlist, "dummy:u", NULL);
 	if (err)
-- 
2.35.1



