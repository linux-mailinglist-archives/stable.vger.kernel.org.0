Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95F373F66
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfGXT2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbfGXT2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:28:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46EF721951;
        Wed, 24 Jul 2019 19:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996525;
        bh=9T3ggQroFXS+ozFglygL7PVZfvxOBqLm3bkcwDSiRos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fq39ZxkryQRgm1CwOnDeXJb+4KAd0c3uZtH2THMxwYS4dU4KutakBk6PprZVyLnEY
         pQTtoypUKIqIaPLGblUQqHN+9I1litX7h3N5Vyt9PCPmoLLORKSZV4ZUljIJMHRJvU
         vjAgLeI3oZssJ8hlMZHbRd4tZ/4MJF1HL1nkFjTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 120/413] tools build: Fix the zstd test in the test-all.c common case feature test
Date:   Wed, 24 Jul 2019 21:16:51 +0200
Message-Id: <20190724191743.821939385@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3469fa84c1631face938efc42b3f488a2c2504e0 ]

We were renanimg 'main' to 'main_zstd' but then using 'main_libzstd();'
in the main() for test-all.c, causing this:

  $ cat /tmp/build/perf/feature/test-all.make.output
  test-all.c: In function ‘main’:
  test-all.c:236:2: error: implicit declaration of function ‘main_test_libzstd’; did you mean ‘main_test_zstd’? [-Werror=implicit-function-declaration]
    main_test_libzstd();
    ^~~~~~~~~~~~~~~~~
    main_test_zstd
  cc1: all warnings being treated as errors
  $

I.e. what was supposed to be the fast path feature test was _always_
failing, duh, fix it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Fixes: 3b1c5d965971 ("tools build: Implement libzstd feature check, LIBZSTD_DIR and NO_LIBZSTD defines")
Link: https://lkml.kernel.org/n/tip-ma4abk0utroiw4mwpmvnjlru@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/test-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index a59c53705093..939ac2fcc783 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -182,7 +182,7 @@
 # include "test-disassembler-four-args.c"
 #undef main
 
-#define main main_test_zstd
+#define main main_test_libzstd
 # include "test-libzstd.c"
 #undef main
 
-- 
2.20.1



