Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82133473D13
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 07:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhLNGQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 01:16:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:42819 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230413AbhLNGQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 01:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639462605; x=1670998605;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FzGPMAoO04Uj94RRb2V0BMuzR8GY/UjzG7lnY6lGmKY=;
  b=Y+cq8/V06C3bhG94z+6b2R5GDZzKdtodqPvCAUkN8yj7PV++WJcKvrS3
   f5hJQYCl3kAf5/UGUzHLYZbwFbW06aOeJZdprSuhkavnhEdwzDIsbEClz
   tLCyERo7qmanRr+vRLEvkZQcn9H1oaoLvq5oH5WbBspC9mx5JF9EhlA4y
   cnP4z8AkwJH5ltC+pBJ3jI7w+Ut5Gm2DcaitK4+rd9R/vaOzt2LUTjNjv
   xxFGYEWioitcfEvg8t0y7l/FYdSTFRwcoVcLU58JeuSzgLj/iAJVlG5KE
   1IHxdQz+1xqzPLTaDSkdE9bCQEk1nNaLd3W1Lspqts4lBk6OhXM16rUif
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="325181322"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="325181322"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 22:16:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="614126280"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga004.jf.intel.com with ESMTP; 13 Dec 2021 22:16:42 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH v5.15] perf inject: Fix itrace space allowed for new attributes
Date:   Tue, 14 Dec 2021 08:16:41 +0200
Message-Id: <20211214061641.125977-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
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
[Adrian: Backport to v5.15]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6ad191e731fc..d454f5a7af93 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -819,7 +819,7 @@ static int __cmd_inject(struct perf_inject *inject)
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

