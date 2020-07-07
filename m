Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC56E2171FC
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgGGP1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbgGGP1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:27:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3527206F6;
        Tue,  7 Jul 2020 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135640;
        bh=FHtrfojDjWvO9f6DayfxB+2Dkz7ankW9QigDjj4aI4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4pvfV16rQqtL+ZhRqwNY2N6gZruDMcIL+UpBC0Vvb5K71+FGFj1SP3wMo0jJn3Vg
         p2fM/VbgN0bJK/v7LBG/y0GCO6wx5+UOyBoITPTgj1loBk/RuWvZC+/WKDYINOE5TQ
         vEJAPiLDCkxZ555appCuOgXQZ4TtvFHhQLlJ658o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.7 088/112] padata: upgrade smp_mb__after_atomic to smp_mb in padata_do_serial
Date:   Tue,  7 Jul 2020 17:17:33 +0200
Message-Id: <20200707145805.166669818@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit e04ec0de61c1eb9693179093e83ab8ca68a30d08 upstream.

A 5.7 kernel hangs during a tcrypt test of padata that waits for an AEAD
request to finish.  This is only seen on large machines running many
concurrent requests.

The issue is that padata never serializes the request.  The removal of
the reorder_objects atomic missed that the memory barrier in
padata_do_serial() depends on it.

Upgrade the barrier from smp_mb__after_atomic to smp_mb to get correct
ordering again.

Fixes: 3facced7aeed1 ("padata: remove reorder_objects")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/padata.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -260,7 +260,7 @@ static void padata_reorder(struct parall
 	 *
 	 * Ensure reorder queue is read after pd->lock is dropped so we see
 	 * new objects from another task in padata_do_serial.  Pairs with
-	 * smp_mb__after_atomic in padata_do_serial.
+	 * smp_mb in padata_do_serial.
 	 */
 	smp_mb();
 
@@ -342,7 +342,7 @@ void padata_do_serial(struct padata_priv
 	 * with the trylock of pd->lock in padata_reorder.  Pairs with smp_mb
 	 * in padata_reorder.
 	 */
-	smp_mb__after_atomic();
+	smp_mb();
 
 	padata_reorder(pd);
 }


