Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A033A9BB
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733034AbfFIRAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387762AbfFIRAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:00:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A574204EC;
        Sun,  9 Jun 2019 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099600;
        bh=ZcLssnyOfkxmB9qyxEeI2BuQ1gjRBtkNZDE8hNOJYnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOYFAB0pWJoWnCGYLoO0izIewVkhzS2NAFNjC8m6kS5o2Nz2sJOf6BUQRT/ByrLGP
         ZHLwRGrU1HN55oja31fHsQ0nFN+yopBFynIb20hZGPTW24d68U39vwLB6ef7ixczDI
         2PCfjqL7rsfnvrAAbKB64z5dMX+tdLhFZc4pJ2QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 091/241] perf tools: No need to include bitops.h in util.h
Date:   Sun,  9 Jun 2019 18:40:33 +0200
Message-Id: <20190609164150.412945999@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 6dcca6df4b73d409628c7b4464c63d4eb9d4d13a upstream.

When we switched to the kernel's roundup_pow_of_two we forgot to remove
this include from util.h, do it now.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Fixes: 91529834d1de ("perf evlist: Use roundup_pow_of_two")
Link: http://lkml.kernel.org/n/tip-kfye5rxivib6155cltx0bw4h@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[bwh: Backported to 4.4 as dependency of "tools include: Adopt linux/bits.h":
 - Include <linux/compiler.h> in util/string.c to avoid build regression
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/string.c |    1 +
 tools/perf/util/util.h   |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,4 +1,5 @@
 #include "util.h"
+#include <linux/compiler.h>
 #include "linux/string.h"
 
 #define K 1024LL
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -76,7 +76,6 @@
 #include <sys/ttydefaults.h>
 #include <api/fs/tracing_path.h>
 #include <termios.h>
-#include <linux/bitops.h>
 #include <termios.h>
 
 extern const char *graph_line;


