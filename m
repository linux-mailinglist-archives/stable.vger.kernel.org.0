Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0231361F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhBHPGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhBHPEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:04:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F009C64ECB;
        Mon,  8 Feb 2021 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796620;
        bh=ZXp0hkJIVKIJ3lKq5rUhnefyeUf147Ey5GhnkrKBKyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXr2Fr9XYi0n65Dxa9TFktn1MRbsElSmd/bYS07ATjQ284OIdaD38D5p+n7A38ww0
         cX+RiF7GrRI4l0qdE1gFVGuTfBu2y28dd74NUSdHgYPMyExv3iIp+lFjkSQDTitfFp
         nkBD9CaaUj6lJ3HaEc01d7u2gvzTNPeKQED1oe9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/38] net: lapb: Copy the skb before sending a packet
Date:   Mon,  8 Feb 2021 16:00:42 +0100
Message-Id: <20210208145806.084136251@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
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
index ba4d015bd1a67..7cbb77b7479a6 100644
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



