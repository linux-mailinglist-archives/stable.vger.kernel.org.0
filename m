Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DBC489167
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240630AbiAJHbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56806 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240360AbiAJH34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93FA1B81202;
        Mon, 10 Jan 2022 07:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FB5C36AE9;
        Mon, 10 Jan 2022 07:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799794;
        bh=IsNMZc8RKQRSTDpyDsA1lnZ9piQv3Yrxyp9sRVEBJlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nrJhzfmzjbtD/bT14DnXuV/3JjOQtStMJH2J3r5p19uzFPN2Gas/+2JfYAA72Tgc
         4m4Rc5W/AZ/cFhO0nuGo+5ClHEgxvuk/Uf1qkdzaF12yJ/BNbSDDT7XjproFnZsbJ8
         Kd5ziiUHRQ30eHusinSQmF0yS2ksvvTaS4jVg8R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 04/43] tracing: Tag trace_percpu_buffer as a percpu pointer
Date:   Mon, 10 Jan 2022 08:23:01 +0100
Message-Id: <20220110071817.479474258@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit f28439db470cca8b6b082239314e9fd10bd39034 upstream.

Tag trace_percpu_buffer as a percpu pointer to resolve warnings
reported by sparse:
  /linux/kernel/trace/trace.c:3218:46: warning: incorrect type in initializer (different address spaces)
  /linux/kernel/trace/trace.c:3218:46:    expected void const [noderef] __percpu *__vpp_verify
  /linux/kernel/trace/trace.c:3218:46:    got struct trace_buffer_struct *
  /linux/kernel/trace/trace.c:3234:9: warning: incorrect type in initializer (different address spaces)
  /linux/kernel/trace/trace.c:3234:9:    expected void const [noderef] __percpu *__vpp_verify
  /linux/kernel/trace/trace.c:3234:9:    got int *

Link: https://lkml.kernel.org/r/ebabd3f23101d89cb75671b68b6f819f5edc830b.1640255304.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 07d777fe8c398 ("tracing: Add percpu buffers for trace_printk()")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3134,7 +3134,7 @@ struct trace_buffer_struct {
 	char buffer[4][TRACE_BUF_SIZE];
 };
 
-static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct __percpu *trace_percpu_buffer;
 
 /*
  * Thise allows for lockless recording.  If we're nested too deeply, then
@@ -3163,7 +3163,7 @@ static void put_trace_buf(void)
 
 static int alloc_percpu_trace_buffer(void)
 {
-	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct __percpu *buffers;
 
 	if (trace_percpu_buffer)
 		return 0;


