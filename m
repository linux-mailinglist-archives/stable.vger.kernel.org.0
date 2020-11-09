Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1397C2ABB00
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbgKINSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbgKINSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89DF720731;
        Mon,  9 Nov 2020 13:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927894;
        bh=RtkL23TvcGBX96ySiRBoFU+aWUt5BvVvPw4uVUD+gK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmrL4b+MHlBkN/B98izm8i+wGZZ1Xq4lVttHtul0ytd2RM4iWIJjW5VrLeHj8KwyM
         98+a2sGZhYQiJrLWjc5tQ/uMQIAvA9AkpANgpEGQsGJmxpxDXQa+Vy4dg4S4O0kUXw
         e4eSRIsHu4UVjwbrhz/ygEUEZBubRyDCC9OGdlLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.9 057/133] perf hists browser: Increase size of buf in perf_evsel__hists_browse()
Date:   Mon,  9 Nov 2020 13:55:19 +0100
Message-Id: <20201109125033.466785711@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit 86449b12f626a65d2a2ecfada1e024488471f9e2 upstream.

Making perf with gcc-9.1.1 generates the following warning:

    CC       ui/browsers/hists.o
  ui/browsers/hists.c: In function 'perf_evsel__hists_browse':
  ui/browsers/hists.c:3078:61: error: '%d' directive output may be \
  truncated writing between 1 and 11 bytes into a region of size \
  between 2 and 12 [-Werror=format-truncation=]

   3078 |       "Max event group index to sort is %d (index from 0 to %d)",
        |                                                             ^~
  ui/browsers/hists.c:3078:7: note: directive argument in the range [-2147483648, 8]
   3078 |       "Max event group index to sort is %d (index from 0 to %d)",
        |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  In file included from /usr/include/stdio.h:937,
                   from ui/browsers/hists.c:5:

IOW, the string in line 3078 might be too long for buf[] of 64 bytes.

Fix this by increasing the size of buf[] to 128.

Fixes: dbddf1747441  ("perf report/top TUI: Support hotkeys to let user select any event for sorting")
Signed-off-by: Song Liu <songliubraving@fb.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: stable@vger.kernel.org # v5.7+
Link: http://lore.kernel.org/lkml/20201030235431.534417-1-songliubraving@fb.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/ui/browsers/hists.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -2963,7 +2963,7 @@ static int perf_evsel__hists_browse(stru
 	struct popup_action actions[MAX_OPTIONS];
 	int nr_options = 0;
 	int key = -1;
-	char buf[64];
+	char buf[128];
 	int delay_secs = hbt ? hbt->refresh : 0;
 
 #define HIST_BROWSER_HELP_COMMON					\


