Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A945249A4F6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387959AbiAYAFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850346AbiAXX3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:29:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244E4C0A887E;
        Mon, 24 Jan 2022 13:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5036B812A5;
        Mon, 24 Jan 2022 21:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070CBC36AE2;
        Mon, 24 Jan 2022 21:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060068;
        bh=hE1OjF1rUYQ93f+jl9N9Z+d4/F4G4HcNLRNh4ttkmPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbgEWXaBinSdVQCi/jl1M6wII2/RDg+jyqz0/b0g9Qb9WB+pBf5R5vmr9G0lKkYyh
         F392H4l9K88tCtFldIAX8qsxsHSbeEcxRJJvh8ccCvHgWh9RqX1EIT08zoqiePQlAj
         +SXxPbpQ7MG4cPIdusXf8lAl+SAO9FW7hFaqdQMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0827/1039] tracing/uprobes: Check the return value of kstrdup() for tu->filename
Date:   Mon, 24 Jan 2022 19:43:36 +0100
Message-Id: <20220124184153.088226680@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 8c7224245557707c613f130431cafbaaa4889615 ]

kstrdup() returns NULL when some internal memory errors happen, it is
better to check the return value of it so to catch the memory error in
time.

Link: https://lkml.kernel.org/r/tencent_3C2E330722056D7891D2C83F29C802734B06@qq.com

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 33ea4b24277b ("perf/core: Implement the 'perf_uprobe' PMU")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_uprobe.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f5f0039d31e5a..78ec1c16ccf4b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1619,6 +1619,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 	tu->path = path;
 	tu->ref_ctr_offset = ref_ctr_offset;
 	tu->filename = kstrdup(name, GFP_KERNEL);
+	if (!tu->filename) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	init_trace_event_call(tu);
 
 	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
-- 
2.34.1



