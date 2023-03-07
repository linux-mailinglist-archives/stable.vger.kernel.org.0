Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8576AF451
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjCGTQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbjCGTPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C6AE10E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5AD6153F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C73DC433EF;
        Tue,  7 Mar 2023 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215548;
        bh=+gG78ObpD8v6Uhmrv4zUkPa2t7eYN91BNznaEBr2Ekw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1duWUCLxzv6VqxfKK5iZQx1engIfBnYkTFCpsKnqw+O/kHg2VEW3gB8T/Ue9hMjD
         dNEO2P4btPO8JNH6rC7CkYZpaQ9aBrg3m9dTEcip0Pk3/jWUEgVm39m55gGbnVxKsQ
         gbtNH04qIsSUE25iSNTXC0M/Fi1FTB0fNc8IeKBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Clark <james.clark@arm.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
        prime.zeng@hisilicon.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/567] perf tools: Fix auto-complete on aarch64
Date:   Tue,  7 Mar 2023 18:00:02 +0100
Message-Id: <20230307165917.463364933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit ffd1240e8f0814262ceb957dbe961f6e0aef1e7a ]

On aarch64 CPU related events are not under event_source/devices/cpu/events,
they're under event_source/devices/armv8_pmuv3_0/events on my machine.
Using current auto-complete script will generate below error:

  [root@localhost bin]# perf stat -e
  ls: cannot access '/sys/bus/event_source/devices/cpu/events': No such file or directory

Fix this by not testing /sys/bus/event_source/devices/cpu/events on
aarch64 machine.

Fixes: 74cd5815d9af6e6c ("perf tool: Improve bash command line auto-complete for multiple events with comma")
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxarm@huawei.com
Cc: prime.zeng@hisilicon.com
Link: https://lore.kernel.org/r/20230207035057.43394-1-yangyicong@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/perf-completion.sh | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index fdf75d45efff7..978249d7868c2 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -165,7 +165,12 @@ __perf_main ()
 
 		local cur1=${COMP_WORDS[COMP_CWORD]}
 		local raw_evts=$($cmd list --raw-dump)
-		local arr s tmp result
+		local arr s tmp result cpu_evts
+
+		# aarch64 doesn't have /sys/bus/event_source/devices/cpu/events
+		if [[ `uname -m` != aarch64 ]]; then
+			cpu_evts=$(ls /sys/bus/event_source/devices/cpu/events)
+		fi
 
 		if [[ "$cur1" == */* && ${cur1#*/} =~ ^[A-Z] ]]; then
 			OLD_IFS="$IFS"
@@ -183,9 +188,9 @@ __perf_main ()
 				fi
 			done
 
-			evts=${result}" "$(ls /sys/bus/event_source/devices/cpu/events)
+			evts=${result}" "${cpu_evts}
 		else
-			evts=${raw_evts}" "$(ls /sys/bus/event_source/devices/cpu/events)
+			evts=${raw_evts}" "${cpu_evts}
 		fi
 
 		if [[ "$cur1" == , ]]; then
-- 
2.39.2



