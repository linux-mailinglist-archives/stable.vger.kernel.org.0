Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E115E812D
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbiIWRzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiIWRzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBE4B6D00
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:55:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D78C60D58
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 17:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAE3C433D6;
        Fri, 23 Sep 2022 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663955706;
        bh=3dAAaIUTBVElyH3pt4+gWMQ+zkZdVgs8fBa64VF8Zd8=;
        h=Subject:To:Cc:From:Date:From;
        b=IVmkIwGxpAn9HXaweAdDlVA9PRfZiRo69+zia5EaCiQ7ZPx1pE60vhbAbiiEqBCPQ
         DE5sUD8+/fNiAvQQhxzyRlYVnTzZYPLrjUDbSbDZHhQV+VLwFHK6dQ0SCD93cQhh2u
         CPizvIqffHABXxrgQtlOhOCxkYw4c8QrbZ3as54c=
Subject: FAILED: patch "[PATCH] perf record: Fix cpu mask bit setting for mixed mmaps" failed to apply to 5.19-stable tree
To:     adrian.hunter@intel.com, acme@redhat.com,
        atrajeev@linux.vnet.ibm.com, irogers@google.com, jolsa@kernel.org,
        namhyung@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Sep 2022 19:55:03 +0200
Message-ID: <166395570321772@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ca76d7d2812b ("perf record: Fix cpu mask bit setting for mixed mmaps")
cbd7bfc7fd99 ("tools/perf: Fix out of bound access to cpu mask array")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca76d7d2812b46124291f99c9b50aaf63a936f23 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Thu, 15 Sep 2022 15:26:11 +0300
Subject: [PATCH] perf record: Fix cpu mask bit setting for mixed mmaps

With mixed per-thread and (system-wide) per-cpu maps, the "any cpu" value
 -1 must be skipped when setting CPU mask bits.

Prior to commit cbd7bfc7fd99acdd ("tools/perf: Fix out of bound access
to cpu mask array") the invalid setting went unnoticed, but since then
it causes perf record to fail with an error.

Example:

 Before:

   $ perf record -e intel_pt// --per-thread uname
   Failed to initialize parallel data streaming masks

 After:

   $ perf record -e intel_pt// --per-thread uname
   Linux
   [ perf record: Woken up 1 times to write data ]
   [ perf record: Captured and wrote 0.068 MB perf.data ]

Fixes: ae4f8ae16a078964 ("libperf evlist: Allow mixing per-thread and per-cpu mmaps")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220915122612.81738-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f87ef43eb820..0f711f88894c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -3371,6 +3371,8 @@ static int record__mmap_cpu_mask_init(struct mmap_cpu_mask *mask, struct perf_cp
 		return 0;
 
 	perf_cpu_map__for_each_cpu(cpu, idx, cpus) {
+		if (cpu.cpu == -1)
+			continue;
 		/* Return ENODEV is input cpu is greater than max cpu */
 		if ((unsigned long)cpu.cpu > mask->nbits)
 			return -ENODEV;

