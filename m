Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F624FD0F1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350592AbiDLG4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351300AbiDLGxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096213056A;
        Mon, 11 Apr 2022 23:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75C63B818C8;
        Tue, 12 Apr 2022 06:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F1CC385A6;
        Tue, 12 Apr 2022 06:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745613;
        bh=esj8rPlEImg7oy3hYs/Ujs6q3bXrl8nGwJwMX09IwHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=My/PT3NZICrtaYCIccSev5hTu6/4LCbGPZZQ7/IZOsxcm4iL/XSWYNcAdk+AYEb1U
         uy3XN8mZ4PyZQqU7FUEhs4fdBLml/nLhjvV4btlTs2/KZLOgz0QWD7PvpSV0DGGh6h
         K0YIdOkq8lntRyweF4dk0DAH2dHyeIX8Qh3gvA1Q=
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
Subject: [PATCH 5.10 155/171] perf build: Dont use -ffat-lto-objects in the python feature test when building with clang-13
Date:   Tue, 12 Apr 2022 08:30:46 +0200
Message-Id: <20220412062932.381281752@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

commit 3a8a0475861a443f02e3a9b57d044fe2a0a99291 upstream.

Using -ffat-lto-objects in the python feature test when building with
clang-13 results in:

  clang-13: error: optimization flag '-ffat-lto-objects' is not supported [-Werror,-Wignored-optimization-argument]
  error: command '/usr/sbin/clang' failed with exit code 1
  cp: cannot stat '/tmp/build/perf/python_ext_build/lib/perf*.so': No such file or directory
  make[2]: *** [Makefile.perf:639: /tmp/build/perf/python/perf.so] Error 1

Noticed when building on a docker.io/library/archlinux:base container.

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
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile.config |    3 +++
 tools/perf/util/setup.py   |    2 ++
 2 files changed, 5 insertions(+)

--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -255,6 +255,9 @@ ifdef PYTHON_CONFIG
   PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS)) -lutil
   PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --includes 2>/dev/null)
   FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+  ifeq ($(CC_NO_CLANG), 0)
+    PYTHON_EMBED_CCOPTS := $(filter-out -ffat-lto-objects, $(PYTHON_EMBED_CCOPTS))
+  endif
 endif
 
 FEATURE_CHECK_CFLAGS-libpython := $(PYTHON_EMBED_CCOPTS)
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -23,6 +23,8 @@ if cc_is_clang:
             vars[var] = sub("-fstack-protector-strong", "", vars[var])
         if not clang_has_option("-fno-semantic-interposition"):
             vars[var] = sub("-fno-semantic-interposition", "", vars[var])
+        if not clang_has_option("-ffat-lto-objects"):
+            vars[var] = sub("-ffat-lto-objects", "", vars[var])
 
 from distutils.core import setup, Extension
 


