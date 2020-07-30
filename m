Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FD4232DBC
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbgG3IOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgG3IMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:12:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A81882074B;
        Thu, 30 Jul 2020 08:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096760;
        bh=0AwPBqkDI7iKUHVOwyCEUJ91cuDwn/VIKn+EZrBZaqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3pNWV6/c4bdyoSbT8q2gfawspDQOHsbcBXcipCY4h+y/Y6M9Qqu3BRRG0Ep5tK26
         Jjy/jQ3NXQ22aV8TQ884sfXaZQKFIlotPzHZYrY8owfU54Ymo+F/uq2kLyv/BWGhl/
         wWoKC8KwmgL467hIgJHcM2NwE0IUFrRloumQ4Yd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 50/54] tools/lib/subcmd/pager.c: do not alias select() params
Date:   Thu, 30 Jul 2020 10:05:29 +0200
Message-Id: <20200730074423.593109847@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/pager.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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


