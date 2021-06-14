Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7723A6497
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbhFNL0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236287AbhFNLYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F63561420;
        Mon, 14 Jun 2021 10:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668061;
        bh=+S26NXupBNYwW4jLPGEWnQrtsAe1QHkXvjky6ruhTDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEdbrruVnpeCNT7PZp2/Yyazzz/IGLeekxeTB/FRXTV/Er+IYkhmWZnMRzRo7TVxa
         mCwSo9A40YKSxe/hksTjoduFBiMOCHBiFmaxg0WSUXuBeluA6dhwid8oQOxzCSangq
         GqI+z0ZuTn8j1rdbYCNVbzMIz62wkz0TsOGp3a2A=
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
Subject: [PATCH 5.12 165/173] perf session: Correct buffer copying when peeking events
Date:   Mon, 14 Jun 2021 12:28:17 +0200
Message-Id: <20210614102703.660455562@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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
index e9d4e6f4bdf3..b7cfdbf207b7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1710,6 +1710,7 @@ int perf_session__peek_event(struct perf_session *session, off_t file_offset,
 	if (event->header.size < hdr_sz || event->header.size > buf_sz)
 		return -1;
 
+	buf += hdr_sz;
 	rest = event->header.size - hdr_sz;
 
 	if (readn(fd, buf, rest) != (ssize_t)rest)
-- 
2.30.2



