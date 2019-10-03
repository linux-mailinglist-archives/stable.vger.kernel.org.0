Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C082CAB9C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfJCP4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfJCP4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:56:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87F5C222C4;
        Thu,  3 Oct 2019 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118211;
        bh=vSrqal/SzB5QUm5IL0bgBfCKgXUI00hLARQdpo92fUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP6FA5EwwSaS7pnTbWsYGvPsJbK6d1vfXg3PBCxoqQHh5nffL3INLCq7/Zt9ZmbBM
         xpl4Wdt4X3j1Ond9cvArR7q+uuoXL/d+y0u03tDkOA97ot2prJZgWWfZhIecgO5dp5
         JHFxxYRr2xUOIvAGeKUBvpdw9I/CljeRFVPZ03wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ori Nimron <orinimron123@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 29/99] appletalk: enforce CAP_NET_RAW for raw sockets
Date:   Thu,  3 Oct 2019 17:52:52 +0200
Message-Id: <20191003154308.662673104@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ori Nimron <orinimron123@gmail.com>

[ Upstream commit 6cc03e8aa36c51f3b26a0d21a3c4ce2809c842ac ]

When creating a raw AF_APPLETALK socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/appletalk/ddp.c |    5 +++++
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
 	sk = sk_alloc(net, PF_APPLETALK, GFP_KERNEL, &ddp_proto, kern);
 	if (!sk)


