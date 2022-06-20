Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1224551C47
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346677AbiFTNhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346711AbiFTNgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:36:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E701EC69;
        Mon, 20 Jun 2022 06:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17CF7CE1392;
        Mon, 20 Jun 2022 13:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC11FC3411B;
        Mon, 20 Jun 2022 13:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730789;
        bh=J5xJYi+i64ykzs9x/0F9qkD+abvNKXxxEEBjmLewFAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj/cfrify49oN9VmIiRkqmfqZOE5BHUzlwYib61/3Id4E7rHFJXLtq9+o94Vp3628
         LnEYry6stBiLt8s06G+XbWCJoLlEMw8hCyZZeQ1T+HPELj4nyKGVK0A8vKJj4GJpl7
         lhKOL2Xmn91GFm6ql0OL8Ng1OopCr1jegTYzLPro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 055/240] random: remove unused OUTPUT_POOL constants
Date:   Mon, 20 Jun 2022 14:49:16 +0200
Message-Id: <20220620124739.800476948@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 0f63702718c91d89c922081ac1e6baeddc2d8b1a upstream.

We no longer have an output pool. Rather, we have just a wakeup bits
threshold for /dev/random reads, presumably so that processes don't
hang. This value, random_write_wakeup_bits, is configurable anyway. So
all the no longer usefully named OUTPUT_POOL constants were doing was
setting a reasonable default for random_write_wakeup_bits. This commit
gets rid of the constants and just puts it all in the default value of
random_write_wakeup_bits.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -363,8 +363,6 @@
  */
 #define INPUT_POOL_SHIFT	12
 #define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
-#define OUTPUT_POOL_SHIFT	10
-#define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
 #define EXTRACT_SIZE		(BLAKE2S_HASH_SIZE / 2)
 
 /*
@@ -382,7 +380,7 @@
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
  */
-static int random_write_wakeup_bits = 28 * OUTPUT_POOL_WORDS;
+static int random_write_wakeup_bits = 28 * (1 << 5);
 
 /*
  * Originally, we used a primitive polynomial of degree .poolwords


