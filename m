Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B679540AB0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351457AbiFGSXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352400AbiFGSRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ABA1928C;
        Tue,  7 Jun 2022 10:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F14CB82354;
        Tue,  7 Jun 2022 17:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C42CC385A5;
        Tue,  7 Jun 2022 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624299;
        bh=RVNCiTgrNrYESd/rZDsxx0nLrxVIdSA1WieB6mjc8Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSErQ0vHuMI6/uXhCiP26xgrtTKhjNJ11i4EIu9HVdQng882GNNpSR7hNfmUhORrS
         xxf52mHIdv1O6wmS2Q0CfAcOwcNJSpP0JHewFUorydIi6ka382Kb+uIOSoF7Zc2Emj
         rwCx1MwS3+dcrzStQXHgWXJmduJfKDe/UzVjp7zM=
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
Subject: [PATCH 5.15 278/667] perf tools: Use Python devtools for version autodetection rather than runtime
Date:   Tue,  7 Jun 2022 18:59:03 +0200
Message-Id: <20220607164943.124319103@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index e0660bc76b7b..1afc67047420 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -237,18 +237,33 @@ ifdef PARSER_DEBUG
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



