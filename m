Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5303D1B4140
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgDVKLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729170AbgDVKLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD89D2075A;
        Wed, 22 Apr 2020 10:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550275;
        bh=b3/W7jcf3pRlbI3TaNKbiNoXM+9KitAJVtIo5w9oeAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASTug0Xy6igg1jtPg51NzXlgkI654F2q2cu4cby7zRjL1bgu+ExusmpfjgURPplRn
         967/x3KGkjNIkay6kWMVK/LSMt1irjJqa+LxonuW0oc9qrwApPUkgUlC4pwKdpST+h
         UKBfWXvrtBSrPmi7MXDF5AZoeYLZIzUU4o7AhC60=
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
Subject: [PATCH 4.14 080/199] perf tools: Support Python 3.8+ in Makefile
Date:   Wed, 22 Apr 2020 11:56:46 +0200
Message-Id: <20200422095106.117968848@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
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
@@ -179,8 +179,17 @@ strip-libs  = $(filter-out -l%,$(1))
 
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
   PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)


