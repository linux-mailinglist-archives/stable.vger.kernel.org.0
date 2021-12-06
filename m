Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886F4469E83
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377526AbhLFPjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379019AbhLFPgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D852C08EACD;
        Mon,  6 Dec 2021 07:22:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D65D6133C;
        Mon,  6 Dec 2021 15:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7EEC341C5;
        Mon,  6 Dec 2021 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804161;
        bh=6M1DrmYjg6Bm8AXLmemc8UGMz0PjPuEeuy9tlqFORuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Nrg1LdaSBz5Q4qs2bqCxFWwy7woYoi8K7zEBOUVB2sqj373vmnlAgzV1pl7LQYAD
         jZ/JD3QtLq8kc2GKtuXWTVdAwJa2ubClPC/RjU00zhfjj8+uTfqa+uwwnunscHA2z7
         gwQKBEtlyuZDp4o3yN2GTFTlUh9MEz9Tn+jgNOEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/207] tracing: Dont use out-of-sync va_list in event printing
Date:   Mon,  6 Dec 2021 15:55:03 +0100
Message-Id: <20211206145611.920517755@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>

[ Upstream commit 2ef75e9bd2c998f1c6f6f23a3744136105ddefd5 ]

If trace_seq becomes full, trace_seq_vprintf() no longer consumes
arguments from va_list, making va_list out of sync with format
processing by trace_check_vprintf().

This causes va_arg() in trace_check_vprintf() to return wrong
positional argument, which results into a WARN_ON_ONCE() hit.

ftrace_stress_test from LTP triggers this situation.

Fix it by explicitly avoiding further use if va_list at the point
when it's consistency can no longer be guaranteed.

Link: https://lkml.kernel.org/r/20211118145516.13219-1-nikita.yushchenko@virtuozzo.com

Signed-off-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5e452dd57af01..18db461f77cdf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3836,6 +3836,18 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		iter->fmt[i] = '\0';
 		trace_seq_vprintf(&iter->seq, iter->fmt, ap);
 
+		/*
+		 * If iter->seq is full, the above call no longer guarantees
+		 * that ap is in sync with fmt processing, and further calls
+		 * to va_arg() can return wrong positional arguments.
+		 *
+		 * Ensure that ap is no longer used in this case.
+		 */
+		if (iter->seq.full) {
+			p = "";
+			break;
+		}
+
 		if (star)
 			len = va_arg(ap, int);
 
-- 
2.33.0



