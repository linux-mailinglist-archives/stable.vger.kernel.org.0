Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB994FD4C0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352430AbiDLH2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351592AbiDLHMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C721F289A6;
        Mon, 11 Apr 2022 23:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62DB16146F;
        Tue, 12 Apr 2022 06:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46337C385A1;
        Tue, 12 Apr 2022 06:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746218;
        bh=3vYq7p0SM307ePNfx447hxRa5B05AMi0intXuJ+LFrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBjpShzNhTfAkNfVrRK4Hwa8UPjj6KUnYW8CZRTS9oG6K8dgIJBgcBwZAMXRCXnMe
         RgzmhL1r31v1UM2YG1PWWEQJQx6xAf9klmDzWKY+LhzaWUYD+KbVIOsmLtPINdJHnP
         pz67Vh3upn1Bw5yb51sfdEXsTKtQtWzIb/0nbJos=
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
Subject: [PATCH 5.15 203/277] perf: arm-spe: Fix perf report --mem-mode
Date:   Tue, 12 Apr 2022 08:30:06 +0200
Message-Id: <20220412062947.914959037@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
index a4420d4df503..7d589a705fc8 100644
--- a/tools/perf/arch/arm64/util/arm-spe.c
+++ b/tools/perf/arch/arm64/util/arm-spe.c
@@ -154,6 +154,12 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
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



