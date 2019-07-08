Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34A2621DF
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbfGHPUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbfGHPUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:20:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6BCE21537;
        Mon,  8 Jul 2019 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599213;
        bh=Zs8cdzwW/322Rt7NUIextUwtakxIBwPqzOFo9x9q7OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vpw0+SWBVJWAV9D6FrJlIpfNo2EwBwrNwpPuLhB/LYTcT3tygy9KvL3rVyeE2f+3o
         L2nhKkcg0D+WKwxdpmfIXHVh/ft9BE7f4CvcNubpye8Faaq5t81ztHkSpSVoWzeeXC
         h2+hJ8Hlib8RjecVawY7yH4Nv/MqVULy28IAnbbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 039/102] perf header: Fix unchecked usage of strncpy()
Date:   Mon,  8 Jul 2019 17:12:32 +0200
Message-Id: <20190708150528.431360994@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
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
@@ -3027,7 +3027,7 @@ perf_event__synthesize_event_update_name
 	if (ev == NULL)
 		return -ENOMEM;
 
-	strncpy(ev->data, evsel->name, len);
+	strlcpy(ev->data, evsel->name, len + 1);
 	err = process(tool, (union perf_event*) ev, NULL, NULL);
 	free(ev);
 	return err;


