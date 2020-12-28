Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E072E63D6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633016AbgL1Pm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405648AbgL1Nr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3692072C;
        Mon, 28 Dec 2020 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163232;
        bh=gP0Ok61iEpEARPAp79nD/b4yoKps0F5dI7IcnTs5RR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5iJwtbQ2XMQ+57DNeKh0SOmYef+aAPEtSEiPZohjq4ajd5D87Cg3XSUp/wux3P/t
         mgeJD1nl2/p8tOQTRg1BUN3PtkgKA6K8+Tk13187giR3LtF+4/HXckNle0fOU67Mb0
         Oqlt70kWRxyGcxKiiX/v6hQ9Wm9yDYxocxMnKCIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/453] bpf: Fix bpf_put_raw_tracepoint()s use of __module_address()
Date:   Mon, 28 Dec 2020 13:47:32 +0100
Message-Id: <20201228124947.611645842@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 2372b861f2cfa..74c1db7178cff 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1320,10 +1320,12 @@ struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name)
 
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



