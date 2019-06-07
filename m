Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F4390AE
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbfFGPrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbfFGPrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E0A20657;
        Fri,  7 Jun 2019 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922458;
        bh=/dSKHomfInZL/wJonGRmHMQubPsbLli2SZ/mcO/4lCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzmpy1VEqr1JnZs74JfkJa/S4Av6zcAQhketjo6CC37h2CSy/7h4r7omxtPC7CkJv
         aCKAdye3PSAU08pc9MilBxRrFI3Nu1M2StwOh8YGhxbIdeeqFaMaYi8gqtM2mC/DF7
         HAPMfDY4/u7rBDj62BvueLv+0k/bDEPh+OOXvK4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6b8e0fb820e570c59e19@syzkaller.appspotmail.com,
        Tomas Bortoli <tomasbortoli@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.1 20/85] tracing: Avoid memory leak in predicate_parse()
Date:   Fri,  7 Jun 2019 17:39:05 +0200
Message-Id: <20190607153851.722507454@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Bortoli <tomasbortoli@gmail.com>

commit dfb4a6f2191a80c8b790117d0ff592fd712d3296 upstream.

In case of errors, predicate_parse() goes to the out_free label
to free memory and to return an error code.

However, predicate_parse() does not free the predicates of the
temporary prog_stack array, thence leaking them.

Link: http://lkml.kernel.org/r/20190528154338.29976-1-tomasbortoli@gmail.com

Cc: stable@vger.kernel.org
Fixes: 80765597bc587 ("tracing: Rewrite filter logic to be simpler and faster")
Reported-by: syzbot+6b8e0fb820e570c59e19@syzkaller.appspotmail.com
Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
[ Added protection around freeing prog_stack[i].pred ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_filter.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -427,7 +427,7 @@ predicate_parse(const char *str, int nr_
 	op_stack = kmalloc_array(nr_parens, sizeof(*op_stack), GFP_KERNEL);
 	if (!op_stack)
 		return ERR_PTR(-ENOMEM);
-	prog_stack = kmalloc_array(nr_preds, sizeof(*prog_stack), GFP_KERNEL);
+	prog_stack = kcalloc(nr_preds, sizeof(*prog_stack), GFP_KERNEL);
 	if (!prog_stack) {
 		parse_error(pe, -ENOMEM, 0);
 		goto out_free;
@@ -578,7 +578,11 @@ predicate_parse(const char *str, int nr_
 out_free:
 	kfree(op_stack);
 	kfree(inverts);
-	kfree(prog_stack);
+	if (prog_stack) {
+		for (i = 0; prog_stack[i].pred; i++)
+			kfree(prog_stack[i].pred);
+		kfree(prog_stack);
+	}
 	return ERR_PTR(ret);
 }
 


