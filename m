Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82218261D43
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732296AbgIHTea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6701D23D56;
        Tue,  8 Sep 2020 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579468;
        bh=ROuPUnHiAUE0W92blqdgbs85h5p1CLIn/+/Wp4JZWrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Udt6VGtjzgFEck1PlXs7pFsUWZJHKHfSYE+E4hgpU/wvVNuWJH/kfXFAMRtdNIe6b
         AqBmE1ebNFoM8am/oXD/weEfk8V1Ux1EipOsAxvGNIRV+EDP5/3Y5xIDcWO1EbA2y8
         up1+WLgmCUjHImy+BAQWpe9D17iAmp94xdAU2LI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 091/186] perf top/report: Fix infinite loop in the TUI for grouped events
Date:   Tue,  8 Sep 2020 17:23:53 +0200
Message-Id: <20200908152246.052938339@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d4ccbacb9c217fefb4332a9af81b785690cf1053 ]

For a while we need to have a dummy event for doing things like
receiving PERF_RECORD_COMM, PERF_RECORD_EXEC, etc for threads being
created and dying while we synthesize the pre-existing ones at tool
start.

This 'dummy' event is needed for keeping track of thread lifetime events
early in the session but are uninteresting otherwise, i.e. no need to
have it in a initial events menu for the non-grouped case, i.e. for:

 # perf top -e cycles,instructions

or even for plain:

 # perf top

When 'cycles' and that 'dummy' event are in place.

The code to remove that 'dummy' event ended up creating an endless loop
for the grouped case, i.e.:

 # perf top -e '{cycles,instructions}'

Fix it.

Fixes: bee9ca1c8a237ca1 ("perf report TUI: Remove needless 'dummy' event from menu")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index be9c4c0549bc8..a07626f072087 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -3629,8 +3629,8 @@ int perf_evlist__tui_browse_hists(struct evlist *evlist, const char *help,
 {
 	int nr_entries = evlist->core.nr_entries;
 
-single_entry:
 	if (perf_evlist__single_entry(evlist)) {
+single_entry: {
 		struct evsel *first = evlist__first(evlist);
 
 		return perf_evsel__hists_browse(first, nr_entries, help,
@@ -3638,6 +3638,7 @@ single_entry:
 						env, warn_lost_event,
 						annotation_opts);
 	}
+	}
 
 	if (symbol_conf.event_group) {
 		struct evsel *pos;
-- 
2.25.1



