Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECFE13918
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfEDK3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfEDK1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC7F20859;
        Sat,  4 May 2019 10:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965624;
        bh=mj5bq9ExhWvppyqu2OGwhYDfO1FA/a7oNaWdZHOr7yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0SdDuXsq//Ny4RJGUpWG/H4O91Zy6YhJOF4F/xo0QHF55TO+Ivkbs6J3ekSFGXoQ
         vzqGh43gogPf0QQqL+GR2SnPc94z7AyfjtCPY4cLpb33JrNQAvagX3frNIYYd8pJPf
         4yNFDxm6HHgz9vqx8NnZ2aLwJpOIz5zPppnWOH9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 10/23] net/tls: avoid NULL pointer deref on nskb->sk in fallback
Date:   Sat,  4 May 2019 12:25:12 +0200
Message-Id: <20190504102451.887482769@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 2dcb003314032c6efb13a065ffae60d164b2dd35 ]

update_chksum() accesses nskb->sk before it has been set
by complete_skb(), move the init up.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device_fallback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -200,13 +200,14 @@ static void complete_skb(struct sk_buff
 
 	skb_put(nskb, skb->len);
 	memcpy(nskb->data, skb->data, headln);
-	update_chksum(nskb, headln);
 
 	nskb->destructor = skb->destructor;
 	nskb->sk = sk;
 	skb->destructor = NULL;
 	skb->sk = NULL;
 
+	update_chksum(nskb, headln);
+
 	delta = nskb->truesize - skb->truesize;
 	if (likely(delta < 0))
 		WARN_ON_ONCE(refcount_sub_and_test(-delta, &sk->sk_wmem_alloc));


