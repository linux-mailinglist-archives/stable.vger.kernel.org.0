Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2FF27375E
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 02:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgIVA1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 20:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgIVA1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 20:27:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D52623AA3;
        Tue, 22 Sep 2020 00:27:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kKW96-001rbf-En; Mon, 21 Sep 2020 20:27:00 -0400
Message-ID: <20200922002700.338682785@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 21 Sep 2020 20:26:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Tom Rix <trix@redhat.com>
Subject: [for-linus][PATCH 6/8] tracing: fix double free
References: <20200922002620.231334654@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analyzer reports this problem

trace_events_hist.c:3824:3: warning: Attempt to free
  released memory
    kfree(hist_data->attrs->var_defs.name[i]);

In parse_var_defs() if there is a problem allocating
var_defs.expr, the earlier var_defs.name is freed.
This free is duplicated by free_var_defs() which frees
the rest of the list.

Because free_var_defs() has to run anyway, remove the
second free fom parse_var_defs().

Link: https://lkml.kernel.org/r/20200907135845.15804-1-trix@redhat.com

Cc: stable@vger.kernel.org
Fixes: 30350d65ac56 ("tracing: Add variable support to hist triggers")
Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 0b933546142e..1b2ef6490229 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3865,7 +3865,6 @@ static int parse_var_defs(struct hist_trigger_data *hist_data)
 
 			s = kstrdup(field_str, GFP_KERNEL);
 			if (!s) {
-				kfree(hist_data->attrs->var_defs.name[n_vars]);
 				ret = -ENOMEM;
 				goto free;
 			}
-- 
2.28.0


