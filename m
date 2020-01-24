Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379C314827B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404071AbgAXL21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:28:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404066AbgAXL20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:28:26 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C45CC20704;
        Fri, 24 Jan 2020 11:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865306;
        bh=wUnQPA2gWOAo9yxaNNxXMNczT1iu46ZLwMyUNv8rzAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3aXU26wugtIbmzmQLHvRNhahInhiuqldutZjxUtFiWsE20xzEof8e1X2t20R9nsb
         FPuXll+kmtoxli5WSJ3LIEiMi3YmPE+xJ1J0R0bO9RRIpz04bbHTwgpD1Zc1fB7NCk
         alUCf/VgoxPCgTWsrBDUnrjsGE101NuQxbBt9dLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brandon Cazander <brandon.cazander@multapplied.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 497/639] net: fix bpf_xdp_adjust_head regression for generic-XDP
Date:   Fri, 24 Jan 2020 10:31:07 +0100
Message-Id: <20200124093151.018095250@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 065af355470519bd184019a93ac579f22b036045 ]

When generic-XDP was moved to a later processing step by commit
458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
a regression was introduced when using bpf_xdp_adjust_head.

The issue is that after this commit the skb->network_header is now
changed prior to calling generic XDP and not after. Thus, if the header
is changed by XDP (via bpf_xdp_adjust_head), then skb->network_header
also need to be updated again.  Fix by calling skb_reset_network_header().

Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
Reported-by: Brandon Cazander <brandon.cazander@multapplied.net>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 935fe158cfaff..73ebacabfde8d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4349,12 +4349,17 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	/* check if bpf_xdp_adjust_head was used */
 	off = xdp->data - orig_data;
-	if (off > 0)
-		__skb_pull(skb, off);
-	else if (off < 0)
-		__skb_push(skb, -off);
-	skb->mac_header += off;
+	if (off) {
+		if (off > 0)
+			__skb_pull(skb, off);
+		else if (off < 0)
+			__skb_push(skb, -off);
+
+		skb->mac_header += off;
+		skb_reset_network_header(skb);
+	}
 
 	/* check if bpf_xdp_adjust_tail was used. it can only "shrink"
 	 * pckt.
-- 
2.20.1



