Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B521AC29C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895617AbgDPNa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896234AbgDPNaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF4BF208E4;
        Thu, 16 Apr 2020 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043824;
        bh=Xvmjoi92OvJUwlY82pFjMtHYRewlhRmphOGTlfCxM0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LL27M/GboGoYXVnjOEsLv+qT6gAzmUyf2pfQ8+SV2CUvuyegDPtl395TuAxH6dnZo
         ZUwyNWXciAhXLGys8xw4c6MEjWuEwt0UTdu8umyA/y4f7zrBY3UtgGYm20kQn5hrty
         wKS39qQ5Cu9EdPrkjRHXFRMhG237WlTCFgt2lq14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Lunt <samuel.j.lunt@gmail.com>,
        He Zhe <zhe.he@windriver.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, trivial@kernel.org,
        stable@kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.19 114/146] perf tools: Support Python 3.8+ in Makefile
Date:   Thu, 16 Apr 2020 15:24:15 +0200
Message-Id: <20200416131258.230292318@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Lunt <samueljlunt@gmail.com>

commit b9c9ce4e598e012ca7c1813fae2f4d02395807de upstream.

Python 3.8 changed the output of 'python-config --ldflags' to no longer
include the '-lpythonX.Y' flag (this apparently fixed an issue loading
modules with a statically linked Python executable).  The libpython
feature check in linux/build/feature fails if the Python library is not
included in FEATURE_CHECK_LDFLAGS-libpython variable.

This adds a check in the Makefile to determine if PYTHON_CONFIG accepts
the '--embed' flag and passes that flag alongside '--ldflags' if so.

tools/perf is the only place the libpython feature check is used.

Signed-off-by: Sam Lunt <samuel.j.lunt@gmail.com>
Tested-by: He Zhe <zhe.he@windriver.com>
Link: http://lore.kernel.org/lkml/c56be2e1-8111-9dfe-8298-f7d0f9ab7431@windriver.com
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: trivial@kernel.org
Cc: stable@kernel.org
Link: http://lore.kernel.org/lkml/20200131181123.tmamivhq4b7uqasr@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/Makefile.config |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -205,8 +205,17 @@ strip-libs  = $(filter-out -l%,$(1))
 
 PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
 
+# Python 3.8 changed the output of `python-config --ldflags` to not include the
+# '-lpythonX.Y' flag unless '--embed' is also passed. The feature check for
+# libpython fails if that flag is not included in LDFLAGS
+ifeq ($(shell $(PYTHON_CONFIG_SQ) --ldflags --embed 2>&1 1>/dev/null; echo $$?), 0)
+  PYTHON_CONFIG_LDFLAGS := --ldflags --embed
+else
+  PYTHON_CONFIG_LDFLAGS := --ldflags
+endif
+
 ifdef PYTHON_CONFIG
-  PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+  PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) $(PYTHON_CONFIG_LDFLAGS) 2>/dev/null)
   PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
   PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS)) -lutil
   PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --includes 2>/dev/null)


