Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E462551DB7
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245072AbiFTOBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350154AbiFTNxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E3C2658;
        Mon, 20 Jun 2022 06:19:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C37460D36;
        Mon, 20 Jun 2022 13:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1C6C3411B;
        Mon, 20 Jun 2022 13:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731171;
        bh=IEW6otHSZl5sjqwgj0rxhyr3I+WHHe6fZzRTBA3r1TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRoVpmyzQk1GrRUG0idVBZEvRl17AvDWpiAg5h8JvnQliXvF0D+gcbLr2Oq/fQM8t
         woxtfI6FIhSvJl45aaz3x2QybSzrNGd3/MFRur4AQ5D3MoBKqpbuWraO4BAQzEQXj0
         w8ZhuSnXvJxm9hAhtunc4VksV8N4JW27yxLlECv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 176/240] crypto: drbg - always try to free Jitter RNG instance
Date:   Mon, 20 Jun 2022 14:51:17 +0200
Message-Id: <20220620124744.095037148@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

From: "Stephan Müller" <smueller@chronox.de>

commit 819966c06b759022e9932f328284314d9272b9f3 upstream.

The Jitter RNG is unconditionally allocated as a seed source follwoing
the patch 97f2650e5040. Thus, the instance must always be deallocated.

Reported-by: syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com
Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B ...")
Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1647,10 +1647,12 @@ static int drbg_uninstantiate(struct drb
 	if (drbg->random_ready.notifier_call) {
 		unregister_random_ready_notifier(&drbg->random_ready);
 		cancel_work_sync(&drbg->seed_work);
-		crypto_free_rng(drbg->jent);
-		drbg->jent = NULL;
 	}
 
+	if (!IS_ERR_OR_NULL(drbg->jent))
+		crypto_free_rng(drbg->jent);
+	drbg->jent = NULL;
+
 	if (drbg->d_ops)
 		drbg->d_ops->crypto_fini(drbg);
 	drbg_dealloc_state(drbg);


