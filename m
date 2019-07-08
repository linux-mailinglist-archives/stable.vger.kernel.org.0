Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7F6219A
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732887AbfGHPRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbfGHPRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:17:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88E6216C4;
        Mon,  8 Jul 2019 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599064;
        bh=A3B+CCe3/MsWOjNTZZQCMTN4wd4E3BxnZap+XVg5Xew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLhk2dhxRl9B9ZHxxLXKwzrpblKTAUCEmfCGxhRJ+FUN1A9b950KdsXebcWQmwW6q
         Y690i+S8veWtCIJtLT1Y97aimmYf9+cTJN9F4QbFyKbxJ+UKGnwjjwEWjCG2FwI/Ik
         Kv05fvGbZJB2VQWcl2LYZzU7eH2b/mTHPrYClIUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.4 30/73] perf help: Remove needless use of strncpy()
Date:   Mon,  8 Jul 2019 17:12:40 +0200
Message-Id: <20190708150522.770686017@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
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
@@ -179,7 +179,7 @@ static void add_man_viewer(const char *n
 	while (*p)
 		p = &((*p)->next);
 	*p = zalloc(sizeof(**p) + len + 1);
-	strncpy((*p)->name, name, len);
+	strcpy((*p)->name, name);
 }
 
 static int supported_man_viewer(const char *name, size_t len)


