Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95DA8F6C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbfIDSDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388956AbfIDSDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:03:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ED6C208E4;
        Wed,  4 Sep 2019 18:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620211;
        bh=uWau4UVr/jQS6w/7RWJAvd2wgRb354hoWcMHAVn+aDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAX/trCqivDlfcJUJdQ5frT0cgg5quljlEKchG2jLh9c+55xrC+rKUQPXB0wQvT/k
         A4dVwgCn5WHEbWjokwhMrHtCBRvOXlQlGJnkO5lBMz9zpDNHgEuuMHIa7DqkJnmsuC
         +ACn2jD0CKo29FfYZ78JeOmlK/i1T543pIvfjYio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 30/57] ftrace: Check for empty hash and comment the race with registering probes
Date:   Wed,  4 Sep 2019 19:53:58 +0200
Message-Id: <20190904175304.888105763@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 372e0d01da71c84dcecf7028598a33813b0d5256 upstream.

The race between adding a function probe and reading the probes that exist
is very subtle. It needs a comment. Also, the issue can also happen if the
probe has has the EMPTY_HASH as its func_hash.

Cc: stable@vger.kernel.org
Fixes: 7b60f3d876156 ("ftrace: Dynamically create the probe ftrace_ops for the trace_array")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3185,7 +3185,11 @@ t_probe_next(struct seq_file *m, loff_t
 
 	hash = iter->probe->ops.func_hash->filter_hash;
 
-	if (!hash)
+	/*
+	 * A probe being registered may temporarily have an empty hash
+	 * and it's at the end of the func_probes list.
+	 */
+	if (!hash || hash == EMPTY_HASH)
 		return NULL;
 
 	size = 1 << hash->size_bits;
@@ -4384,6 +4388,10 @@ register_ftrace_function_probe(char *glo
 
 	mutex_unlock(&ftrace_lock);
 
+	/*
+	 * Note, there's a small window here that the func_hash->filter_hash
+	 * may be NULL or empty. Need to be carefule when reading the loop.
+	 */
 	mutex_lock(&probe->ops.func_hash->regex_lock);
 
 	orig_hash = &probe->ops.func_hash->filter_hash;


