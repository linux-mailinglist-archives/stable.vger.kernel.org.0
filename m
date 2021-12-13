Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEC34730CF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhLMPpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:53 -0500
Received: from mga14.intel.com ([192.55.52.115]:12917 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240222AbhLMPpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410350; x=1670946350;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o/Pcx0NdNB/ULDnFsoZhJ94wc0R5+MJGaghWDR4h0fQ=;
  b=QlE+EdtjMhZNvh790qv8ddmRainzC61P3pKMQqegSy6liUBgulTsRUw1
   uJ+JRhYdeVsQhTv26jOCEDRXfzXgUdoFXUAY2gav0HHf+LoKML6eVpWfa
   JBUQn2n9P3THVnEDl+H+nKvz7GN/K/5COXSu+oqLdTxYKRgbLIJYfeWI7
   u2MXkoXNGn2SzbbwCqLj0Cr8okqwPH0Pd1DsoVQuRmKwP+edzB2pbx/uv
   lzgpxoPiEq8lE0wYKjWrVAvIcTuBd9fbnXDSkhnGEapc4fv5sbS78ZR64
   XI3Jkz/BTKheoTJp0qEsZ9L5upQk/yk79VcDK4xPKZ40pKkT/PhUxn0qN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982213"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982213"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890481"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:49 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 0/8] perf intel_pt: Fixes for v5.10
Date:   Mon, 13 Dec 2021 17:45:40 +0200
Message-Id: <20211213154548.122728-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here are some fixes backported to v5.10.

Adrian Hunter (8):
      perf inject: Fix itrace space allowed for new attributes
      perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage
      perf intel-pt: Fix sync state when a PSB (synchronization) packet is found
      perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type
      perf intel-pt: Fix state setting when receiving overflow (OVF) packet
      perf intel-pt: Fix next 'err' value, walking trace
      perf intel-pt: Fix missing 'instruction' events with 'q' option
      perf intel-pt: Fix error timestamp setting on the decoder error path

 tools/perf/builtin-inject.c                        |  2 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  | 83 ++++++++++++++--------
 tools/perf/util/intel-pt.c                         |  1 +
 3 files changed, 56 insertions(+), 30 deletions(-)
