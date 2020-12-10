Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFCE2D6031
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389899AbgLJPnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391267AbgLJOkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:07 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com,
        syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com,
        syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.9 60/75] can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check
Date:   Thu, 10 Dec 2020 15:27:25 +0100
Message-Id: <20201210142608.999988978@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit d73ff9b7c4eacaba0fd956d14882bcae970f8307 upstream.

To detect potential bugs in CAN protocol implementations (double removal of
receiver entries) a WARN() statement has been used if no matching list item was
found for removal.

The fault injection issued by syzkaller was able to create a situation where
the closing of a socket runs simultaneously to the notifier call chain for
removing the CAN network device in use.

This case is very unlikely in real life but it doesn't break anything.
Therefore we just replace the WARN() statement with pr_warn() to preserve the
notification for the CAN protocol development.

Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com
Reported-by: syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com
Reported-by: syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201126192140.14350-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/af_can.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -541,10 +541,13 @@ void can_rx_unregister(struct net *net,
 
 	/* Check for bugs in CAN protocol implementations using af_can.c:
 	 * 'rcv' will be NULL if no matching list item was found for removal.
+	 * As this case may potentially happen when closing a socket while
+	 * the notifier for removing the CAN netdev is running we just print
+	 * a warning here.
 	 */
 	if (!rcv) {
-		WARN(1, "BUG: receive list entry not found for dev %s, id %03X, mask %03X\n",
-		     DNAME(dev), can_id, mask);
+		pr_warn("can: receive list entry not found for dev %s, id %03X, mask %03X\n",
+			DNAME(dev), can_id, mask);
 		goto out;
 	}
 


