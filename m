Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C212B36F573
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 07:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3Foi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 01:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3Foh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 01:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF172613E1;
        Fri, 30 Apr 2021 05:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619761430;
        bh=Cxb6f0NFeIXoTIzOwIzoIyf/7gzBsPSQZxWmBcfnH8I=;
        h=Subject:To:From:Date:From;
        b=YZLL+v2V9yLQz/6UqMxyNp8F8eaJuCViX+RWeIMkLx6Ej9aT2cHuVlfmS66xgrdp1
         RgRyX/+Ug0wKojBNByQd+hVI1ZJtAapMb4BWBsdwIkcEdrsGJpeaDsEBJuY3UGyw+y
         Cmd0FmM8VkZ/zPV+fqB1hgni3XEO9grkeeTgNWs4=
Subject: patch "dyndbg: fix parsing file query without a line-range suffix" added to char-misc-linus
To:     shuochen@google.com, edumazet@google.com,
        gregkh@linuxfoundation.org, jbaron@akamai.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 30 Apr 2021 07:43:48 +0200
Message-ID: <161976142825259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    dyndbg: fix parsing file query without a line-range suffix

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7b1ae248279bea33af9e797a93c35f49601cb8a0 Mon Sep 17 00:00:00 2001
From: Shuo Chen <shuochen@google.com>
Date: Wed, 14 Apr 2021 14:24:00 -0700
Subject: dyndbg: fix parsing file query without a line-range suffix

Query like 'file tcp_input.c line 1234 +p' was broken by
commit aaebe329bff0 ("dyndbg: accept 'file foo.c:func1' and 'file
foo.c:10-100'") because a file name without a ':' now makes the loop in
ddebug_parse_query() exits early before parsing the 'line 1234' part.
As a result, all pr_debug() in tcp_input.c will be enabled, instead of only
the one on line 1234.  Changing 'break' to 'continue' fixes this.

Fixes: aaebe329bff0 ("dyndbg: accept 'file foo.c:func1' and 'file foo.c:10-100'")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Shuo Chen <shuochen@google.com>
Acked-by: Jason Baron <jbaron@akamai.com>
Link: https://lore.kernel.org/r/20210414212400.2927281-1-giantchen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/dynamic_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c70d6347afa2..921d0a654243 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -396,7 +396,7 @@ static int ddebug_parse_query(char *words[], int nwords,
 			/* tail :$info is function or line-range */
 			fline = strchr(query->filename, ':');
 			if (!fline)
-				break;
+				continue;
 			*fline++ = '\0';
 			if (isalpha(*fline) || *fline == '*' || *fline == '?') {
 				/* take as function name */
-- 
2.31.1


