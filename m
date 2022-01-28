Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C6249FDEE
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 17:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350074AbiA1QXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 11:23:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59240 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350068AbiA1QXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 11:23:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D4B61F2C;
        Fri, 28 Jan 2022 16:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEF5C340E6;
        Fri, 28 Jan 2022 16:23:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nDU2L-00AT3c-8a;
        Fri, 28 Jan 2022 11:23:45 -0500
Message-ID: <20220128162345.094566906@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 28 Jan 2022 11:18:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>
Subject: [for-linus][PATCH 10/10] tracing: Dont inc err_log entry count if entry allocation fails
References: <20220128161802.711119424@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

tr->n_err_log_entries should only be increased if entry allocation
succeeds.

Doing it when it fails won't cause any problems other than wasting an
entry, but should be fixed anyway.

Link: https://lkml.kernel.org/r/cad1ab28f75968db0f466925e7cba5970cec6c29.1643319703.git.zanussi@kernel.org

Cc: stable@vger.kernel.org
Fixes: 2f754e771b1a6 ("tracing: Don't inc err_log entry count if entry allocation fails")
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a569a0cb81ee..c860f582b078 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7740,7 +7740,8 @@ static struct tracing_log_err *get_tracing_log_err(struct trace_array *tr)
 		err = kzalloc(sizeof(*err), GFP_KERNEL);
 		if (!err)
 			err = ERR_PTR(-ENOMEM);
-		tr->n_err_log_entries++;
+		else
+			tr->n_err_log_entries++;
 
 		return err;
 	}
-- 
2.33.0
