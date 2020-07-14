Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4811C21FBC0
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgGNS4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbgGNS4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD4A222B9;
        Tue, 14 Jul 2020 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752980;
        bh=uH0PDz0zA3uX9zg+dvKMu8xWqiGXeFBXQbz58FsVmRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqVC7l7MRPMI7gN4HUTb1KwoFUJMTmYZBIy0N72NwjZsvROTGk4v27AVkBqokM5Uq
         fcqOW3UqnBsno8u0O50N95BLBRCbE3T62hStwC0XlDtRc+F+QgdKH4FxdaJ1xrncyq
         9LTq5cbusgchT0OzeDLj8xw5b9mYSjLv5NR1l934=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Luwei Kang <luwei.kang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 074/166] perf intel-pt: Fix PEBS sample for XMM registers
Date:   Tue, 14 Jul 2020 20:43:59 +0200
Message-Id: <20200714184119.398711366@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 4c95ad261cfac120dd66238fcae222766754c219 ]

The condition to add XMM registers was missing, the regs array needed to
be in the outer scope, and the size of the regs array was too small.

Fixes: 143d34a6b387b ("perf intel-pt: Add XMM registers to synthesized PEBS sample")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Luwei Kang <luwei.kang@intel.com>
Link: http://lore.kernel.org/lkml/20200630133935.11150-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 23c8289c2472d..545d1cdc0ec87 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -1731,6 +1731,7 @@ static int intel_pt_synth_pebs_sample(struct intel_pt_queue *ptq)
 	u64 sample_type = evsel->core.attr.sample_type;
 	u64 id = evsel->core.id[0];
 	u8 cpumode;
+	u64 regs[8 * sizeof(sample.intr_regs.mask)];
 
 	if (intel_pt_skip_event(pt))
 		return 0;
@@ -1780,8 +1781,8 @@ static int intel_pt_synth_pebs_sample(struct intel_pt_queue *ptq)
 	}
 
 	if (sample_type & PERF_SAMPLE_REGS_INTR &&
-	    items->mask[INTEL_PT_GP_REGS_POS]) {
-		u64 regs[sizeof(sample.intr_regs.mask)];
+	    (items->mask[INTEL_PT_GP_REGS_POS] ||
+	     items->mask[INTEL_PT_XMM_POS])) {
 		u64 regs_mask = evsel->core.attr.sample_regs_intr;
 		u64 *pos;
 
-- 
2.25.1



