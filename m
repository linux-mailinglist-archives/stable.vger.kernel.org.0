Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82255CA858
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389463AbfJCQZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390472AbfJCQZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:25:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6331620867;
        Thu,  3 Oct 2019 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119925;
        bh=egfPkjQleP3+sm+wRrMFBlYgRWbRB8K/Z1RhaImosww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKLUqmNGrpDzSknhSz2CKMd61wP8ULLG+qmyEk9aJlAv6ftZJ0TmisPq3r3T5vECZ
         tmGYNAV9PH5M57mY3bkeW4MBVMiJBt7FfrwM3TjVlbONPwSLoRQYcoZBsiADm3t8WF
         d3QYeF9Ono1jhKMIrYIV3E/c4PIYYgcAq+nh+p4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ori Nimron <orinimron123@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 031/313] ieee802154: enforce CAP_NET_RAW for raw sockets
Date:   Thu,  3 Oct 2019 17:50:09 +0200
Message-Id: <20191003154536.377514147@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ori Nimron <orinimron123@gmail.com>

[ Upstream commit e69dbd4619e7674c1679cba49afd9dd9ac347eef ]

When creating a raw AF_IEEE802154 socket, CAP_NET_RAW needs to be
checked first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/socket.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -1008,6 +1008,9 @@ static int ieee802154_create(struct net
 
 	switch (sock->type) {
 	case SOCK_RAW:
+		rc = -EPERM;
+		if (!capable(CAP_NET_RAW))
+			goto out;
 		proto = &ieee802154_raw_prot;
 		ops = &ieee802154_raw_ops;
 		break;


