Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3E3275ABB
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 16:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIWOuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 10:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgIWOuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 10:50:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081A1221E7;
        Wed, 23 Sep 2020 14:50:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kL66b-0027Sn-V7; Wed, 23 Sep 2020 10:50:49 -0400
Message-ID: <20200923145049.843559624@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 23 Sep 2020 10:50:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 2/4] lib/bootconfig: Fix to remove tailing spaces after value
References: <20200923145012.819775042@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Fix to remove tailing spaces after value. If there is a space
after value, the bootconfig failed to remove it because it
applies strim() before replacing the delimiter with null.

For example,

foo = var    # comment

was parsed as below.

foo="var    "

but user will expect

foo="var"

This fixes it by applying strim() after removing the delimiter.

Link: https://lkml.kernel.org/r/160068149134.1088739.8868306567670058853.stgit@devnote2

Fixes: 76db5a27a827 ("bootconfig: Add Extra Boot Config support")
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/bootconfig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bootconfig.c b/lib/bootconfig.c
index b44bba0f1583..649ed44f199c 100644
--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -494,8 +494,8 @@ static int __init __xbc_parse_value(char **__v, char **__n)
 			break;
 		}
 		if (strchr(",;\n#}", c)) {
-			v = strim(v);
 			*p++ = '\0';
+			v = strim(v);
 			break;
 		}
 	}
-- 
2.28.0


