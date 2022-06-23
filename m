Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F775580AA
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiFWQwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbiFWQvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24F3388B;
        Thu, 23 Jun 2022 09:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69821B82490;
        Thu, 23 Jun 2022 16:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EE4C3411B;
        Thu, 23 Jun 2022 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003012;
        bh=6CbJEz9dZhAvM7TpoGdDWtovp5b/ok5BPvoY6F7n+ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObvqhfJt2Og+0lNC+F9RwkemW42k0thN3Qn1/PW90ZNyqAOnoHJYKvsyXR+SszP+4
         aMHZXHndave8crij/mrgZEP1W1DdZ4mKIo4RPIA+BrC3XiR1xtjZ7khF/2jIFK3G/R
         E+GxAyeU/TiLLhoGpDoGfgOGWi0p2lGkt4+ez0/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 101/264] random: remove unused OUTPUT_POOL constants
Date:   Thu, 23 Jun 2022 18:41:34 +0200
Message-Id: <20220623164346.928801604@linuxfoundation.org>
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
@@ -364,8 +364,6 @@
  */
 #define INPUT_POOL_SHIFT	12
 #define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
-#define OUTPUT_POOL_SHIFT	10
-#define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
 #define EXTRACT_SIZE		(BLAKE2S_HASH_SIZE / 2)
 
 /*
@@ -383,7 +381,7 @@
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
  */
-static int random_write_wakeup_bits = 28 * OUTPUT_POOL_WORDS;
+static int random_write_wakeup_bits = 28 * (1 << 5);
 
 /*
  * Originally, we used a primitive polynomial of degree .poolwords


