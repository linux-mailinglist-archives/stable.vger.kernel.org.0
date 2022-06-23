Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19A2558584
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiFWR72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbiFWR5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:57:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6136F4A9;
        Thu, 23 Jun 2022 10:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93602B82498;
        Thu, 23 Jun 2022 17:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B93BC3411B;
        Thu, 23 Jun 2022 17:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004547;
        bh=RG6VjW3XhSd7agEEKPH/P8cAoVf6or+rlbFXWJgkVVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIQ9wMxCDIQHuz/SFH2R19SJn0Rsg60k6mP7qxrxveaw7jbnq4NUTBEE2Xp7snuec
         Hlv4ggGYeYT5gT79CtXILGGnU34zyuLI/DGw3/53MZu1T22PnfHwuh13Ihyo15r0cD
         MHdru/BW+k3WC9vI/I+wo8/IdLMOUkEDZFFa1z9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 071/234] random: simplify arithmetic function flow in account()
Date:   Thu, 23 Jun 2022 18:42:18 +0200
Message-Id: <20220623164345.070066155@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit a254a0e4093fce8c832414a83940736067eed515 upstream.

Now that have_bytes is never modified, we can simplify this function.
First, we move the check for negative entropy_count to be first. That
ensures that subsequent reads of this will be non-negative. Then,
have_bytes and ibytes can be folded into their one use site in the
min_t() function.

Suggested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1293,7 +1293,7 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  */
 static size_t account(size_t nbytes, int min)
 {
-	int entropy_count, orig, have_bytes;
+	int entropy_count, orig;
 	size_t ibytes, nfrac;
 
 	BUG_ON(input_pool.entropy_count > POOL_FRACBITS);
@@ -1301,20 +1301,15 @@ static size_t account(size_t nbytes, int
 	/* Can we pull enough? */
 retry:
 	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
-	ibytes = nbytes;
-	/* never pull more than available */
-	have_bytes = entropy_count >> (POOL_ENTROPY_SHIFT + 3);
-
-	if (have_bytes < 0)
-		have_bytes = 0;
-	ibytes = min_t(size_t, ibytes, have_bytes);
-	if (ibytes < min)
-		ibytes = 0;
-
 	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("negative entropy count: count %d\n", entropy_count);
 		entropy_count = 0;
 	}
+
+	/* never pull more than available */
+	ibytes = min_t(size_t, nbytes, entropy_count >> (POOL_ENTROPY_SHIFT + 3));
+	if (ibytes < min)
+		ibytes = 0;
 	nfrac = ibytes << (POOL_ENTROPY_SHIFT + 3);
 	if ((size_t)entropy_count > nfrac)
 		entropy_count -= nfrac;


