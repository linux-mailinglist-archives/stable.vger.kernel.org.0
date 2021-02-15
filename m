Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BAF31BD11
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhBOPjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhBOPhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1C564DEE;
        Mon, 15 Feb 2021 15:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403170;
        bh=KweFA7IRadDskMiNVr6d6PMy5T6GyKj7eecvLMkpI0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpMpydnu3oxDDHMP9INmCwFiGFubZOS3OVvRzKEstysXElQ/t8AXe0Hnpudh/1PC6
         myZhJtdPUE3SWtN5Z/NREwA1YY/cWeQ6sk1W3I2ikyK0JwcQOu0yH/+Uto1xkNg+oJ
         vqgB71jbIPVfoAddm8NkwboRxuNg4UDU11KtyhAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/104] bpf: Unbreak BPF_PROG_TYPE_KPROBE when kprobe is called via do_int3
Date:   Mon, 15 Feb 2021 16:27:08 +0100
Message-Id: <20210215152721.255908467@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 548f1191d86ccb9bde2a5305988877b7584c01eb ]

The commit 0d00449c7a28 ("x86: Replace ist_enter() with nmi_enter()")
converted do_int3 handler to be "NMI-like".
That made old if (in_nmi()) check abort execution of bpf programs
attached to kprobe when kprobe is firing via int3
(For example when kprobe is placed in the middle of the function).
Remove the check to restore user visible behavior.

Fixes: 0d00449c7a28 ("x86: Replace ist_enter() with nmi_enter()")
Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/bpf/20210203070636.70926-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 0dde84b9d29fe..fcbfc95649967 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -93,9 +93,6 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 {
 	unsigned int ret;
 
-	if (in_nmi()) /* not supported yet */
-		return 1;
-
 	cant_sleep();
 
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
-- 
2.27.0



