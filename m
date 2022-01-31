Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6E64A4378
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359743AbiAaLVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48110 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359155AbiAaLQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC4661234;
        Mon, 31 Jan 2022 11:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24BAC340EE;
        Mon, 31 Jan 2022 11:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627801;
        bh=sinWUBPcepgMXWlm0Ar/8nKT1gvDMz9hj/gu+P1tCg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXBYlisIaLYn+HlNQOqj4YmhtPOl3LqK96vdpYiCBo79aiGQjtWKSBROxc8xNg5sd
         ixZWFatNNphtLDmV3JxCRWWnhsDOJhrZ/6kJUNW0aM03Z4gWWi1b7rIBJI4ybj4+2W
         xlZzgYQ6zVo4YGsGR2sQPDuMztOOYMfoT25m5cj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.16 030/200] tracing/histogram: Fix a potential memory leak for kstrdup()
Date:   Mon, 31 Jan 2022 11:54:53 +0100
Message-Id: <20220131105234.583723810@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

commit e629e7b525a179e29d53463d992bdee759c950fb upstream.

kfree() is missing on an error path to free the memory allocated by
kstrdup():

  p = param = kstrdup(data->params[i], GFP_KERNEL);

So it is better to free it via kfree(p).

Link: https://lkml.kernel.org/r/tencent_C52895FD37802832A3E5B272D05008866F0A@qq.com

Cc: stable@vger.kernel.org
Fixes: d380dcde9a07c ("tracing: Fix now invalid var_ref_vals assumption in trace action")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3919,6 +3919,7 @@ static int trace_action_create(struct hi
 
 			var_ref_idx = find_var_ref_idx(hist_data, var_ref);
 			if (WARN_ON(var_ref_idx < 0)) {
+				kfree(p);
 				ret = var_ref_idx;
 				goto err;
 			}


