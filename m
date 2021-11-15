Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC26451406
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348889AbhKOUAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344191AbhKOTYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457DF6347C;
        Mon, 15 Nov 2021 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002413;
        bh=iRBiS3y4Y2V5WBegBm/qfHddjQ4/hiPobHurYCq0x4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9RNNF56hyyZFU0aJGxpwwGF5S7cyV8W3SHIrm9A/kusyrQfEnF1cMTtBfUe10Lob
         +y3xiu25TeCGsBJig+zI4880Y7DvwLA8dppl1WHWcFAXHzsi9VSLKv+MWp+TSsBz9M
         Bdw75YFqKbmw6fg0OOi4ODP4WcJSiPSctOQnicVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/917] tracing: Fix missing trace_boot_init_histograms kstrdup NULL checks
Date:   Mon, 15 Nov 2021 18:00:19 +0100
Message-Id: <20211115165446.532507054@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 3c20bd3af535d64771b193bb4dd41ed662c464ce ]

trace_boot_init_histograms misses NULL pointer checks for kstrdup
failure.

Link: https://lkml.kernel.org/r/20211015195550.22742-1-mathieu.desnoyers@efficios.com

Fixes: 64dc7f6958ef5 ("tracing/boot: Show correct histogram error command")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_boot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 8d252f63cd784..0580287d7a0d1 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -430,6 +430,8 @@ trace_boot_init_histograms(struct trace_event_file *file,
 		/* All digit started node should be instances. */
 		if (trace_boot_compose_hist_cmd(node, buf, size) == 0) {
 			tmp = kstrdup(buf, GFP_KERNEL);
+			if (!tmp)
+				return;
 			if (trigger_process_regex(file, buf) < 0)
 				pr_err("Failed to apply hist trigger: %s\n", tmp);
 			kfree(tmp);
@@ -439,6 +441,8 @@ trace_boot_init_histograms(struct trace_event_file *file,
 	if (xbc_node_find_subkey(hnode, "keys")) {
 		if (trace_boot_compose_hist_cmd(hnode, buf, size) == 0) {
 			tmp = kstrdup(buf, GFP_KERNEL);
+			if (!tmp)
+				return;
 			if (trigger_process_regex(file, buf) < 0)
 				pr_err("Failed to apply hist trigger: %s\n", tmp);
 			kfree(tmp);
-- 
2.33.0



