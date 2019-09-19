Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870A0B8433
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393467AbfISWIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393472AbfISWIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:08:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F6A121920;
        Thu, 19 Sep 2019 22:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930922;
        bh=WCP6QyaYIxXcP8RcE8oUkk9e6+XZKDW0z21xQZ+MEZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nmly+fPxFvzavWDCR+HksdH3jE0PReP/NnZc7Oig9JHL9SRDsA5VUid0V4B4umDFQ
         +JzHdK6ywgRneImKBFE5AoNHtS3xGCHOEkoQ5ThU3PY68RB8kUzU4xIrRZ9s+xURaw
         2kveb9Y+S5Iq5nrvwAcCBLXe+xqM+iGBi+lET/rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Petar Penkov <ppenkov@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 063/124] flow_dissector: Fix potential use-after-free on BPF_PROG_DETACH
Date:   Fri, 20 Sep 2019 00:02:31 +0200
Message-Id: <20190919214821.290236988@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit db38de39684dda2bf307f41797db2831deba64e9 ]

Call to bpf_prog_put(), with help of call_rcu(), queues an RCU-callback to
free the program once a grace period has elapsed. The callback can run
together with new RCU readers that started after the last grace period.
New RCU readers can potentially see the "old" to-be-freed or already-freed
pointer to the program object before the RCU update-side NULLs it.

Reorder the operations so that the RCU update-side resets the protected
pointer before the end of the grace period after which the program will be
freed.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Petar Penkov <ppenkov@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index edd622956083d..b15c0c0f6e557 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -138,8 +138,8 @@ int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
 		mutex_unlock(&flow_dissector_mutex);
 		return -ENOENT;
 	}
-	bpf_prog_put(attached);
 	RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
+	bpf_prog_put(attached);
 	mutex_unlock(&flow_dissector_mutex);
 	return 0;
 }
-- 
2.20.1



