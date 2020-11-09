Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F8A2ABA8D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733110AbgKINUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387925AbgKINUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6006420731;
        Mon,  9 Nov 2020 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928019;
        bh=Sg5nBRuNwWbX4eBpaGXlIk1GL/jH5nUeaGsE0BNPZKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZk8NYjShA3Ggm5ATpoxXrbW4wPfrTBsotX110ZV2zMMJd/Z8ZkUKT0UrjGjD4+tC
         NRdLmfkzLd8zICnsYttcdOA1D0/ZhDJD2x21cnO/vxiHzmoVQKFZ+9RRVwy8svA+1M
         x5x/MBby6eu/GxGNXkT5h6TZKSZ/94J86afEHlKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 069/133] tracing: Fix out of bounds write in get_trace_buf
Date:   Mon,  9 Nov 2020 13:55:31 +0100
Message-Id: <20201109125034.053522275@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit c1acb4ac1a892cf08d27efcb964ad281728b0545 upstream.

The nesting count of trace_printk allows for 4 levels of nesting. The
nesting counter starts at zero and is incremented before being used to
retrieve the current context's buffer. But the index to the buffer uses the
nesting counter after it was incremented, and not its original number,
which in needs to do.

Link: https://lkml.kernel.org/r/20201029161905.4269-1-hqjagain@gmail.com

Cc: stable@vger.kernel.org
Fixes: 3d9622c12c887 ("tracing: Add barrier to trace_printk() buffer nesting modification")
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3114,7 +3114,7 @@ static char *get_trace_buf(void)
 
 	/* Interrupts must see nesting incremented before we use the buffer */
 	barrier();
-	return &buffer->buffer[buffer->nesting][0];
+	return &buffer->buffer[buffer->nesting - 1][0];
 }
 
 static void put_trace_buf(void)


