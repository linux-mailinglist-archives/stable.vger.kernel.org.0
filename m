Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B4648913F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbiAJHaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiAJH2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF21C028BEE;
        Sun,  9 Jan 2022 23:26:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D8B3611B9;
        Mon, 10 Jan 2022 07:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6097FC36AE9;
        Mon, 10 Jan 2022 07:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799613;
        bh=S9W/8WK5YYTdkSikU45bTJwgwBshs9fphhTu09tAU8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIAozLQChIpb2hVYO6J/skzJiIaPvwzi9AqnHdBrZFdopHwvabYMcrTdEmOFfxWpY
         TPTxN+O5il8Hl89t+Mm01ijP9X6ys8wIzEzx765PgMZjHJegSH+bkRYVTSgxHS8DbH
         vmF7rJboq/rlIjENeCKelmdvQZN0ELag0RQ6ZUCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4.19 02/21] tracing: Tag trace_percpu_buffer as a percpu pointer
Date:   Mon, 10 Jan 2022 08:23:03 +0100
Message-Id: <20220110071814.047265306@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
References: <20220110071813.967414697@linuxfoundation.org>
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
@@ -2812,7 +2812,7 @@ struct trace_buffer_struct {
 	char buffer[4][TRACE_BUF_SIZE];
 };
 
-static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct __percpu *trace_percpu_buffer;
 
 /*
  * Thise allows for lockless recording.  If we're nested too deeply, then
@@ -2841,7 +2841,7 @@ static void put_trace_buf(void)
 
 static int alloc_percpu_trace_buffer(void)
 {
-	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct __percpu *buffers;
 
 	buffers = alloc_percpu(struct trace_buffer_struct);
 	if (WARN(!buffers, "Could not allocate percpu trace_printk buffer"))


