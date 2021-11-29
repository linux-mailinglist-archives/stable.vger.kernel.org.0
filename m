Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13D461DC6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378100AbhK2S3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60386 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378241AbhK2S1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C505B815C3;
        Mon, 29 Nov 2021 18:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86EBC53FAD;
        Mon, 29 Nov 2021 18:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210240;
        bh=eOBE9rN6BA+5Z4RsBbrqrbKjZS+2LWioD2bBVZ3nVN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G871gf0ghaPtERLa6WG9HvQUrnw8IDl5L1WRFeHHYDSvqV6PMivM+KopgijIKFE1q
         +RI0fL6RACUSnjwo27Q1mH911+SoVfpecK2c0HhXSiKXpB+fch0GYv76q/c2I7JmVh
         txHbUslFJAoVga89ogqNtNODA+8AHc3i742b45Ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 19/92] tracing/uprobe: Fix uprobe_perf_open probes iteration
Date:   Mon, 29 Nov 2021 19:17:48 +0100
Message-Id: <20211129181708.061686496@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

commit 1880ed71ce863318c1ce93bf324876fb5f92854f upstream.

Add missing 'tu' variable initialization in the probes loop,
otherwise the head 'tu' is used instead of added probes.

Link: https://lkml.kernel.org/r/20211123142801.182530-1-jolsa@kernel.org

Cc: stable@vger.kernel.org
Fixes: 99c9a923e97a ("tracing/uprobe: Fix double perf_event linking on multiprobe uprobe")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_uprobe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1299,6 +1299,7 @@ static int uprobe_perf_open(struct trace
 		return 0;
 
 	list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
+		tu = container_of(pos, struct trace_uprobe, tp);
 		err = uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
 		if (err) {
 			uprobe_perf_close(call, event);


