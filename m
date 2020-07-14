Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C1E21FA59
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgGNSvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbgGNSvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:51:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43B0A22B2A;
        Tue, 14 Jul 2020 18:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752707;
        bh=UdVNl+rmnCmVIMGITeCqI/vCHrvoAIr2z9iVHtccCB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgVauUPFLXQ46K+hEqcctnNAla6L9thvwl8Wzfs8fAHtj5GxQzBeVR0BIbRQSYoOJ
         FzLlMDeLlAANc9vifFWUUfiO6DM7aYIOQ7DPdPQxKABHKW/LOyUWJZkWMe+WRpaoGm
         M1msJ9WLX96gqCnJV/Onmp56hoUqrXqcl22VoOcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Luwei Kang <luwei.kang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/109] perf intel-pt: Fix recording PEBS-via-PT with registers
Date:   Tue, 14 Jul 2020 20:43:52 +0200
Message-Id: <20200714184107.869835372@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 75bcb8776dc987538f267ba4ba05ca43fc2b1676 ]

When recording PEBS-via-PT, the kernel will not accept the intel_pt
event with register sampling e.g.

 # perf record --kcore -c 10000 -e '{intel_pt/branch=0/,branch-loads/aux-output/ppp}' -I -- ls -l
 Error:
 intel_pt/branch=0/: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

Fix by suppressing register sampling on the intel_pt evsel.

Committer notes:

Adrian informed that this is only available from Tremont onwards, so on
older processors the error continues the same as before.

Fixes: 9e64cefe4335b ("perf intel-pt: Process options for PEBS event synthesis")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Luwei Kang <luwei.kang@intel.com>
Link: http://lore.kernel.org/lkml/20200630133935.11150-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/intel-pt.c | 1 +
 tools/perf/util/evsel.c             | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index d43f9dec69980..e768c02ef2ab9 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -596,6 +596,7 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 			}
 			evsel->core.attr.freq = 0;
 			evsel->core.attr.sample_period = 1;
+			evsel->no_aux_samples = true;
 			intel_pt_evsel = evsel;
 			opts->full_auxtrace = true;
 		}
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index abc7fda4a0fe1..a844715a352d8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1028,12 +1028,12 @@ void perf_evsel__config(struct evsel *evsel, struct record_opts *opts,
 	if (callchain && callchain->enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callchain(evsel, opts, callchain);
 
-	if (opts->sample_intr_regs) {
+	if (opts->sample_intr_regs && !evsel->no_aux_samples) {
 		attr->sample_regs_intr = opts->sample_intr_regs;
 		perf_evsel__set_sample_bit(evsel, REGS_INTR);
 	}
 
-	if (opts->sample_user_regs) {
+	if (opts->sample_user_regs && !evsel->no_aux_samples) {
 		attr->sample_regs_user |= opts->sample_user_regs;
 		perf_evsel__set_sample_bit(evsel, REGS_USER);
 	}
-- 
2.25.1



