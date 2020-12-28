Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3549F2E4116
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392530AbgL1PAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440225AbgL1ONk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58EBF207A9;
        Mon, 28 Dec 2020 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164780;
        bh=5q5Y9s5C1q7o1t5RfIRykLjMtnHKqtXg45MqgLD44QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XN80wcoIPWX64LlTmeKaZwoaB4CQMynrjqYNEt5RwHWOeXyXMz4AjJsW8hzXykqcz
         aWUCR+uiiRHOa1UISenGRZp+zAND5saf+2Gr2NklhhCFWtp2CTWEccldnB0mRFHeMz
         SQpEl9fvY1hxjbVRRYddNnpSqNkv2D5KWLEhalMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/717] bpf: Fix bpf_put_raw_tracepoint()s use of __module_address()
Date:   Mon, 28 Dec 2020 13:44:53 +0100
Message-Id: <20201228125035.159490812@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 12cc126df82c96c89706aa207ad27c56f219047c ]

__module_address() needs to be called with preemption disabled or with
module_mutex taken. preempt_disable() is enough for read-only uses, which is
what this fix does. Also, module_put() does internal check for NULL, so drop
it as well.

Fixes: a38d1107f937 ("bpf: support raw tracepoints in modules")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20201203204634.1325171-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a125ea5e04cd7..0dde84b9d29fe 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2041,10 +2041,12 @@ struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name)
 
 void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp)
 {
-	struct module *mod = __module_address((unsigned long)btp);
+	struct module *mod;
 
-	if (mod)
-		module_put(mod);
+	preempt_disable();
+	mod = __module_address((unsigned long)btp);
+	module_put(mod);
+	preempt_enable();
 }
 
 static __always_inline
-- 
2.27.0



