Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378784A411C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358686AbiAaLCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358448AbiAaLBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:01:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCA2C0617A3;
        Mon, 31 Jan 2022 02:59:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B050D60B28;
        Mon, 31 Jan 2022 10:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9528EC340E8;
        Mon, 31 Jan 2022 10:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626787;
        bh=pF66JUufhVkGFO/oRzhbn0auR3ADePKpbz05UIfv6Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQvocjqAp0aSMXxKfueBwlhfhtd3APxqZkXpguW2GMtISYFSCthG0LFerQw5nCTf4
         WKUgJv3cYw8eSW9FutmzfgNutcANsBIJd3lqgRIAHAaHApUCcTVlHxqgXlYVAJSaWs
         kZxO96vOrTBlf19WHKDwwp/pLfOFEsS4A2na/5HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 07/64] tracing/histogram: Fix a potential memory leak for kstrdup()
Date:   Mon, 31 Jan 2022 11:55:52 +0100
Message-Id: <20220131105215.899357792@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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
@@ -4398,6 +4398,7 @@ static int trace_action_create(struct hi
 
 			var_ref_idx = find_var_ref_idx(hist_data, var_ref);
 			if (WARN_ON(var_ref_idx < 0)) {
+				kfree(p);
 				ret = var_ref_idx;
 				goto err;
 			}


