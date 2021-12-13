Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A414730D0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbhLMPpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:53 -0500
Received: from mga14.intel.com ([192.55.52.115]:12918 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240230AbhLMPpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410351; x=1670946351;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=wPMWUK4Nh3W1idNmKkPuoheEX1WIGcxkv5KQ3wOEqIc=;
  b=GfruX61Z8pjs/xQpKXQNJEecTIgpovFJ8mMhUxTAJk7JMMEzXTIW4kKf
   M//YMQNNPWPA9KJ4fw1VyN/hD/o/AQXfN4e9VJqHO8L2uGbsBtqq+Q6wg
   RvZpCvrKbOMMYgOEHC2oKKzS5F3tNAS6XfIXd8JEOxuJH90OPnqNsC4zf
   J+DUIu40fSzmsCaCGBhbm/0LjzP96CZshzO+Xv96RTJY9Dp09zfz22hY/
   SI9fHsANC9hfY00IbGJPjMitzhXJY7Z2K22smWIxKPmqOYsVJG4Nk1cGO
   B9e2jqGukgx1+oWkPzlYiWQZbhi+rgQu8+Q4u4eEl0xysNcA9HrGJl6X7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982215"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982215"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890484"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:50 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 1/8] perf inject: Fix itrace space allowed for new attributes
Date:   Mon, 13 Dec 2021 17:45:41 +0200
Message-Id: <20211213154548.122728-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c29d9792607e67ed8a3f6e9db0d96836d885a8c5 upstream.

The space allowed for new attributes can be too small if existing header
information is large. That can happen, for example, if there are very
many CPUs, due to having an event ID per CPU per event being stored in the
header information.

Fix by adding the existing header.data_offset. Also increase the extra
space allowed to 8KiB and align to a 4KiB boundary for neatness.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20211125071457.2066863-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 5378a14e3836..8f1a99e2fcd7 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -752,7 +752,7 @@ static int __cmd_inject(struct perf_inject *inject)
 		inject->tool.ordered_events = true;
 		inject->tool.ordering_requires_timestamps = true;
 		/* Allow space in the header for new attributes */
-		output_data_offset = 4096;
+		output_data_offset = roundup(8192 + session->header.data_offset, 4096);
 		if (inject->strip)
 			strip_init(inject);
 	}
-- 
2.25.1

