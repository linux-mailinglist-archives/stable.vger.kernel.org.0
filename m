Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BB376DF3
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388193AbfGZP1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388169AbfGZP1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:27:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D24122CBF;
        Fri, 26 Jul 2019 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154825;
        bh=Sz43Jk6K+0CKPBk/2oB4wkkSjf+IM1nACiGhVNWupgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJ7y9QyhpspysskAEZKMAZaVsBe+DRoCidvdGAbMD8yRdlD5ncWIaaen/kBquXGuT
         a6U8MM8fjsgVh9l+yqqEnV4dbdXQY0GapVvVNwkMYV1Vx1E3GrIY0vmoXInBD56UgX
         yCa7PJd34JUAOtbnV2jrmLl+VEpDG3qtevRYQJS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Beckett <david.beckett@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 37/66] net/tls: fix poll ignoring partially copied records
Date:   Fri, 26 Jul 2019 17:24:36 +0200
Message-Id: <20190726152306.042706186@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 13aecb17acabc2a92187d08f7ca93bb8aad62c6f ]

David reports that RPC applications which use epoll() occasionally
get stuck, and that TLS ULP causes the kernel to not wake applications,
even though read() will return data.

This is indeed true. The ctx->rx_list which holds partially copied
records is not consulted when deciding whether socket is readable.

Note that SO_RCVLOWAT with epoll() is and has always been broken for
kernel TLS. We'd need to parse all records from the TCP layer, instead
of just the first one.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Reported-by: David Beckett <david.beckett@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1958,7 +1958,8 @@ bool tls_sw_stream_read(const struct soc
 		ingress_empty = list_empty(&psock->ingress_msg);
 	rcu_read_unlock();
 
-	return !ingress_empty || ctx->recv_pkt;
+	return !ingress_empty || ctx->recv_pkt ||
+		!skb_queue_empty(&ctx->rx_list);
 }
 
 static int tls_read_size(struct strparser *strp, struct sk_buff *skb)


