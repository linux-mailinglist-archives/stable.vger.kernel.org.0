Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B501F4833A6
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiACOkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiACOil (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:38:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAAAC07E5E2;
        Mon,  3 Jan 2022 06:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3D2DB80EFC;
        Mon,  3 Jan 2022 14:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E136EC36AED;
        Mon,  3 Jan 2022 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220468;
        bh=YIjBzPPqa5QAcAhiZs0ESAz/+p0tkh4C0LcXrgB+6h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMPAMYX4aCNo49MHpi9rBxvOwNQfIo2TKowL9LtRh4Su90G4A1OVJdLcoimANgl4B
         fTycUSTONLWoOVxgBU+p5Pfny86udtwqK77YyzCBFzSuIH583npguAWhMXDXhMFwqn
         wH7YZLL4ljupS6U29mD+Egz4lyt0uzWCUfZSZTBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 71/73] perf intel-pt: Fix parsing of VM time correlation arguments
Date:   Mon,  3 Jan 2022 15:24:32 +0100
Message-Id: <20220103142059.218449005@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit a78abde220243d6f44a265fe36c49957f6fa9851 upstream.

Parser did not take ':' into account.

Example:

 Before:

  $ perf record -e intel_pt//u uname
  Linux
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.026 MB perf.data ]
  $ perf inject -i perf.data --vm-time-correlation="dry-run 123"
  $ perf inject -i perf.data --vm-time-correlation="dry-run 123:456"
  Failed to parse VM Time Correlation options
  0x620 [0x98]: failed to process type: 70 [Invalid argument]
  $

 After:

  $ perf inject -i perf.data --vm-time-correlation="dry-run 123:456"
  $

Fixes: e3ff42bdebcfeb5f ("perf intel-pt: Parse VM Time Correlation options and set up decoding")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211215080636.149562-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -3540,6 +3540,7 @@ static int intel_pt_parse_vm_tm_corr_arg
 		*args = p;
 		return 0;
 	}
+	p += 1;
 	while (1) {
 		vmcs = strtoull(p, &p, 0);
 		if (errno)


