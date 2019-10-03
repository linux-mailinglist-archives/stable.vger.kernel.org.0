Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF02CAD52
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389531AbfJCRi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732009AbfJCQCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:02:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C1120700;
        Thu,  3 Oct 2019 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118553;
        bh=vSrqal/SzB5QUm5IL0bgBfCKgXUI00hLARQdpo92fUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IG8HFG6pOZewtV/Hs4HnjvvAI+z5Kv4diy4Q2TmzeuL5qv8UkD5Nn0Wy1rlJPRYJr
         IIt+Cw7M51OwK8fd+C65GkLGBszGY+umEjCSSoozwDpyRzkKKngHW9JonvXKnHMYCv
         XNgdjkYxvNbzAQvhKUU3dXLmeyZZaIhroBpUVEXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ori Nimron <orinimron123@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 035/129] appletalk: enforce CAP_NET_RAW for raw sockets
Date:   Thu,  3 Oct 2019 17:52:38 +0200
Message-Id: <20191003154334.574549083@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
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


