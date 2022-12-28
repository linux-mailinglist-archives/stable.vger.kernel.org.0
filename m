Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2596584C9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiL1RCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbiL1RB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:01:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D871E72D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F4FD60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85318C433EF;
        Wed, 28 Dec 2022 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246576;
        bh=vWvS77y3aOqKyCHgi+CB3rdVEMh/eS0ZGnwOuYNBRR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqUo9KCJn5B1clKHyYJ3ZlbFL231O6vPvRl+NdTb7djG3xcQRb3jVSsVQPEXy4UWr
         U0Arazxw7CM/ufj6jGwsNeZTIx31Z3vsIYjF4e3zfa1xqKh3QaQK7X8wtsGVWhQA8M
         +3yGFSaIjxehTbc+xHBImo56q6zWOvDaX10fJZ30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Petlan <mpetlan@redhat.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Disha Goel <disgoel@linux.vnet.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nageswara R Sastry <rnsastry@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1087/1146] perf test: Fix "all PMU test" to skip parametrized events
Date:   Wed, 28 Dec 2022 15:43:46 +0100
Message-Id: <20221228144359.718716577@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit b50d691e50e600fab82b423be871860537d75dc9 ]

Parametrized events are not only a powerpc domain. They occur on other
platforms too (e.g. aarch64). They should be ignored in this testcase,
since proper setup of the parameters is out of scope of this script.

Let's not filter them out by PMU name, but rather based on the fact that
they expect a parameter.

Fixes: 451ed8058c69a3fe ("perf test: Fix "all PMU test" to skip hv_24x7/hv_gpci tests on powerpc")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nageswara R Sastry <rnsastry@linux.ibm.com>
Link: https://lore.kernel.org/r/20221219163008.9691-1-mpetlan@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_pmu.sh | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/tools/perf/tests/shell/stat_all_pmu.sh b/tools/perf/tests/shell/stat_all_pmu.sh
index 9c9ef33e0b3c..c77955419173 100755
--- a/tools/perf/tests/shell/stat_all_pmu.sh
+++ b/tools/perf/tests/shell/stat_all_pmu.sh
@@ -4,17 +4,8 @@
 
 set -e
 
-for p in $(perf list --raw-dump pmu); do
-  # In powerpc, skip the events for hv_24x7 and hv_gpci.
-  # These events needs input values to be filled in for
-  # core, chip, partition id based on system.
-  # Example: hv_24x7/CPM_ADJUNCT_INST,domain=?,core=?/
-  # hv_gpci/event,partition_id=?/
-  # Hence skip these events for ppc.
-  if echo "$p" |grep -Eq 'hv_24x7|hv_gpci' ; then
-    echo "Skipping: Event '$p' in powerpc"
-    continue
-  fi
+# Test all PMU events; however exclude parametrized ones (name contains '?')
+for p in $(perf list --raw-dump pmu | sed 's/[[:graph:]]\+?[[:graph:]]\+[[:space:]]//g'); do
   echo "Testing $p"
   result=$(perf stat -e "$p" true 2>&1)
   if ! echo "$result" | grep -q "$p" && ! echo "$result" | grep -q "<not supported>" ; then
-- 
2.35.1



