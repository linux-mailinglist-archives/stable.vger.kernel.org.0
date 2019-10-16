Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15465DA07B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407333AbfJPWL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395380AbfJPV4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:35 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BD5D21A49;
        Wed, 16 Oct 2019 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262994;
        bh=ZMCX9A9XKGm5q/+zflXd5y5AjLNg4mDznV7taU+wOc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNwZUPxiLSBgiWVmfxG2eb91nR3dw4jfFDQ1ZXDD35h1Q+ld3T7++wr9oKTy38jWd
         98NfJuzp81OGyCUE2A6mqnp0YK9dYUPxOtxVvKX96YakaEbvYPr3ANtOSqAfCOuWO/
         Q3pKuvtpaCtf9i+/aR5pRm4Tgjmei+3cSbQRskSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 62/65] ftrace: Get a reference counter for the trace_array on filter files
Date:   Wed, 16 Oct 2019 14:51:16 -0700
Message-Id: <20191016214839.912090427@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 9ef16693aff8137faa21d16ffe65bb9832d24d71 upstream.

The ftrace set_ftrace_filter and set_ftrace_notrace files are specific for
an instance now. They need to take a reference to the instance otherwise
there could be a race between accessing the files and deleting the instance.

It wasn't until the :mod: caching where these file operations started
referencing the trace_array directly.

Cc: stable@vger.kernel.org
Fixes: 673feb9d76ab3 ("ftrace: Add :mod: caching infrastructure to trace_array")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3629,21 +3629,22 @@ ftrace_regex_open(struct ftrace_ops *ops
 	struct ftrace_hash *hash;
 	struct list_head *mod_head;
 	struct trace_array *tr = ops->private;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	ftrace_ops_init(ops);
 
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
+	if (tr && trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
-		return -ENOMEM;
+		goto out;
 
-	if (trace_parser_get_init(&iter->parser, FTRACE_BUFF_MAX)) {
-		kfree(iter);
-		return -ENOMEM;
-	}
+	if (trace_parser_get_init(&iter->parser, FTRACE_BUFF_MAX))
+		goto out;
 
 	iter->ops = ops;
 	iter->flags = flag;
@@ -3673,13 +3674,13 @@ ftrace_regex_open(struct ftrace_ops *ops
 
 		if (!iter->hash) {
 			trace_parser_put(&iter->parser);
-			kfree(iter);
-			ret = -ENOMEM;
 			goto out_unlock;
 		}
 	} else
 		iter->hash = hash;
 
+	ret = 0;
+
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
 
@@ -3691,7 +3692,6 @@ ftrace_regex_open(struct ftrace_ops *ops
 			/* Failed */
 			free_ftrace_hash(iter->hash);
 			trace_parser_put(&iter->parser);
-			kfree(iter);
 		}
 	} else
 		file->private_data = iter;
@@ -3699,6 +3699,13 @@ ftrace_regex_open(struct ftrace_ops *ops
  out_unlock:
 	mutex_unlock(&ops->func_hash->regex_lock);
 
+ out:
+	if (ret) {
+		kfree(iter);
+		if (tr)
+			trace_array_put(tr);
+	}
+
 	return ret;
 }
 
@@ -5098,6 +5105,8 @@ int ftrace_regex_release(struct inode *i
 
 	mutex_unlock(&iter->ops->func_hash->regex_lock);
 	free_ftrace_hash(iter->hash);
+	if (iter->tr)
+		trace_array_put(iter->tr);
 	kfree(iter);
 
 	return 0;


