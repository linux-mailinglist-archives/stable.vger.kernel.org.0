Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0968255C561
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbiF0Ltj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiF0LsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEABFD34;
        Mon, 27 Jun 2022 04:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 070ED6120B;
        Mon, 27 Jun 2022 11:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BA7C3411D;
        Mon, 27 Jun 2022 11:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330060;
        bh=+1FbClF0Z4V7fDTn2YOUEgIDdWMdgXXxnSO9h32EB18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drIW9xOVPDE4DkfWpRVp9xdp0XSdC5ozT9BzN0HQ+mX8lP0E8dTFOtNcu/N8Ccdz+
         wnw/OZdFvJ6R4EW5BgOxmTTskxVGrSBV5dK+tdYC9wQKXttBECEG55izd6bcdjSIUI
         cZBRLpC0oH5fcfnXPGCHFlDkWfdmlCe5DMFoY4co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, German Gomez <german.gomez@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 070/181] perf test: Record only user callchains on the "Check Arm64 callgraphs are complete in fp mode" test
Date:   Mon, 27 Jun 2022 13:20:43 +0200
Message-Id: <20220627111946.593967753@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit 72dcae8efd42699bbfd55e1ef187310c4e2e5dcb ]

The testcase 'Check Arm64 callgraphs are complete in fp mode' wants to
see the following output:

    610 leaf
    62f parent
    648 main

However, without excluding kernel callchains, the output might look like:

	ffffc2ff40ef1b5c arch_local_irq_enable
	ffffc2ff419d032c __schedule
	ffffc2ff419d06c0 schedule
	ffffc2ff40e4da30 do_notify_resume
	ffffc2ff40e421b0 work_pending
	             610 leaf
	             62f parent
	             648 main

Adding '--user-callchains' leaves only the wanted symbols in the chain.

Fixes: cd6382d82752737e ("perf test arm64: Test unwinding using fame-pointer (fp) mode")
Suggested-by: German Gomez <german.gomez@arm.com>
Reviewed-by: German Gomez <german.gomez@arm.com>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20220614105207.26223-1-mpetlan@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_arm_callgraph_fp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/test_arm_callgraph_fp.sh b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
index 6ffbb27afaba..ec108d45d3c6 100755
--- a/tools/perf/tests/shell/test_arm_callgraph_fp.sh
+++ b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
@@ -43,7 +43,7 @@ CFLAGS="-g -O0 -fno-inline -fno-omit-frame-pointer"
 cc $CFLAGS $TEST_PROGRAM_SOURCE -o $TEST_PROGRAM || exit 1
 
 # Add a 1 second delay to skip samples that are not in the leaf() function
-perf record -o $PERF_DATA --call-graph fp -e cycles//u -D 1000 -- $TEST_PROGRAM 2> /dev/null &
+perf record -o $PERF_DATA --call-graph fp -e cycles//u -D 1000 --user-callchains -- $TEST_PROGRAM 2> /dev/null &
 PID=$!
 
 echo " + Recording (PID=$PID)..."
-- 
2.35.1



