Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3831B621D7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbfGHPUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387559AbfGHPUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:20:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8917216E3;
        Mon,  8 Jul 2019 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599201;
        bh=KiZuEvMSoBsV+mDdfasJI0QBkDFKWHXCceVrDCbB6Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YltYqutP6hRuZDABkLdsrz3JbF5it2wuK/V7LwHmdV7D5OaTVKihGoIC7WSm7DYHO
         v3N1t1IMAUMduHYuDUAUEJSR4JUPxxvXccnmpX4Bo+nTB4AMhr1PmUvAO296q0HYmN
         mHVF4OTrhFAL4+m/us7OTWJxd1ahxRrv7/68cL5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 038/102] perf help: Remove needless use of strncpy()
Date:   Mon,  8 Jul 2019 17:12:31 +0200
Message-Id: <20190708150528.380876795@linuxfoundation.org>
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

commit b6313899f4ed2e76b8375cf8069556f5b94fbff0 upstream.

Since we make sure the destination buffer has at least strlen(orig) + 1,
no need to do a strncpy(dest, orig, strlen(orig)), just use strcpy(dest,
orig).

This silences this gcc 8.2 warning on Alpine Linux:

  In function 'add_man_viewer',
      inlined from 'perf_help_config' at builtin-help.c:284:3:
  builtin-help.c:192:2: error: 'strncpy' output truncated before terminating nul copying as many bytes from a string as its length [-Werror=stringop-truncation]
    strncpy((*p)->name, name, len);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  builtin-help.c: In function 'perf_help_config':
  builtin-help.c:187:15: note: length computed here
    size_t len = strlen(name);
                 ^~~~~~~~~~~~

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: 078006012401 ("perf_counter tools: add in basic glue from Git")
Link: https://lkml.kernel.org/n/tip-2f69l7drca427ob4km8i7kvo@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-help.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -186,7 +186,7 @@ static void add_man_viewer(const char *n
 	while (*p)
 		p = &((*p)->next);
 	*p = zalloc(sizeof(**p) + len + 1);
-	strncpy((*p)->name, name, len);
+	strcpy((*p)->name, name);
 }
 
 static int supported_man_viewer(const char *name, size_t len)


