Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23F6126DBA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfLSTLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbfLSSht (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:37:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82DAA20716;
        Thu, 19 Dec 2019 18:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780669;
        bh=G9x/cT2JjTm+p7FmxQ0buJMWxHTzHgniG95TVrwOgtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUxU0nn440vMg7jiWn60A6sxB/aUv3aiSHKvyJfiWBIxYKcfMxCv3YU7+mFgXuoJv
         oS46vTyeqyBY41UkDhi8zvI/aNuitE1SOMa40iF2bLyO6yHTmzq8jMMbwfY1YJhnD3
         tzjOjcLDXz2vKntRbrUPo9LNV+2ubelVhO67TnmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 067/162] crypto: user - fix memory leak in crypto_report
Date:   Thu, 19 Dec 2019 19:32:55 +0100
Message-Id: <20191219183211.914078182@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
 crypto/crypto_user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -249,8 +249,10 @@ static int crypto_report(struct sk_buff
 drop_alg:
 	crypto_mod_put(alg);
 
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		return err;
+	}
 
 	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }


