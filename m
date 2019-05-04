Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2149D13936
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfEDKZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbfEDKZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:25:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E5220859;
        Sat,  4 May 2019 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965538;
        bh=mj5bq9ExhWvppyqu2OGwhYDfO1FA/a7oNaWdZHOr7yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tF2zpG/BiRVfqN/TINNkxQWXQdiADuuVJESStZrGhz8iFleURzEVmYGRTwtDCCaaS
         KJ1uaK2/CtC8lyvXJiHFzZTqTBBldPvVUme67HbtRdJmV+9L0gd9cbMY5JmjoEvb6x
         1d2E+5nSlAVpNdOqYy7modlHHwcf4831l8t1WwpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 10/32] net/tls: avoid NULL pointer deref on nskb->sk in fallback
Date:   Sat,  4 May 2019 12:24:55 +0200
Message-Id: <20190504102452.853582110@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
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


