Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D60B11B804
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbfLKPKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730719AbfLKPKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58978208C3;
        Wed, 11 Dec 2019 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077013;
        bh=6aGjWXNISs2WJ1JMWExV1XkKDkJddOHQDLaxBAQHG4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyfb33I7o40i3WIUS/ULI13gY53ojwjrUOzy5CLy+knE837gXG5F4eHLC5Jueo/wH
         3Tt7giCoohHZAZaU3CZG5li1huQucwiqdj6RAgM3/dhF7HpVB9vR8+GHfz9WEoGBxY
         qx3mxIfnHbHMvT7RFPjsePzuxSjngkcb0l/BSGLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 75/92] crypto: user - fix memory leak in crypto_reportstat
Date:   Wed, 11 Dec 2019 16:06:06 +0100
Message-Id: <20191211150258.359953926@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit c03b04dcdba1da39903e23cc4d072abf8f68f2dd upstream.

In crypto_reportstat, a new skb is created by nlmsg_new(). This skb is
leaked if crypto_reportstat_alg() fails. Required release for skb is
added.

Fixes: cac5818c25d0 ("crypto: user - Implement a generic crypto statistics")
Cc: <stable@vger.kernel.org>
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/crypto_user_stat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -328,8 +328,10 @@ int crypto_reportstat(struct sk_buff *in
 drop_alg:
 	crypto_mod_put(alg);
 
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		return err;
+	}
 
 	return nlmsg_unicast(net->crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }


