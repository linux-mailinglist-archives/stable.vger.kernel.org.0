Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27581CAF18
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgEHNOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729498AbgEHMq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D4B221F7;
        Fri,  8 May 2020 12:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942019;
        bh=1wPHcZd42Izy7oPaYRtvpTeCVchX9V3qJyeUrcKZb5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzpzXF1Tzkj1ZHWN1Nt6FZwhMea51t0ZQY/yBM4+8o0z1M0LX6LOUHqSPh10FU26E
         NidWLoVHYWLT4JkcwXU8tu+92dC3laFsL0yc7JUym8Ceoib1tOPOO/t3CGP2bmA4OF
         eshavLEiuGFSXVzz5tT0A9pl5zDe4SkXGFUpppWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 263/312] tipc: fix the error handling in tipc_udp_enable()
Date:   Fri,  8 May 2020 14:34:14 +0200
Message-Id: <20200508123142.920990708@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit a5de125dd46c851fc962806135953c1bd0a0f0df upstream.

Fix to return a negative error code in enable_mcast() error handling
case, and release udp socket when necessary.

Fixes: d0f91938bede ("tipc: add ip/udp media type")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/udp_media.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -405,10 +405,13 @@ static int tipc_udp_enable(struct net *n
 	tuncfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(net, ub->ubsock, &tuncfg);
 
-	if (enable_mcast(ub, remote))
+	err = enable_mcast(ub, remote);
+	if (err)
 		goto err;
 	return 0;
 err:
+	if (ub->ubsock)
+		udp_tunnel_sock_release(ub->ubsock);
 	kfree(ub);
 	return err;
 }


