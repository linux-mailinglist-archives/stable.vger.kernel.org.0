Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C96515C76C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgBMQKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgBMPWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:35 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 302B624699;
        Thu, 13 Feb 2020 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607355;
        bh=ZYhu1oglyVabZJCIqMih7PEUtRywOI7/sk/iy065ffc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9+rzGx7WCymVyH3c5Z36Dtv5TFi4EaRGCV1w2FKI7CyhV0KayeRvuOn36V0jkJWL
         YMMG6JYyZT7AvpBZPimnttEXSuRXb3LX4D5Ex4NidXUFI2UJdC8lfbzlN6KmwkxJNw
         95gCkzcbx9X9nhdcKIAe9u1QUz31d7uoW1e3YgSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 21/91] crypto: api - Check spawn->alg under lock in crypto_drop_spawn
Date:   Thu, 13 Feb 2020 07:19:38 -0800
Message-Id: <20200213151829.841711176@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 7db3b61b6bba4310f454588c2ca6faf2958ad79f upstream.

We need to check whether spawn->alg is NULL under lock as otherwise
the algorithm could be removed from under us after we have checked
it and found it to be non-NULL.  This could cause us to remove the
spawn from a non-existent list.

Fixes: 7ede5a5ba55a ("crypto: api - Fix crypto_drop_spawn crash...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algapi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -653,11 +653,9 @@ EXPORT_SYMBOL_GPL(crypto_grab_spawn);
 
 void crypto_drop_spawn(struct crypto_spawn *spawn)
 {
-	if (!spawn->alg)
-		return;
-
 	down_write(&crypto_alg_sem);
-	list_del(&spawn->list);
+	if (spawn->alg)
+		list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
 }
 EXPORT_SYMBOL_GPL(crypto_drop_spawn);


