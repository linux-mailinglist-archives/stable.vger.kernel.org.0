Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B452A5689
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733190AbgKCVAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbgKCVAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:00:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A675A2053B;
        Tue,  3 Nov 2020 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437207;
        bh=HbhROBeTj8JFEwQCHgGwraoxKsYOS6u/wa/SLDO1MS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLReTbXRQc+kpWqEYjbHhuOh5khkR+KqyUII9pcckuDWAH3FYZKDpJD68D/UKB1+y
         4Yg1574b501yprZtfn5PbqvjWJr8EH4c78vxIpP9Xso5yiEPZG+6Qihy3RaZQ5GSyZ
         76/kYvzVX7cR3UTyIGbkcoG0u4gv2CfGGoY6xDKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 190/214] ring-buffer: Return 0 on success from ring_buffer_resize()
Date:   Tue,  3 Nov 2020 21:37:18 +0100
Message-Id: <20201103203308.481437673@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit 0a1754b2a97efa644aa6e84d1db5b17c42251483 upstream.

We don't need to check the new buffer size, and the return value
had confused resize_buffer_duplicate_size().
...
	ret = ring_buffer_resize(trace_buf->buffer,
		per_cpu_ptr(size_buf->data,cpu_id)->entries, cpu_id);
	if (ret == 0)
		per_cpu_ptr(trace_buf->data, cpu_id)->entries =
			per_cpu_ptr(size_buf->data, cpu_id)->entries;
...

Link: https://lkml.kernel.org/r/20201019142242.11560-1-hqjagain@gmail.com

Cc: stable@vger.kernel.org
Fixes: d60da506cbeb3 ("tracing: Add a resize function to make one buffer equivalent to another buffer")
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1717,18 +1717,18 @@ int ring_buffer_resize(struct ring_buffe
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long nr_pages;
-	int cpu, err = 0;
+	int cpu, err;
 
 	/*
 	 * Always succeed at resizing a non-existent buffer:
 	 */
 	if (!buffer)
-		return size;
+		return 0;
 
 	/* Make sure the requested buffer exists */
 	if (cpu_id != RING_BUFFER_ALL_CPUS &&
 	    !cpumask_test_cpu(cpu_id, buffer->cpumask))
-		return size;
+		return 0;
 
 	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
@@ -1868,7 +1868,7 @@ int ring_buffer_resize(struct ring_buffe
 	}
 
 	mutex_unlock(&buffer->mutex);
-	return size;
+	return 0;
 
  out_err:
 	for_each_buffer_cpu(buffer, cpu) {


