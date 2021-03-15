Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B3033B747
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhCON77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232575AbhCON7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA1C164EFD;
        Mon, 15 Mar 2021 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816732;
        bh=HSLj3ADQoHdMtr4Dbq/x0gNxUKfHcE5nSbhTXuOcZpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydzFLk1UMWhCw/oEXblArW44c6iEjVips7tQtGeuofPg2KOp5LpJUqX/WGXbe2ERK
         bnIeRzvuLYalJVWTfzkbb3dayKmfct2KpT29sJY/iUtnO78SZqZ/2ZR4Dukk+iLeUZ
         4wzk7WgroIIyjrSwBSl51JMkpJ703/3D9kOIec/o=
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
Subject: [PATCH 4.14 25/95] perf traceevent: Ensure read cmdlines are null terminated.
Date:   Mon, 15 Mar 2021 14:56:55 +0100
Message-Id: <20210315135741.105111568@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
@@ -382,6 +382,7 @@ static int read_saved_cmdline(struct pev
 		pr_debug("error reading saved cmdlines\n");
 		goto out;
 	}
+	buf[ret] = '\0';
 
 	parse_saved_cmdline(pevent, buf, size);
 	ret = 0;


