Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 032C799DCE
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403807AbfHVRXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403795AbfHVRXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:03 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55002341D;
        Thu, 22 Aug 2019 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494582;
        bh=/pDecIkCnISplXnioA/xEhrpBGiQSIbQdlks++4S2T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuVAuvmJl30r75W02PlR4Rm4GZ4CvfbfQsfqf7B+2AxkO2Gr4f+WlQZ0mvQPybT6H
         QcU1bwx46hIq7XcnTZIwvMFCrugMpybQobcep/irUCS6PSGgJ5AJgPFRDwGHOHKsEW
         ZyL+4eTf7iuUWYmrqkG4y1z41LlFYZo2dmH1g2ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 75/78] xen/netback: Reset nr_frags before freeing skb
Date:   Thu, 22 Aug 2019 10:19:19 -0700
Message-Id: <20190822171834.203954783@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 3a0233ddec554b886298de2428edb5c50a20e694 ]

At this point nr_frags has been incremented but the frag does not yet
have a page assigned so freeing the skb results in a crash. Reset
nr_frags before freeing the skb to prevent this.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1421,6 +1421,7 @@ static void xenvif_tx_build_gops(struct
 			skb_shinfo(skb)->nr_frags = MAX_SKB_FRAGS;
 			nskb = xenvif_alloc_skb(0);
 			if (unlikely(nskb == NULL)) {
+				skb_shinfo(skb)->nr_frags = 0;
 				kfree_skb(skb);
 				xenvif_tx_err(queue, &txreq, idx);
 				if (net_ratelimit())
@@ -1436,6 +1437,7 @@ static void xenvif_tx_build_gops(struct
 
 			if (xenvif_set_skb_gso(queue->vif, skb, gso)) {
 				/* Failure in xenvif_set_skb_gso is fatal. */
+				skb_shinfo(skb)->nr_frags = 0;
 				kfree_skb(skb);
 				kfree_skb(nskb);
 				break;


