Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6278D212394
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 14:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgGBMmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 08:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbgGBMmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 08:42:22 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2615020885;
        Thu,  2 Jul 2020 12:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593693742;
        bh=GmaO+M/a1fel3w8zVOsBwLIVCGwMuG1WwQvgaJ/HfX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIll8EK3BJ9T7RXtDs3jecyJeUcWT/jt+78Vl8fl9C39ctG+dGgrjtfTX7m7XEdmn
         rMIuAQXPmUXMhzfbVhar0Iy3OLedFSIB+oW5SH5hG7Yubg2Ia3Cb2SLVrIFP1vLJgl
         sCONdQLgf8C6/REykyzYy1IhJGs22qm2fy8eaFM4=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.4.y 5/5] tools/lib/subcmd/pager.c: do not alias select() params
Date:   Thu,  2 Jul 2020 21:42:18 +0900
Message-Id: <159369373879.82195.6388245474703207993.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159369369207.82195.5763005209795799082.stgit@devnote2>
References: <159369369207.82195.5763005209795799082.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

commit dfbc3c6cb747c074aa2ba0a10bbeea588d6dfda6 upstream.

[ Change applied file from tools/lib/subcmd/pager.c to
  tools/perf/util/pager.c ]

Use a separate fd set for select()-s exception fds param to fix the
following gcc warning:

  pager.c:36:12: error: passing argument 2 to restrict-qualified parameter aliases with argument 4 [-Werror=restrict]
    select(1, &in, NULL, &in, NULL);
              ^~~        ~~~

Link: http://lkml.kernel.org/r/20180101105626.7168-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 tools/perf/util/pager.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 53ef006a951c..b301d779c4af 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -16,10 +16,13 @@ static void pager_preexec(void)
 	 * have real input
 	 */
 	fd_set in;
+	fd_set exception;
 
 	FD_ZERO(&in);
+	FD_ZERO(&exception);
 	FD_SET(0, &in);
-	select(1, &in, NULL, &in, NULL);
+	FD_SET(0, &exception);
+	select(1, &in, NULL, &exception, NULL);
 
 	setenv("LESS", "FRSX", 0);
 }

