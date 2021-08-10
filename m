Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859273E806D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhHJRsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236222AbhHJRq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11CFE61205;
        Tue, 10 Aug 2021 17:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617247;
        bh=TJODZfoAYA3RjHfN0cW75/6oU4OUeKSGaJcJUgPBnSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9OhdmvZrc9otTBtNi7X1Hsy3PC0QbVweISg7NTX5KeRjZ777lLfoHLrk4bP7h5TD
         8YT/ZNZhOeUtgFVZHdFhy0ck791EDGxFadhlH11RAWvUtHLHVPrOWE4r/LAkjKbXIB
         4OYyDJYD/Vw+rXeN164E2ksLjdsD1xGrgk8iqArs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Agrawal <kamaagra@codeaurora.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 077/135] tracing: Fix NULL pointer dereference in start_creating
Date:   Tue, 10 Aug 2021 19:30:11 +0200
Message-Id: <20210810172958.348192105@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Agrawal <kamaagra@codeaurora.org>

commit ff41c28c4b54052942180d8b3f49e75f1445135a upstream.

The event_trace_add_tracer() can fail. In this case, it leads to a crash
in start_creating with below call stack. Handle the error scenario
properly in trace_array_create_dir.

Call trace:
down_write+0x7c/0x204
start_creating.25017+0x6c/0x194
tracefs_create_file+0xc4/0x2b4
init_tracer_tracefs+0x5c/0x940
trace_array_create_dir+0x58/0xb4
trace_array_create+0x1bc/0x2b8
trace_array_get_by_name+0xdc/0x18c

Link: https://lkml.kernel.org/r/1627651386-21315-1-git-send-email-kamaagra@codeaurora.org

Cc: stable@vger.kernel.org
Fixes: 4114fbfd02f1 ("tracing: Enable creating new instance early boot")
Signed-off-by: Kamal Agrawal <kamaagra@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8683,8 +8683,10 @@ static int trace_array_create_dir(struct
 		return -EINVAL;
 
 	ret = event_trace_add_tracer(tr->dir, tr);
-	if (ret)
+	if (ret) {
 		tracefs_remove(tr->dir);
+		return ret;
+	}
 
 	init_tracer_tracefs(tr, tr->dir);
 	__update_tracer_options(tr);


