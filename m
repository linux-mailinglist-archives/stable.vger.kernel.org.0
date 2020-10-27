Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A69E29B8BA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801782AbgJ0Pnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801039AbgJ0PhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BDF2064B;
        Tue, 27 Oct 2020 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813038;
        bh=o9s+We82Rph2wrIDLXZEoT2CInvi/IMkST9ydimMTwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XInrBz8QWPntr60f4rrMq3surObv6ueZiK854WeIZT1iHG6J0zIeObAU3N1imOp2B
         /x4SV7fhYD9w9rtF/0zyQwESpOQ3aSura1azaW2sGIiTa/vez0LDKxNoZyKn7xkxdg
         c25OljrnSbC7+hNQn2SBgQzSZZgd9/geEtAaQRjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexei Budankov <alexey.budankov@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 417/757] tools feature: Add missing -lzstd to the fast path feature detection
Date:   Tue, 27 Oct 2020 14:51:07 +0100
Message-Id: <20201027135510.138250706@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 6c014694b1d2702cdc736d17b60746e7b95ba664 ]

We were failing that due to GTK2+ and then for the ZSTD test, which made
test-all.c, the fast path feature detection file to fail and thus
trigger building all of the feature tests, slowing down the test.

Eventually the ZSTD test would be built and would succeed, since it had
the needed -lzstd, avoiding:

  $ cat /tmp/build/perf/feature/test-all.make.output
  /usr/bin/ld: /tmp/ccRRJQ4u.o: in function `main_test_libzstd':
  /home/acme/git/perf/tools/build/feature/test-libzstd.c:8: undefined reference to `ZSTD_createCStream'
  /usr/bin/ld: /home/acme/git/perf/tools/build/feature/test-libzstd.c:9: undefined reference to `ZSTD_freeCStream'
  collect2: error: ld returned 1 exit status
  $

Fix it by adding -lzstd to the test-all target.

Now I need an entry to 'perf test' to make sure that
/tmp/build/perf/feature/test-all.make.output is empty...

Fixes: 3b1c5d9659718263 ("tools build: Implement libzstd feature check, LIBZSTD_DIR and NO_LIBZSTD defines")
Reviewed-by: Alexei Budankov <alexey.budankov@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20200904202611.GJ3753976@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 9ee2bcb8d560a..8da2556cdbfac 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -90,7 +90,7 @@ __BUILDXX = $(CXX) $(CXXFLAGS) -MD -Wall -Werror -o $@ $(patsubst %.bin,%.cpp,$(
 ###############################
 
 $(OUTPUT)test-all.bin:
-	$(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -I/usr/include/slang -lslang $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz -llzma
+	$(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -I/usr/include/slang -lslang $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz -llzma -lzstd
 
 $(OUTPUT)test-hello.bin:
 	$(BUILD)
-- 
2.25.1



