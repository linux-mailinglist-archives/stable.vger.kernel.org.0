Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58691F9E67
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfKLXuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:50:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57444 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbfKLXug (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:36 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfve-0008Il-R6; Tue, 12 Nov 2019 23:50:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvd-000581-B7; Tue, 12 Nov 2019 23:50:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ori Nimron" <orinimron123@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 12 Nov 2019 23:48:18 +0000
Message-ID: <lsq.1573602477.355052883@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 21/25] appletalk: enforce CAP_NET_RAW for raw sockets
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ori Nimron <orinimron123@gmail.com>

commit 6cc03e8aa36c51f3b26a0d21a3c4ce2809c842ac upstream.

When creating a raw AF_APPLETALK socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/appletalk/ddp.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1029,6 +1029,11 @@ static int atalk_create(struct net *net,
 	 */
 	if (sock->type != SOCK_RAW && sock->type != SOCK_DGRAM)
 		goto out;
+
+	rc = -EPERM;
+	if (sock->type == SOCK_RAW && !kern && !capable(CAP_NET_RAW))
+		goto out;
+
 	rc = -ENOMEM;
 	sk = sk_alloc(net, PF_APPLETALK, GFP_KERNEL, &ddp_proto);
 	if (!sk)

