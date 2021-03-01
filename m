Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9B4329204
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243516AbhCAUh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:37:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238785AbhCAU3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:29:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CE71651D4;
        Mon,  1 Mar 2021 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622071;
        bh=BWNRNGsAVHHbO3pBOSsklMT2BLqJaOMGeL6zC7QyJHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPURfTubSsJHRQL8Z5n+d9H5VZXJRYUs4TmnxezqBilJxKjWWHYgpe3fK+7bKSD1e
         ad1cTCsKuzuoWMeEJaalfWHUlKoxpe5UKbE/Dl6ARhY98z6yLPYli7YIez2u/tTFL1
         X+ILiU55L+JlM5wXiwB7m0HeLRxxujdLL5p1GqPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, od@zcrc.me,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.11 746/775] perf stat: Use nftw() instead of ftw()
Date:   Mon,  1 Mar 2021 17:15:14 +0100
Message-Id: <20210301161238.178902704@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit a81fbb8771a3810a58d657763fde610bf2c33286 upstream.

ftw() has been obsolete for about 12 years now.

Committer notes:

Further notes provided by the patch author:

    "NOTE: Not runtime-tested, I have no idea what I need to do in perf
     to test this. But at least it compiles now with my uClibc-based
     toolchain."

I looked at the nftw()/ftw() man page and for the use made with cgroups
in 'perf stat' the end result is equivalent.

Fixes: bb1c15b60b98 ("perf stat: Support regex pattern in --for-each-cgroup")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: od@zcrc.me
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20210208181157.1324550-1-paul@crapouillou.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/cgroup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -161,7 +161,7 @@ void evlist__set_default_cgroup(struct e
 
 /* helper function for ftw() in match_cgroups and list_cgroups */
 static int add_cgroup_name(const char *fpath, const struct stat *sb __maybe_unused,
-			   int typeflag)
+			   int typeflag, struct FTW *ftwbuf __maybe_unused)
 {
 	struct cgroup_name *cn;
 
@@ -209,12 +209,12 @@ static int list_cgroups(const char *str)
 			if (!s)
 				return -1;
 			/* pretend if it's added by ftw() */
-			ret = add_cgroup_name(s, NULL, FTW_D);
+			ret = add_cgroup_name(s, NULL, FTW_D, NULL);
 			free(s);
 			if (ret)
 				return -1;
 		} else {
-			if (add_cgroup_name("", NULL, FTW_D) < 0)
+			if (add_cgroup_name("", NULL, FTW_D, NULL) < 0)
 				return -1;
 		}
 
@@ -247,7 +247,7 @@ static int match_cgroups(const char *str
 	prefix_len = strlen(mnt);
 
 	/* collect all cgroups in the cgroup_list */
-	if (ftw(mnt, add_cgroup_name, 20) < 0)
+	if (nftw(mnt, add_cgroup_name, 20, 0) < 0)
 		return -1;
 
 	for (;;) {


