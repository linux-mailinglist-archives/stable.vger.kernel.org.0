Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7365B133420
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgAGVYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgAGVAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977C72187F;
        Tue,  7 Jan 2020 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430846;
        bh=sjZvphU2sU9iwTKg4qjPQsrg1Md0rOLZKbmd+MdG7bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unPrdw4H3CbK7/+cZl0h5femjnD65BpBEhl4QnP+/3L9RO8H8FRcaKDGl+fSHijzy
         c2k8Vqq3a3nDhElgAhbOk2nitLFW+yCCiC6+RD9kHlmNG1VXZE3KvyeOCkcD1fbtba
         /HJiy12LLsZDtFI+8QO2yTqD5gWdjWi5obzqa9Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 119/191] samples/trace_printk: Wait for IRQ work to finish
Date:   Tue,  7 Jan 2020 21:53:59 +0100
Message-Id: <20200107205339.349404185@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 01f36a554e3ef32f9fc4b81a4437cf08fd0e4742 upstream.

trace_printk schedules work via irq_work_queue(), but doesn't
wait until it was processed. The kprobe_module.tc testcase does:

:;: "Load module again, which means the event1 should be recorded";:
modprobe trace-printk
grep "event1:" trace

so the grep which checks the trace file might run before the irq work
was processed. Fix this by adding a irq_work_sync().

Link: http://lore.kernel.org/linux-trace-devel/20191218074427.96184-3-svens@linux.ibm.com

Cc: stable@vger.kernel.org
Fixes: af2a0750f3749 ("selftests/ftrace: Improve kprobe on module testcase to load/unload module")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/trace_printk/trace-printk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/samples/trace_printk/trace-printk.c
+++ b/samples/trace_printk/trace-printk.c
@@ -36,6 +36,7 @@ static int __init trace_printk_init(void
 
 	/* Kick off printing in irq context */
 	irq_work_queue(&irqwork);
+	irq_work_sync(&irqwork);
 
 	trace_printk("This is a %s that will use trace_bprintk()\n",
 		     "static string");


