Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B34C2A5427
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388509AbgKCVIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388483AbgKCVId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:08:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D7D205ED;
        Tue,  3 Nov 2020 21:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437713;
        bh=nbsVEQ+RxX3+GP5G8rADOxU5BxgGaljK+wNIzPyNnO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnweKyBYeby2jUmOEdCgxoJIzhD1ZURhOy3dsJerBpugb8G63i8PUqy7wuuGMH+2X
         COvOBK2gjSF5Xcd1NpFvorHNZsAx7yfMKK/DFbrhDJay1TT/EJN5SmXIo0AbEUNHSW
         6X9ZE86nCB7mkXXQA6ZoAhncXPGf9jDeMj0C5pjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 171/191] ring-buffer: Return 0 on success from ring_buffer_resize()
Date:   Tue,  3 Nov 2020 21:37:43 +0100
Message-Id: <20201103203248.569720345@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -1692,18 +1692,18 @@ int ring_buffer_resize(struct ring_buffe
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
 
@@ -1843,7 +1843,7 @@ int ring_buffer_resize(struct ring_buffe
 	}
 
 	mutex_unlock(&buffer->mutex);
-	return size;
+	return 0;
 
  out_err:
 	for_each_buffer_cpu(buffer, cpu) {


