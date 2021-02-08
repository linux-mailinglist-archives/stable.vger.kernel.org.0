Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5407731379A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhBHP2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233873AbhBHPXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036ED64F0E;
        Mon,  8 Feb 2021 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797248;
        bh=wsePVODvHzqZzM2F4SMDDr4A52UH3jf6jXA59xBor3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbvCAmWv/CpN6PMBZts5f6q8pzFmfP7quJ0/H0oYSuFkJ1wpr6YFU24Xv/VVJUtQm
         KR/qDrfKb0RRclFnAduq+KkMv4NluLh0tDsT396tzyZWuUaiMbtxbjc6pn7i/9+hSW
         l6yfj2U3sZ0LfhJqJOriEd8Tvus+fFRLBAw9WV9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/120] net: lapb: Copy the skb before sending a packet
Date:   Mon,  8 Feb 2021 16:00:31 +0100
Message-Id: <20210208145820.176000465@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 88c7a9fd9bdd3e453f04018920964c6f848a591a ]

When sending a packet, we will prepend it with an LAPB header.
This modifies the shared parts of a cloned skb, so we should copy the
skb rather than just clone it, before we prepend the header.

In "Documentation/networking/driver.rst" (the 2nd point), it states
that drivers shouldn't modify the shared parts of a cloned skb when
transmitting.

The "dev_queue_xmit_nit" function in "net/core/dev.c", which is called
when an skb is being sent, clones the skb and sents the clone to
AF_PACKET sockets. Because the LAPB drivers first remove a 1-byte
pseudo-header before handing over the skb to us, if we don't copy the
skb before prepending the LAPB header, the first byte of the packets
received on AF_PACKET sockets can be corrupted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Link: https://lore.kernel.org/r/20210201055706.415842-1-xie.he.0141@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/lapb/lapb_out.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/lapb/lapb_out.c b/net/lapb/lapb_out.c
index 7a4d0715d1c32..a966d29c772d9 100644
--- a/net/lapb/lapb_out.c
+++ b/net/lapb/lapb_out.c
@@ -82,7 +82,8 @@ void lapb_kick(struct lapb_cb *lapb)
 		skb = skb_dequeue(&lapb->write_queue);
 
 		do {
-			if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {
+			skbn = skb_copy(skb, GFP_ATOMIC);
+			if (!skbn) {
 				skb_queue_head(&lapb->write_queue, skb);
 				break;
 			}
-- 
2.27.0



