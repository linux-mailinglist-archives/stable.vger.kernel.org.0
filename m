Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F3524B73E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgHTKry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbgHTKPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:15:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4602075E;
        Thu, 20 Aug 2020 10:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918542;
        bh=uvPcA278+rQVuPgo3OMY2Dm+xirVYV20mS9YL1yHsbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+T4LRKoNuONGgj9SPuRuer5wuXFvdaTmRMpvZ+issaftVojMgTEMoSMq1p1rb8nF
         0pjlyAKSe5B322ez8Rb5pMml8TwlEBI898FiUqNW656rXGslRqRH4JyW6vNwS0rST5
         oJGiJQcOZODw3jVLQVdFBkK0NNNbCQxdVMJjUsHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        David Carrillo-Cisneros <davidcc@google.com>,
        Ian Rogers <irogers@google.com>,
        Igor Lubashev <ilubashe@akamai.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 207/228] tools build feature: Use CC and CXX from parent
Date:   Thu, 20 Aug 2020 11:23:02 +0200
Message-Id: <20200820091617.877908192@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

[ Upstream commit e3232c2f39acafd5a29128425bc30b9884642cfa ]

commit c8c188679ccf ("tools build: Use the same CC for feature detection
and actual build") changed these assignments from unconditional (:=) to
conditional (?=) so that they wouldn't clobber values from the
environment. However, conditional assignment does not work properly for
variables that Make implicitly sets, among which are CC and CXX. To
quote tools/scripts/Makefile.include, which handles this properly:

  # Makefiles suck: This macro sets a default value of $(2) for the
  # variable named by $(1), unless the variable has been set by
  # environment or command line. This is necessary for CC and AR
  # because make sets default values, so the simpler ?= approach
  # won't work as expected.

In other words, the conditional assignments will not run even if the
variables are not overridden in the environment; Make will set CC to
"cc" and CXX to "g++" when it starts[1], meaning the variables are not
empty by the time the conditional assignments are evaluated. This breaks
cross-compilation when CROSS_COMPILE is set but CC isn't, since "cc"
gets used for feature detection instead of the cross compiler (and
likewise for CXX).

To fix the issue, just pass down the values of CC and CXX computed by
the parent Makefile, which gets included by the Makefile that actually
builds whatever we're detecting features for and so is guaranteed to
have good values. This is a better solution anyway, since it means we
aren't trying to replicate the logic of the parent build system and so
don't risk it getting out of sync.

Leave PKG_CONFIG alone, since 1) there's no common logic to compute it
in Makefile.include, and 2) it's not an implicit variable, so
conditional assignment works properly.

[1] https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html

Fixes: c8c188679ccf ("tools build: Use the same CC for feature detection and actual build")
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Carrillo-Cisneros <davidcc@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Igor Lubashev <ilubashe@akamai.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: thomas hebb <tommyhebb@gmail.com>
Link: http://lore.kernel.org/lkml/0a6e69d1736b0fa231a648f50b0cce5d8a6734ef.1595822871.git.tommyhebb@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature | 2 +-
 tools/build/feature/Makefile | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index c71a05b9c984f..a2389f0c0b1c0 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -7,7 +7,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" CXXFLAGS="$(EXTRA_CXXFLAGS) $(FEATURE_CHECK_CXXFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(feature_dir) $(OUTPUT_FEATURES)test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CC=$(CC) CXX=$(CXX) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" CXXFLAGS="$(EXTRA_CXXFLAGS) $(FEATURE_CHECK_CXXFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(feature_dir) $(OUTPUT_FEATURES)test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 96982640fbf88..26316749e594a 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -55,8 +55,6 @@ FILES=                                          \
 
 FILES := $(addprefix $(OUTPUT),$(FILES))
 
-CC ?= $(CROSS_COMPILE)gcc
-CXX ?= $(CROSS_COMPILE)g++
 PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
 LLVM_CONFIG ?= llvm-config
 
-- 
2.25.1



