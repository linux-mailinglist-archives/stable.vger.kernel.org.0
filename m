Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499075580D2
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiFWQxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiFWQxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:53:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B724517E3D;
        Thu, 23 Jun 2022 09:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F6361FD0;
        Thu, 23 Jun 2022 16:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F94CC341C5;
        Thu, 23 Jun 2022 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003162;
        bh=VKfMwkHrv82AyMtOxpd93K9+egkcIRRe1Z42u3TfWZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSD1k1NonNrgXelY2H3z6qdi5QyUlZ9ckDs91DArk3JLBdTJUfCv9iX1mu82y3kRp
         vWJST1dxjyw6dr/4H0f7SqReNpl19EUbk/A0fndSZuI//fNueBq9KqNVuPB6Cy4r7g
         nI0COjzBH1ednbBnKJZfhGKo4nTv65RKpbGisBAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 150/264] hwrng: use rng source with best quality
Date:   Thu, 23 Jun 2022 18:42:23 +0200
Message-Id: <20220623164348.309034313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.vnet.ibm.com>

commit 2bbb6983887fefc8026beab01198d30f47b7bd22 upstream.

This patch rewoks the hwrng to always use the
rng source with best entropy quality.

On registation and unregistration the hwrng now
tries to choose the best (= highest quality value)
rng source. The handling of the internal list
of registered rng sources is now always sorted
by quality and the top most rng chosen.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -28,6 +28,7 @@
 
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
+/* list of registered rngs, sorted decending by quality */
 static LIST_HEAD(rng_list);
 /* Protects rng_list and current_rng */
 static DEFINE_MUTEX(rng_mutex);
@@ -416,6 +417,7 @@ int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
+	struct list_head *rng_list_ptr;
 
 	if (!rng->name || (!rng->data_read && !rng->read))
 		goto out;
@@ -431,14 +433,25 @@ int hwrng_register(struct hwrng *rng)
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
 
+	/* rng_list is sorted by decreasing quality */
+	list_for_each(rng_list_ptr, &rng_list) {
+		tmp = list_entry(rng_list_ptr, struct hwrng, list);
+		if (tmp->quality < rng->quality)
+			break;
+	}
+	list_add_tail(&rng->list, rng_list_ptr);
+
 	old_rng = current_rng;
 	err = 0;
-	if (!old_rng) {
+	if (!old_rng || (rng->quality > old_rng->quality)) {
+		/*
+		 * Set new rng as current as the new rng source
+		 * provides better entropy quality.
+		 */
 		err = set_current_rng(rng);
 		if (err)
 			goto out_unlock;
 	}
-	list_add_tail(&rng->list, &rng_list);
 
 	if (old_rng && !rng->init) {
 		/*
@@ -465,12 +478,12 @@ void hwrng_unregister(struct hwrng *rng)
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		drop_current_rng();
+		/* rng_list is sorted by quality, use the best (=first) one */
 		if (!list_empty(&rng_list)) {
-			struct hwrng *tail;
-
-			tail = list_entry(rng_list.prev, struct hwrng, list);
+			struct hwrng *new_rng;
 
-			set_current_rng(tail);
+			new_rng = list_entry(rng_list.next, struct hwrng, list);
+			set_current_rng(new_rng);
 		}
 	}
 


