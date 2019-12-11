Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75F511B803
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbfLKPKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730707AbfLKPKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB8C0208C3;
        Wed, 11 Dec 2019 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077011;
        bh=CVHkUPIndhn4PNASNpRZonNaGG8cSqrmhz/kpyIiTJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXS4xjeAwtyFyA29fRUPveBOGSkq2ksAo66QKX4m2hBK9l6i3zMveGyGCXYALdHob
         EeqoHeLYUSQA3L562t913yrpSg7mSmt//pz5OdO4T8fvMsvKKY7lmRlbnsCpQ0Ixep
         5QfvAeQahYRmfzEBdC1Kq4II279pdhi/C/TzsGyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 74/92] crypto: user - fix memory leak in crypto_report
Date:   Wed, 11 Dec 2019 16:06:05 +0100
Message-Id: <20191211150258.044181599@linuxfoundation.org>
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

commit ffdde5932042600c6807d46c1550b28b0db6a3bc upstream.

In crypto_report, a new skb is created via nlmsg_new(). This skb should
be released if crypto_report_alg() fails.

Fixes: a38f7907b926 ("crypto: Add userspace configuration API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/crypto_user_base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -213,8 +213,10 @@ static int crypto_report(struct sk_buff
 drop_alg:
 	crypto_mod_put(alg);
 
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		return err;
+	}
 
 	return nlmsg_unicast(net->crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }


