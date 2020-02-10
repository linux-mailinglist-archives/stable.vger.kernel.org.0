Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381A1157A53
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgBJNWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgBJMh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:26 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 037FB2168B;
        Mon, 10 Feb 2020 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338244;
        bh=bcivqPUoKibzVZRLYV93mZU5UcqeoabEktaxltG0Mfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdrdIAWc1+THoF48yYhlVNo4eF6eZBCe6BMeDq72TFvgBvvX/JBRuU/Utj93DjJdd
         bveztZuzCdIwTJRnWUk4nBBVO+zb+ZoKmDmDEXBhnB9nVmNtWPaldTm/PxPgH/uXcR
         hXYuBuNss73aIufGotDAUXakkhsn1/iGZI+kKz1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 101/309] crypto: api - Check spawn->alg under lock in crypto_drop_spawn
Date:   Mon, 10 Feb 2020 04:30:57 -0800
Message-Id: <20200210122415.925320076@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -669,11 +669,9 @@ EXPORT_SYMBOL_GPL(crypto_grab_spawn);
 
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


