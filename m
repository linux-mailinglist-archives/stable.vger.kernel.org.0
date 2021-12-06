Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5876469E7C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348018AbhLFPjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378943AbhLFPgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAB8C08C5CD;
        Mon,  6 Dec 2021 07:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CC361309;
        Mon,  6 Dec 2021 15:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748D5C341C2;
        Mon,  6 Dec 2021 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804153;
        bh=G+uJ+8D7YKvOkP3fd64zmX16MEa7z/wGhYSj/H8TW74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtosvOPmGsCJQM6fGG6iBvevRSk4w4uH3UTcUPNIkA5Z1KdSQgK1bzQMya9R8hdkv
         TTE43Dp323nM4t6DQgOXeI4eSPpAEs8fsTMiUyH9GvEZ5eUsbtLR8VXHUKrLBplKAh
         lF+4SSjvg65Ecw3aFxeEFDdK8QRftOPrmy6z0AGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/207] perf inject: Fix ARM SPE handling
Date:   Mon,  6 Dec 2021 15:55:00 +0100
Message-Id: <20211206145611.823879006@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: German Gomez <german.gomez@arm.com>

[ Upstream commit 9e1a8d9f683260d50e0a14176d3f7c46a93b2700 ]

'perf inject' is currently not working for Arm SPE. When you try to run
'perf inject' and 'perf report' with a perf.data file that contains SPE
traces, the tool reports a "Bad address" error:

  # ./perf record -e arm_spe_0/ts_enable=1,store_filter=1,branch_filter=1,load_filter=1/ -a -- sleep 1
  # ./perf inject -i perf.data -o perf.inject.data --itrace
  # ./perf report -i perf.inject.data --stdio

  0x42c00 [0x8]: failed to process type: 9 [Bad address]
  Error:
  failed to process sample

As far as I know, the issue was first spotted in [1], but 'perf inject'
was not yet injecting the samples. This patch does something similar to
what cs_etm does for injecting the samples [2], but for SPE.

[1] https://patchwork.kernel.org/project/linux-arm-kernel/cover/20210412091006.468557-1-leo.yan@linaro.org/#24117339
[2] https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/perf/util/cs-etm.c?h=perf/core&id=133fe2e617e48ca0948983329f43877064ffda3e#n1196

Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: German Gomez <german.gomez@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20211105104130.28186-2-german.gomez@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 58b7069c5a5f8..7054f23150e1b 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -51,6 +51,7 @@ struct arm_spe {
 	u8				timeless_decoding;
 	u8				data_queued;
 
+	u64				sample_type;
 	u8				sample_flc;
 	u8				sample_llc;
 	u8				sample_tlb;
@@ -248,6 +249,12 @@ static void arm_spe_prep_sample(struct arm_spe *spe,
 	event->sample.header.size = sizeof(struct perf_event_header);
 }
 
+static int arm_spe__inject_event(union perf_event *event, struct perf_sample *sample, u64 type)
+{
+	event->header.size = perf_event__sample_event_size(sample, type, 0);
+	return perf_event__synthesize_sample(event, type, 0, sample);
+}
+
 static inline int
 arm_spe_deliver_synth_event(struct arm_spe *spe,
 			    struct arm_spe_queue *speq __maybe_unused,
@@ -256,6 +263,12 @@ arm_spe_deliver_synth_event(struct arm_spe *spe,
 {
 	int ret;
 
+	if (spe->synth_opts.inject) {
+		ret = arm_spe__inject_event(event, sample, spe->sample_type);
+		if (ret)
+			return ret;
+	}
+
 	ret = perf_session__deliver_synth_event(spe->session, event, sample);
 	if (ret)
 		pr_err("ARM SPE: failed to deliver event, error %d\n", ret);
@@ -920,6 +933,8 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
 	else
 		attr.sample_type |= PERF_SAMPLE_TIME;
 
+	spe->sample_type = attr.sample_type;
+
 	attr.exclude_user = evsel->core.attr.exclude_user;
 	attr.exclude_kernel = evsel->core.attr.exclude_kernel;
 	attr.exclude_hv = evsel->core.attr.exclude_hv;
-- 
2.33.0



