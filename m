Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4823E86985
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404851AbfHHTIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404852AbfHHTIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B0D218C9;
        Thu,  8 Aug 2019 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291295;
        bh=M7XPlP18xX9EyFM2/Zr9JE6n+F1kWYYW82vo+vdquDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Prcm0I20cG82p1RNqysB+A4Sr0ERJWHGrs+jAID1CuZTf9hcmkwafoPr86O+DgLzX
         ltTlYLMVi4iLX5wgJOoDKKUsQHYPY2cLQO8P2EtrNIMZWtmq50hhR5x7MnxFan6x0r
         nqVUj+yu5OnzJZnk7D5UfU+pK3xUMCxxyG1vIaFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brandon Cazander <brandon.cazander@multapplied.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 45/56] net: fix bpf_xdp_adjust_head regression for generic-XDP
Date:   Thu,  8 Aug 2019 21:05:11 +0200
Message-Id: <20190808190454.955968164@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4382,12 +4382,17 @@ static u32 netif_receive_generic_xdp(str
 
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


