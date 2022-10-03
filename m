Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E369F5F29CB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiJCHZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiJCHYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8624BD3E;
        Mon,  3 Oct 2022 00:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92FFE60FA9;
        Mon,  3 Oct 2022 07:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70308C433D6;
        Mon,  3 Oct 2022 07:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781368;
        bh=dybPGXdcqcvWSfFoE1rkJVjWUx2hSoQdde7i7X3AEoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFt7xxTmE0w/hLtVRzqe6NwneYM9FPuOxNy3g2WA4jfdausv2cxyrg7NxvCp/bYdR
         QjvytDlHegiIPRFTdMbn1kw5ISrQVboZ6H55QlvHDq5oZI4jTgg3or/47X2/3NcJOX
         FlrpecMk2DidXHrfiI5EpOpfThvrAjG3U5rA/YC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 096/101] perf test: Fix test case 87 ("perf record tests") for hybrid systems
Date:   Mon,  3 Oct 2022 09:11:32 +0200
Message-Id: <20221003070726.820259923@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit 457c8b60267054869513ab1fb5513abb0a566dd0 ]

The test case 87 ("perf record tests") failed on hybrid systems,the event
"cpu/br_inst_retired.near_call/p" is only for non-hybrid system. Correct
the test event to support both non-hybrid and hybrid systems.

Before:

  # ./perf test 87
  87: perf record tests                                   : FAILED!

After:

  # ./perf test 87
  87: perf record tests                                   : Ok

Fixes: 24f378e66021f559 ("perf test: Add basic perf record tests")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220927051513.3768717-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/record.sh b/tools/perf/tests/shell/record.sh
index 00c7285ce1ac..301f95427159 100755
--- a/tools/perf/tests/shell/record.sh
+++ b/tools/perf/tests/shell/record.sh
@@ -61,7 +61,7 @@ test_register_capture() {
     echo "Register capture test [Skipped missing registers]"
     return
   fi
-  if ! perf record -o - --intr-regs=di,r8,dx,cx -e cpu/br_inst_retired.near_call/p \
+  if ! perf record -o - --intr-regs=di,r8,dx,cx -e br_inst_retired.near_call:p \
     -c 1000 --per-thread true 2> /dev/null \
     | perf script -F ip,sym,iregs -i - 2> /dev/null \
     | egrep -q "DI:"
-- 
2.35.1



