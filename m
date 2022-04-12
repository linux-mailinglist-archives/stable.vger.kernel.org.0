Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944594FD533
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353206AbiDLH66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358729AbiDLHmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBCC53E0D;
        Tue, 12 Apr 2022 00:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 103C3B81B4F;
        Tue, 12 Apr 2022 07:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4021EC385A1;
        Tue, 12 Apr 2022 07:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747937;
        bh=48IJ3esSaUzBji8rEvxkx01bcGDqcGgwVzYB+0ZPDAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dg7GivnYSgf1nx4h3tRubJfXC0G2Pqq1FozZe8EFOIHKL/QSGEJ3izl0Lv79h2BzX
         MhDLQ+WLbByFmXnIdGQ1Gj78bryoPdMX6w78rbbOW3tWcO5wrGN4cnGE8Z5oxNuokX
         19zuO42QT+a1NkSGkbYYX4NfNW15BVm6VSBK7lbY=
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
Subject: [PATCH 5.17 260/343] perf: arm-spe: Fix perf report --mem-mode
Date:   Tue, 12 Apr 2022 08:31:18 +0200
Message-Id: <20220412062958.830168914@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index 2100d46ccf5e..bb4ab99afa7f 100644
--- a/tools/perf/arch/arm64/util/arm-spe.c
+++ b/tools/perf/arch/arm64/util/arm-spe.c
@@ -239,6 +239,12 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
 		arm_spe_set_timestamp(itr, arm_spe_evsel);
 	}
 
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



