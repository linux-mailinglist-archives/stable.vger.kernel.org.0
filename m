Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972CF5413A5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358031AbiFGUDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358022AbiFGUCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02E31C2047;
        Tue,  7 Jun 2022 11:25:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE9F360906;
        Tue,  7 Jun 2022 18:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC21C385A2;
        Tue,  7 Jun 2022 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626298;
        bh=aB0jQ82KR7b5RA+Hf2rVDim5Fk3zehrz+vsYPysga2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuh0riqKaeQggDIGcqZyKHwP2E0zKHu6A3o4bdU2Bb04fLzWm4eBGnqI2GOEumc35
         haTCwD9Ehq54M7ACHbsxuxMD/kJPcYw4oqfCfWb6OT/NRkx3huTza0wGjBZewinvbq
         pJBaPrl4bt4+zjkAF9c006Gm8sCZRQ3FIaySoFOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 327/772] perf tools: Use Python devtools for version autodetection rather than runtime
Date:   Tue,  7 Jun 2022 18:58:39 +0200
Message-Id: <20220607164958.657064424@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

[ Upstream commit 630af16eee495f583db5202c3613d1b191f10694 ]

This fixes the issue where the build will fail if only the Python2
runtime is installed but the Python3 devtools are installed. Currently
the workaround is 'make PYTHON=python3'.

Fix it by autodetecting Python based on whether python[x]-config exists
rather than just python[x] because both are needed for the build. Then
-config is stripped to find the Python runtime.

Testing
=======

 * Auto detect links with Python3 when the v3 devtools are installed
   and only Python 2 runtime is installed
 * Auto detect links with Python2 when both devtools are installed
 * Sensible warning is printed if no Python devtools are installed
 * 'make PYTHON=x' still automatically sets PYTHON_CONFIG=x-config
 * 'make PYTHON=x' fails if x-config doesn't exist
 * 'make PYTHON=python3' overrides Python2 devtools
 * 'make PYTHON=python2' overrides Python3 devtools
 * 'make PYTHON_CONFIG=x-config' works
 * 'make PYTHON=x PYTHON_CONFIG=x' works
 * 'make PYTHON=missing' reports an error
 * 'make PYTHON_CONFIG=missing' reports an error

Fixes: 79373082fa9de8be ("perf python: Autodetect python3 binary")
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220309194313.3350126-2-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 39 ++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 1bd64e7404b9..c38423807d01 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -239,18 +239,33 @@ ifdef PARSER_DEBUG
 endif
 
 # Try different combinations to accommodate systems that only have
-# python[2][-config] in weird combinations but always preferring
-# python2 and python2-config as per pep-0394. If python2 or python
-# aren't found, then python3 is used.
-PYTHON_AUTO := python
-PYTHON_AUTO := $(if $(call get-executable,python3),python3,$(PYTHON_AUTO))
-PYTHON_AUTO := $(if $(call get-executable,python),python,$(PYTHON_AUTO))
-PYTHON_AUTO := $(if $(call get-executable,python2),python2,$(PYTHON_AUTO))
-override PYTHON := $(call get-executable-or-default,PYTHON,$(PYTHON_AUTO))
-PYTHON_AUTO_CONFIG := \
-  $(if $(call get-executable,$(PYTHON)-config),$(PYTHON)-config,python-config)
-override PYTHON_CONFIG := \
-  $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON_AUTO_CONFIG))
+# python[2][3]-config in weird combinations in the following order of
+# priority from lowest to highest:
+#   * python3-config
+#   * python-config
+#   * python2-config as per pep-0394.
+#   * $(PYTHON)-config (If PYTHON is user supplied but PYTHON_CONFIG isn't)
+#
+PYTHON_AUTO := python-config
+PYTHON_AUTO := $(if $(call get-executable,python3-config),python3-config,$(PYTHON_AUTO))
+PYTHON_AUTO := $(if $(call get-executable,python-config),python-config,$(PYTHON_AUTO))
+PYTHON_AUTO := $(if $(call get-executable,python2-config),python2-config,$(PYTHON_AUTO))
+
+# If PYTHON is defined but PYTHON_CONFIG isn't, then take $(PYTHON)-config as if it was the user
+# supplied value for PYTHON_CONFIG. Because it's "user supplied", error out if it doesn't exist.
+ifdef PYTHON
+  ifndef PYTHON_CONFIG
+    PYTHON_CONFIG_AUTO := $(call get-executable,$(PYTHON)-config)
+    PYTHON_CONFIG := $(if $(PYTHON_CONFIG_AUTO),$(PYTHON_CONFIG_AUTO),\
+                          $(call $(error $(PYTHON)-config not found)))
+  endif
+endif
+
+# Select either auto detected python and python-config or use user supplied values if they are
+# defined. get-executable-or-default fails with an error if the first argument is supplied but
+# doesn't exist.
+override PYTHON_CONFIG := $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON_AUTO))
+override PYTHON := $(call get-executable-or-default,PYTHON,$(subst -config,,$(PYTHON_AUTO)))
 
 grep-libs  = $(filter -l%,$(1))
 strip-libs  = $(filter-out -l%,$(1))
-- 
2.35.1



