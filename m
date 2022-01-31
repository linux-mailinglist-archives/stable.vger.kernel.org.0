Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA914A4157
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348587AbiAaLDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48590 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358627AbiAaLBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:01:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75149B82A5C;
        Mon, 31 Jan 2022 11:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7DBC340EF;
        Mon, 31 Jan 2022 11:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626905;
        bh=caX1vW/N9Bbrw08pMT4bebAquw6LqUYjL5fAXaW2NgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVy0VqyoPqrUujGZ8+Kx3DtAsyXtgB5UOyBnVkh62E5Mncsd+2hdyUSkKPviP3uHK
         Z2oTV7uHDGLf78JwIoOcGezyNcbFary0zTSMOQIG0TG4/6B1ECStWNVgEevzkTg7MG
         7JaIXnqYcp89zXDQrWWv+nuZlyA2lXMNOcJI/bFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 013/100] tracing/histogram: Fix a potential memory leak for kstrdup()
Date:   Mon, 31 Jan 2022 11:55:34 +0100
Message-Id: <20220131105220.901115801@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
@@ -3506,6 +3506,7 @@ static int trace_action_create(struct hi
 
 			var_ref_idx = find_var_ref_idx(hist_data, var_ref);
 			if (WARN_ON(var_ref_idx < 0)) {
+				kfree(p);
 				ret = var_ref_idx;
 				goto err;
 			}


