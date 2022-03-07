Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F44CF7A5
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbiCGJqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiCGJnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:43:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DDA4755B;
        Mon,  7 Mar 2022 01:41:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7420A6133D;
        Mon,  7 Mar 2022 09:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6984DC340E9;
        Mon,  7 Mar 2022 09:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646090;
        bh=hE1OjF1rUYQ93f+jl9N9Z+d4/F4G4HcNLRNh4ttkmPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRK1ybxs+KTAakoXEUz18IyxgdZm9wWqhGFUacbfataoArVp++r7OaWvQNhzhFxqa
         c29h0+17qZHdZkzphTxArQLC38tHItoeloY+CpWP208jwIPBMW8BDGNiHMmk3DDHj2
         Fo9rXp2V9t24Nq3xZNU5RtbZ1oW0qed6egMv7dvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/262] tracing/uprobes: Check the return value of kstrdup() for tu->filename
Date:   Mon,  7 Mar 2022 10:17:14 +0100
Message-Id: <20220307091705.018135219@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



