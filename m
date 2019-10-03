Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23292CA956
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404541AbfJCQlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404538AbfJCQlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED261206BB;
        Thu,  3 Oct 2019 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120873;
        bh=W0T+0m0P2SGl5GUNMUD4zXhYLqP9P+xj8Epf7hhfNdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyQCaOZiSLVykxPyG0WLXYVRHUGHIKCOgI6OP0ql/RM3Kq9YwpGwrBNWJqu17ogog
         y7CnNoXcGS+j+OSmgyPJdYjCpiPLfQ0RPMeipBepYTnhsJ2GCIxj8YFiWwtAntqJn/
         u+x9/ZZZgiGuwS2iSA3FhdeERMO4tkPCgIjzcWUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ori Nimron <orinimron123@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 034/344] appletalk: enforce CAP_NET_RAW for raw sockets
Date:   Thu,  3 Oct 2019 17:49:59 +0200
Message-Id: <20191003154543.445016933@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
@@ -1023,6 +1023,11 @@ static int atalk_create(struct net *net,
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


