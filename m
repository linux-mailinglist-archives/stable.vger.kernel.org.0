Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B15CB01
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfGBIKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbfGBIJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C15F2184B;
        Tue,  2 Jul 2019 08:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054960;
        bh=cPDSsm+6I0Sd1FuW39jGtYvPQuqeAXRf69gKjz8StAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmthX0RHGf+FhuTP5Dck7ecgUUYK89WQgaNO3kDRIU1GK7R9f7RFseToh2SPcyxkt
         Ek2OdsKHTIwEEWK0cC0H9XYlUAKX1NZhgiDVcMWRTVvtMaUGW9kiLFnh22LsVNdgT0
         91W/y3Pf9nl7fiL51XaBqtGnAHsjxfc/ac+7iwr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 03/43] perf header: Fix unchecked usage of strncpy()
Date:   Tue,  2 Jul 2019 10:01:43 +0200
Message-Id: <20190702080124.056878518@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 5192bde7d98c99f2cd80225649e3c2e7493722f7 upstream.

The strncpy() function may leave the destination string buffer
unterminated, better use strlcpy() that we have a __weak fallback
implementation for systems without it.

This fixes this warning on an Alpine Linux Edge system with gcc 8.2:

  util/header.c: In function 'perf_event__synthesize_event_update_name':
  util/header.c:3625:2: error: 'strncpy' output truncated before terminating nul copying as many bytes from a string as its length [-Werror=stringop-truncation]
    strncpy(ev->data, evsel->name, len);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  util/header.c:3618:15: note: length computed here
    size_t len = strlen(evsel->name);
                 ^~~~~~~~~~~~~~~~~~~

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: a6e5281780d1 ("perf tools: Add event_update event unit type")
Link: https://lkml.kernel.org/n/tip-wycz66iy8dl2z3yifgqf894p@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/header.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3171,7 +3171,7 @@ perf_event__synthesize_event_update_name
 	if (ev == NULL)
 		return -ENOMEM;
 
-	strncpy(ev->data, evsel->name, len);
+	strlcpy(ev->data, evsel->name, len + 1);
 	err = process(tool, (union perf_event*) ev, NULL, NULL);
 	free(ev);
 	return err;


