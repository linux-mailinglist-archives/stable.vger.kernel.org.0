Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6304F49A45E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380077AbiAYAHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364547AbiAXXsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:48:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6061FC07E320;
        Mon, 24 Jan 2022 13:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27E91B8119E;
        Mon, 24 Jan 2022 21:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F60DC340E4;
        Mon, 24 Jan 2022 21:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060606;
        bh=d5sDqEx7QCzukP98QrCD6x9n7LBmYQ6aePoyYZryyVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8ucc/uqrMxuzrKhFNiXJ5YsKSE6soMtwCNbR1o7ry2/+SUDMir+L8udNk7kvfY6v
         zrqdCyIE2mXRsAPJ0Lvs5Y4xcv7CfnznVCifqrCGjkw2He1qmUEUU1kUZwaFdJacJ4
         EzHJAkOEpzf/zVvxYNSLCSBlXMUsRPwRI1V6hjrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5.16 1003/1039] perf test: Enable system wide for metricgroups test
Date:   Mon, 24 Jan 2022 19:46:32 +0100
Message-Id: <20220124184159.008232832@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit 0046686da0ef692a6381260c3aa44291187eafc9 upstream.

Uncore events as group leaders fail in per-thread mode causing exit
errors. Enable system-wide for metricgroup testing. This fixes the HPC
metric group when tested on skylakex.

Fixes: 4a87dea9e60fe100 ("perf test: Workload test of metric and metricgroups")
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20211223183948.3423989-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/shell/stat_all_metricgroups.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/tests/shell/stat_all_metricgroups.sh
+++ b/tools/perf/tests/shell/stat_all_metricgroups.sh
@@ -6,7 +6,7 @@ set -e
 
 for m in $(perf list --raw-dump metricgroups); do
   echo "Testing $m"
-  perf stat -M "$m" true
+  perf stat -M "$m" -a true
 done
 
 exit 0


