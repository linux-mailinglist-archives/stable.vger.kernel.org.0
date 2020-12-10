Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97A22D6863
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 21:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390076AbgLJO2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390098AbgLJO2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com,
        Anmol Karn <anmol.karan123@gmail.com>
Subject: [PATCH 4.4 02/39] rose: Fix Null pointer dereference in rose_send_frame()
Date:   Thu, 10 Dec 2020 15:26:13 +0100
Message-Id: <20201210142601.014294005@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anmol Karn <anmol.karan123@gmail.com>

[ Upstream commit 3b3fd068c56e3fbea30090859216a368398e39bf ]

rose_send_frame() dereferences `neigh->dev` when called from
rose_transmit_clear_request(), and the first occurrence of the
`neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
and it is initialized in rose_add_loopback_neigh() as NULL.
i.e when `rose_loopback_neigh` used in rose_loopback_timer()
its `->dev` was still NULL and rose_loopback_timer() was calling
rose_rx_call_request() without checking for NULL.

- net/rose/rose_link.c
This bug seems to get triggered in this line:

rose_call = (ax25_address *)neigh->dev->dev_addr;

Fix it by adding NULL checking for `rose_loopback_neigh->dev`
in rose_loopback_timer().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
Link: https://lore.kernel.org/r/20201119191043.28813-1-anmol.karan123@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -99,10 +99,19 @@ static void rose_loopback_timer(unsigned
 		}
 
 		if (frametype == ROSE_CALL_REQUEST) {
-			if ((dev = rose_dev_get(dest)) != NULL) {
-				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
-					kfree_skb(skb);
-			} else {
+			if (!rose_loopback_neigh->dev) {
+				kfree_skb(skb);
+				continue;
+			}
+
+			dev = rose_dev_get(dest);
+			if (!dev) {
+				kfree_skb(skb);
+				continue;
+			}
+
+			if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0) {
+				dev_put(dev);
 				kfree_skb(skb);
 			}
 		} else {


