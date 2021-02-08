Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E939313642
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhBHPIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:08:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhBHPGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:06:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC6F264EDF;
        Mon,  8 Feb 2021 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796692;
        bh=R7X3F2Lwr2jEybZesvYA2VbaWLnZKOajyJcZxuiFvDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JT/ZfHXwSPXdNlKaQsvIj0MN3gHr9Id3optf4bN2BwjiGdJMruNFxTN/mXuvKyb8x
         K9ndN4ftn0Jpti6u4zbGwTVzTH06lSFpa/ZqLlMqLwnWGZzCRzqW2rnoA3ylAstY89
         r1D8+06PN4OMtV8X+26NYXsO46DUxMbVw/dtrT64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/43] net: lapb: Copy the skb before sending a packet
Date:   Mon,  8 Feb 2021 16:00:49 +0100
Message-Id: <20210208145807.250376835@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
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
index 482c94d9d958a..d1c7dcc234486 100644
--- a/net/lapb/lapb_out.c
+++ b/net/lapb/lapb_out.c
@@ -87,7 +87,8 @@ void lapb_kick(struct lapb_cb *lapb)
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



