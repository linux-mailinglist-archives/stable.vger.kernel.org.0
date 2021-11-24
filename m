Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A7045C598
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349740AbhKXN70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353092AbhKXN4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1766613A9;
        Wed, 24 Nov 2021 13:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759236;
        bh=TYFj3IS26qbpWm+zm7eFIX1n8g6AIX5Z/b1s18PlP/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzbbL+V29SfZVopCtgLy+qO6Xpo9AcrkhPTOCjy+KGAzjHmxWUe3yQyZWjOTvVDcX
         NWNrh+OA1om9adzYHwyBn9CENKD6otA22dc9QsGc7ogCXGhHGbtKC8j0BTUU64BLlB
         SZUKXHvIH8STIU3Y8RmMXbvI7fEVGPe2ghxWam6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/279] tools build: Fix removal of feature-sync-compare-and-swap feature detection
Date:   Wed, 24 Nov 2021 12:57:41 +0100
Message-Id: <20211124115724.760023636@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e8c04ea0fef5731dbcaabac86d65254c227aedf4 ]

The patch removing the feature-sync-compare-and-swap feature detection
didn't remove the call to main_test_sync_compare_and_swap(), making the
'test-all' case fail an all the feature tests to be performed
individually:

  $ cat /tmp/build/perf/feature/test-all.make.output
  In file included from test-all.c:18:
  test-libpython-version.c:5:10: error: #error
      5 |         #error
        |          ^~~~~
  test-all.c: In function ‘main’:
  test-all.c:203:9: error: implicit declaration of function ‘main_test_sync_compare_and_swap’ [-Werror=implicit-function-declaration]
    203 |         main_test_sync_compare_and_swap(argc, argv);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors
  $

Fix it, now to figure out what is that test-libpython-version.c
problem...

Fixes: 60fa754b2a5a4e0c ("tools: Remove feature-sync-compare-and-swap feature detection")
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/YZU9Fe0sgkHSXeC2@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/test-all.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index 9204395272912..0b243ce842be3 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -200,7 +200,6 @@ int main(int argc, char *argv[])
 	main_test_timerfd();
 	main_test_stackprotector_all();
 	main_test_libdw_dwarf_unwind();
-	main_test_sync_compare_and_swap(argc, argv);
 	main_test_zlib();
 	main_test_pthread_attr_setaffinity_np();
 	main_test_pthread_barrier();
-- 
2.33.0



