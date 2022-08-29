Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43B65A4A6F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiH2LiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiH2Lhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA147FE63;
        Mon, 29 Aug 2022 04:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FEBA611DD;
        Mon, 29 Aug 2022 11:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53395C433C1;
        Mon, 29 Aug 2022 11:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771637;
        bh=G8l73KuKQFFi1N8uSxU0yn+o6asbk79POhOpvsgjEgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFBTM/0t1u0Wvrd/1hep0u7LE1NbyHQqMc+/ib3Bs/txyQa7cAJmNsCr88Ni4KCED
         HRU6elHpU3YKdF/qriPNVpyHfJ6DiBD6hcKgnxnwDWsyVySAurCuV9OQPuXSrqZ27F
         NmtT0wJO3hpZc9sjSBXQ3w+CF+strcQOkxDOfxEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 130/136] perf python: Fix build when PYTHON_CONFIG is user supplied
Date:   Mon, 29 Aug 2022 12:59:57 +0200
Message-Id: <20220829105810.030108406@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: James Clark <james.clark@arm.com>

commit bc9e7fe313d5e56d4d5f34bcc04d1165f94f86fb upstream.

The previous change to Python autodetection had a small mistake where
the auto value was used to determine the Python binary, rather than the
user supplied value. The Python binary is only used for one part of the
build process, rather than the final linking, so it was producing
correct builds in most scenarios, especially when the auto detected
value matched what the user wanted, or the system only had a valid set
of Pythons.

Change it so that the Python binary path is derived from either the
PYTHON_CONFIG value or PYTHON value, depending on what is specified by
the user. This was the original intention.

This error was spotted in a build failure an odd cross compilation
environment after commit 4c41cb46a732fe82 ("perf python: Prefer
python3") was merged.

Fixes: 630af16eee495f58 ("perf tools: Use Python devtools for version autodetection rather than runtime")
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220728093946.1337642-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile.config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -263,7 +263,7 @@ endif
 # defined. get-executable-or-default fails with an error if the first argument is supplied but
 # doesn't exist.
 override PYTHON_CONFIG := $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON_AUTO))
-override PYTHON := $(call get-executable-or-default,PYTHON,$(subst -config,,$(PYTHON_AUTO)))
+override PYTHON := $(call get-executable-or-default,PYTHON,$(subst -config,,$(PYTHON_CONFIG)))
 
 grep-libs  = $(filter -l%,$(1))
 strip-libs  = $(filter-out -l%,$(1))


