Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F6B4FD86A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351604AbiDLHUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351796AbiDLHM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E3610ED;
        Mon, 11 Apr 2022 23:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09448B81B35;
        Tue, 12 Apr 2022 06:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35766C385A1;
        Tue, 12 Apr 2022 06:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746369;
        bh=zfD7YjenlyUPbPHuXN1cKuXgTMmzI3+KRTFSfXHPC28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oia1VvUxHB2sgpesLtiR7dZD0sPY/rscvHiXuwVWwmr3BpPxlFbRsQWUD6Pa4LYFJ
         LCONFxp63+JcuJhLo2W2AXBy1TbhjoTciyUA3IPe/mU6dinfVazJMJ6B0yulKQmi9x
         qw4Nu2jcj42y2ak/resFD2v4Ur2FoUBAnyvVMvuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Fangrui Song <maskray@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        John Keeping <john@metanate.com>, Leo Yan <leo.yan@linaro.org>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 257/277] perf python: Fix probing for some clang command line options
Date:   Tue, 12 Apr 2022 08:31:00 +0200
Message-Id: <20220412062949.479061696@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit dd6e1fe91cdd52774ca642d1da75b58a86356b56 upstream.

The clang compiler complains about some options even without a source
file being available, while others require one, so use the simple
tools/build/feature/test-hello.c file.

Then check for the "is not supported" string in its output, in addition
to the "unknown argument" already being looked for.

This was noticed when building with clang-13 where -ffat-lto-objects
isn't supported and since we were looking just for "unknown argument"
and not providing a source code to clang, was mistakenly assumed as
being available and not being filtered to set of command line options
provided to clang, leading to a build failure.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Keeping <john@metanate.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Link: http://lore.kernel.org/lkml/
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/setup.py |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,12 +1,14 @@
-from os import getenv
+from os import getenv, path
 from subprocess import Popen, PIPE
 from re import sub
 
 cc = getenv("CC")
 cc_is_clang = b"clang version" in Popen([cc.split()[0], "-v"], stderr=PIPE).stderr.readline()
+src_feature_tests  = getenv('srctree') + '/tools/build/feature'
 
 def clang_has_option(option):
-    return [o for o in Popen([cc, option], stderr=PIPE).stderr.readlines() if b"unknown argument" in o] == [ ]
+    cc_output = Popen([cc, option, path.join(src_feature_tests, "test-hello.c") ], stderr=PIPE).stderr.readlines()
+    return [o for o in cc_output if ((b"unknown argument" in o) or (b"is not supported" in o))] == [ ]
 
 if cc_is_clang:
     from distutils.sysconfig import get_config_vars


