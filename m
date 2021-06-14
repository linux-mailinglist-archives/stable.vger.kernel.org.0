Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1606A3A6034
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhFNKcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232982AbhFNKb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:31:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B528561206;
        Mon, 14 Jun 2021 10:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666578;
        bh=oorC/DVzdfQ70Y7BRI3uAUe33u5+TE6kQK7sH2MujVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAuUoVrrFmpSWum5fjPqD3RpozNm8GHOWUKdWXfZPEz0XtavVANbL+6z+APdU8t31
         9hLg2761gY2vo9poLuyNWFy29lrzTjYi5er/bp3wEyUYDqRKtEVTqsZEC915iaO7zH
         thGsMdRf67nayLg6kB08zj5iqUVwytkEudJQYGEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/34] perf session: Correct buffer copying when peeking events
Date:   Mon, 14 Jun 2021 12:27:21 +0200
Message-Id: <20210614102642.545748223@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 197eecb6ecae0b04bd694432f640ff75597fed9c ]

When peeking an event, it has a short path and a long path.  The short
path uses the session pointer "one_mmap_addr" to directly fetch the
event; and the long path needs to read out the event header and the
following event data from file and fill into the buffer pointer passed
through the argument "buf".

The issue is in the long path that it copies the event header and event
data into the same destination address which pointer "buf", this means
the event header is overwritten.  We are just lucky to run into the
short path in most cases, so we don't hit the issue in the long path.

This patch adds the offset "hdr_sz" to the pointer "buf" when copying
the event data, so that it can reserve the event header which can be
used properly by its caller.

Fixes: 5a52f33adf02 ("perf session: Add perf_session__peek_event()")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210605052957.1070720-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5b392662d100..1029225ee417 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1255,6 +1255,7 @@ int perf_session__peek_event(struct perf_session *session, off_t file_offset,
 	if (event->header.size < hdr_sz || event->header.size > buf_sz)
 		return -1;
 
+	buf += hdr_sz;
 	rest = event->header.size - hdr_sz;
 
 	if (readn(fd, buf, rest) != (ssize_t)rest)
-- 
2.30.2



