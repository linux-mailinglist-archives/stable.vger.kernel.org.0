Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC72DA90E2
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390076AbfIDSMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390483AbfIDSMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:12:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E83BE2342D;
        Wed,  4 Sep 2019 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620739;
        bh=x/WeZNDH/QogmYMB8vO8JSZVG8MaOjBi/IHIHjPRTpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUpYoB7Oilm7BWeY6HxDkiaL6dXCtuPR+z9BAafYQUR2lQtrGR8gcabHGBNuySpIa
         SGnX7fdc3xkuTupFTqaGCkcFxO3WGdIcdIV3R19rEM0u7+0u3w4myYuqE9VULws8IL
         1S4DZSRBCySuUtgQ1GaqT5zdVyzTwYhXEnN+wjFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.2 077/143] ftrace: Check for empty hash and comment the race with registering probes
Date:   Wed,  4 Sep 2019 19:53:40 +0200
Message-Id: <20190904175317.069218013@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
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
@@ -3096,7 +3096,11 @@ t_probe_next(struct seq_file *m, loff_t
 
 	hash = iter->probe->ops.func_hash->filter_hash;
 
-	if (!hash)
+	/*
+	 * A probe being registered may temporarily have an empty hash
+	 * and it's at the end of the func_probes list.
+	 */
+	if (!hash || hash == EMPTY_HASH)
 		return NULL;
 
 	size = 1 << hash->size_bits;
@@ -4324,6 +4328,10 @@ register_ftrace_function_probe(char *glo
 
 	mutex_unlock(&ftrace_lock);
 
+	/*
+	 * Note, there's a small window here that the func_hash->filter_hash
+	 * may be NULL or empty. Need to be carefule when reading the loop.
+	 */
 	mutex_lock(&probe->ops.func_hash->regex_lock);
 
 	orig_hash = &probe->ops.func_hash->filter_hash;


