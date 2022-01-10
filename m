Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AC5489153
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbiAJHbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbiAJH23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B519C028BDF;
        Sun,  9 Jan 2022 23:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32693B81214;
        Mon, 10 Jan 2022 07:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0FDC36AED;
        Mon, 10 Jan 2022 07:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799579;
        bh=HGUOliIm3pe8giQ4Qy/VFmMBa4H9I3QQbmLzloWAdKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMRp8ljbO5NsxEwF1oaLXgPpHLoFOrh+OSesxyAXtFg1oseCXwWejGEvs25olegGu
         ZBYMsl6XKNoiFcD0nWoVNRSqHOzS2gbzdGv3lV1EmAZVjZQiB6rBbdH2HNJEUIzRZv
         bgdex5NbsztezbuS4TwL+gnowOLFd9MQw3SlE9kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4.14 03/22] tracing: Tag trace_percpu_buffer as a percpu pointer
Date:   Mon, 10 Jan 2022 08:22:56 +0100
Message-Id: <20220110071814.379852234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071814.261471354@linuxfoundation.org>
References: <20220110071814.261471354@linuxfoundation.org>
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
@@ -2810,7 +2810,7 @@ struct trace_buffer_struct {
 	char buffer[4][TRACE_BUF_SIZE];
 };
 
-static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct __percpu *trace_percpu_buffer;
 
 /*
  * Thise allows for lockless recording.  If we're nested too deeply, then
@@ -2839,7 +2839,7 @@ static void put_trace_buf(void)
 
 static int alloc_percpu_trace_buffer(void)
 {
-	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct __percpu *buffers;
 
 	buffers = alloc_percpu(struct trace_buffer_struct);
 	if (WARN(!buffers, "Could not allocate percpu trace_printk buffer"))


