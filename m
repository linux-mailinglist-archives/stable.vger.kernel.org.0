Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2E0329079
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhCAUIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242436AbhCAT6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:58:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8953C65055;
        Mon,  1 Mar 2021 17:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621379;
        bh=MWE7QtOoBlErhrT8MojV3WOeIkfKXnfSMRQlDmFxo90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3op1SPZYz68H8IiWxFjSMbB9AjfOMwtRo5UKajwVg3cSESMwFggqLPYbl2GBePqN
         v/9F0R07HQyFDfkWNh2NkBDMVv/jdgfU48zdqlzTgvBK/pbpXCBFfH1+MW+WQpohH7
         lP3D5BGFKfoZ86gvPXT1P1RI2zHLGR5D12nHtBTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Jihong <yangjihong1@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, zhangjinhao2@huawei.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 465/775] perf record: Fix continue profiling after draining the buffer
Date:   Mon,  1 Mar 2021 17:10:33 +0100
Message-Id: <20210301161224.527680855@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit e16c2ce7c5ed5de881066c1fd10ba5c09af69559 ]

Commit da231338ec9c0987 ("perf record: Use an eventfd to wakeup when
done") uses eventfd() to solve a rare race where the setting and
checking of 'done' which add done_fd to pollfd.  When draining buffer,
revents of done_fd is 0 and evlist__filter_pollfd function returns a
non-zero value.  As a result, perf record does not stop profiling.

The following simple scenarios can trigger this condition:

  # sleep 10 &
  # perf record -p $!

After the sleep process exits, perf record should stop profiling and exit.
However, perf record keeps running.

If pollfd revents contains only POLLERR or POLLHUP, perf record
indicates that buffer is draining and need to stop profiling.  Use
fdarray_flag__nonfilterable() to set done eventfd to nonfilterable
objects, so that evlist__filter_pollfd() does not filter and check done
eventfd.

Fixes: da231338ec9c0987 ("perf record: Use an eventfd to wakeup when done")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: zhangjinhao2@huawei.com
Link: http://lore.kernel.org/lkml/20210205065001.23252-1-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 2 +-
 tools/perf/util/evlist.c    | 8 ++++++++
 tools/perf/util/evlist.h    | 4 ++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fd39116506123..51e593e896ea5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1663,7 +1663,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		status = -1;
 		goto out_delete_session;
 	}
-	err = evlist__add_pollfd(rec->evlist, done_fd);
+	err = evlist__add_wakeup_eventfd(rec->evlist, done_fd);
 	if (err < 0) {
 		pr_err("Failed to add wakeup eventfd to poll list\n");
 		status = err;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 05363a7247c41..fea4c1e8010d9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -572,6 +572,14 @@ int evlist__filter_pollfd(struct evlist *evlist, short revents_and_mask)
 	return perf_evlist__filter_pollfd(&evlist->core, revents_and_mask);
 }
 
+#ifdef HAVE_EVENTFD_SUPPORT
+int evlist__add_wakeup_eventfd(struct evlist *evlist, int fd)
+{
+	return perf_evlist__add_pollfd(&evlist->core, fd, NULL, POLLIN,
+				       fdarray_flag__nonfilterable);
+}
+#endif
+
 int evlist__poll(struct evlist *evlist, int timeout)
 {
 	return perf_evlist__poll(&evlist->core, timeout);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 1aae75895dea0..6d4d62151bc89 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -142,6 +142,10 @@ struct evsel *evlist__find_tracepoint_by_name(struct evlist *evlist, const char
 int evlist__add_pollfd(struct evlist *evlist, int fd);
 int evlist__filter_pollfd(struct evlist *evlist, short revents_and_mask);
 
+#ifdef HAVE_EVENTFD_SUPPORT
+int evlist__add_wakeup_eventfd(struct evlist *evlist, int fd);
+#endif
+
 int evlist__poll(struct evlist *evlist, int timeout);
 
 struct evsel *evlist__id2evsel(struct evlist *evlist, u64 id);
-- 
2.27.0



