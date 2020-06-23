Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78846206347
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgFWUVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390023AbgFWUVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:21:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 906B92064B;
        Tue, 23 Jun 2020 20:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943678;
        bh=SFFRbZ2VPfm2mLXXakBHghxCO8Wy7+UxQfrCa/9mkzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irTMTPKMUkOMI9Ru8N33Y9k8rYN4m+zm6gAjOtDQHHeHJgih791qo2YO5rvCxneH9
         TJC/4JIG0ffxy9fay643SATkzr97spzXbdYXQR6ZpH7eB41sCCAaiJ62CbDVGCBvYQ
         pgpddtbh6ri23dpP3CF3EJNrW+FMvieJG41ygXHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Indi <divya.indi@oracle.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.7 467/477] sample-trace-array: Remove trace_array sample-instance
Date:   Tue, 23 Jun 2020 21:57:44 +0200
Message-Id: <20200623195429.622872957@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 9fbc01cdba66e988122ccdc6094cfd85d9587769 upstream.

Remove trace_array 'sample-instance' if kthread_run fails
in sample_trace_array_init().

Link: https://lkml.kernel.org/r/20200609135200.2206726-1-wangkefeng.wang@huawei.com

Cc: stable@vger.kernel.org
Fixes: 89ed42495ef4a ("tracing: Sample module to demonstrate kernel access to Ftrace instances.")
Reviewed-by: Divya Indi <divya.indi@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/ftrace/sample-trace-array.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/samples/ftrace/sample-trace-array.c
+++ b/samples/ftrace/sample-trace-array.c
@@ -107,8 +107,12 @@ static int __init sample_trace_array_ini
 	trace_printk_init_buffers();
 
 	simple_tsk = kthread_run(simple_thread, NULL, "sample-instance");
-	if (IS_ERR(simple_tsk))
+	if (IS_ERR(simple_tsk)) {
+		trace_array_put(tr);
+		trace_array_destroy(tr);
 		return -1;
+	}
+
 	return 0;
 }
 


