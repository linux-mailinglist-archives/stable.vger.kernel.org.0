Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE4D6B456E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjCJOdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjCJOdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB64344A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 412E1B822DC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB9AC433D2;
        Fri, 10 Mar 2023 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458786;
        bh=+gG78ObpD8v6Uhmrv4zUkPa2t7eYN91BNznaEBr2Ekw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i59F0GYyeNNMtiLWRn8xkdf6+h/w9/9s1BoT8a34sjbesJqpnmxTsJ8YOJjTWzrfv
         ix8K67Ivr/u5yhrLpNSe6E5+QR0TKuSf09WQnO635q0l6UwlmZjTDn8D+tUjUUd6dD
         H6XOcnT+YMod0gfrJG9ISiX836WS+PKbW3zmneaU=
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
Subject: [PATCH 5.4 144/357] perf tools: Fix auto-complete on aarch64
Date:   Fri, 10 Mar 2023 14:37:13 +0100
Message-Id: <20230310133741.056117475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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



