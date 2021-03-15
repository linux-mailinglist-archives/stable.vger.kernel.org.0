Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7770C33B6D7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhCON64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231683AbhCON6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A59964F09;
        Mon, 15 Mar 2021 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816679;
        bh=4dxnC+z2O23rt+e3NSTNQYUyj91ckyhJEtphZAoFisM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wHS+Px2KHvdz8z/6c6efeNLfnayP5q5fQhBWzSHPBU7DvAAp4heukOSgRQG9WXcz
         onGniNf515oNJeeQEgF7hxetOPzFnNYklPIKFSHoqXNdmUdEHYsJLkl6NgnPqp8U82
         Bjumvgby9ynlCGekmJeyncjdKx13bwaRaW5k51uo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 042/168] perf traceevent: Ensure read cmdlines are null terminated.
Date:   Mon, 15 Mar 2021 14:54:34 +0100
Message-Id: <20210315135551.740860511@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Rogers <irogers@google.com>

commit 137a5258939aca56558f3a23eb229b9c4b293917 upstream.

Issue detected by address sanitizer.

Fixes: cd4ceb63438e9e28 ("perf util: Save pid-cmdline mapping into tracing header")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20210226221431.1985458-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/trace-event-read.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -361,6 +361,7 @@ static int read_saved_cmdline(struct tep
 		pr_debug("error reading saved cmdlines\n");
 		goto out;
 	}
+	buf[ret] = '\0';
 
 	parse_saved_cmdline(pevent, buf, size);
 	ret = 0;


