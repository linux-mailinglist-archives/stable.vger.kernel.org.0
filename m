Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5196247512
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404163AbgHQTSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbgHQPh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC7322CB3;
        Mon, 17 Aug 2020 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678668;
        bh=3N8MtWemgelhVh//K1SS5aIJzLRX7vaaoNR0NvUqAYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHAFdoFX0EcfV+yKz+IbbfTV+hdK1Z1Ob6rlyYrurPdKk7JBS2j1gXzFpfDlsIKes
         SDNZFA+vgJE3iba4C49o5uej38BB+jCJdceNKaKiOimjZDOdZAk4sGXl1TWlnYvWWE
         J45Q+2futghbtKl2znH8ahBQRw5L4vczn1EbGjS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qingyu Li <ieatmuttonchuan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 386/464] net/nfc/rawsock.c: add CAP_NET_RAW check.
Date:   Mon, 17 Aug 2020 17:15:39 +0200
Message-Id: <20200817143852.269851637@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingyu Li <ieatmuttonchuan@gmail.com>

[ Upstream commit 26896f01467a28651f7a536143fe5ac8449d4041 ]

When creating a raw AF_NFC socket, CAP_NET_RAW needs to be checked first.

Signed-off-by: Qingyu Li <ieatmuttonchuan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/rawsock.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -332,10 +332,13 @@ static int rawsock_create(struct net *ne
 	if ((sock->type != SOCK_SEQPACKET) && (sock->type != SOCK_RAW))
 		return -ESOCKTNOSUPPORT;
 
-	if (sock->type == SOCK_RAW)
+	if (sock->type == SOCK_RAW) {
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
-	else
+	} else {
 		sock->ops = &rawsock_ops;
+	}
 
 	sk = sk_alloc(net, PF_NFC, GFP_ATOMIC, nfc_proto->proto, kern);
 	if (!sk)


