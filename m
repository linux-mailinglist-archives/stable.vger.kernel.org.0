Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16AF551CCE
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344706AbiFTN3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345367AbiFTN1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:27:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E396E1C930;
        Mon, 20 Jun 2022 06:11:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8616DB811BF;
        Mon, 20 Jun 2022 13:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDEEC3411C;
        Mon, 20 Jun 2022 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730664;
        bh=6UsHMOF0xgHy1asuYsozh7wS82X7V+TxbifSOSG8XLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VS9eMUsdd1urrgOzXG51LqF7anKCKY4p+AficNdaWqs5cCWrHSgrqHs8oh3ImBZ9q
         YSLbbd0EibWsK4yELl5k450WX52/ZYdw7EUjVI6drN5u5yaOwCqrmm52byVu6fvjj0
         vrKwJWd/rf4CtvgHaFx+e+x3DIS8SoG/asAuRqeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 018/240] random: convert to ENTROPY_BITS for better code readability
Date:   Mon, 20 Jun 2022 14:48:39 +0200
Message-Id: <20220620124738.339407277@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

commit 12faac30d157970fdbfa171bbeb1fb88350303b1 upstream.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-2-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -761,7 +761,7 @@ retry:
 			if (entropy_bits < 128)
 				return;
 			crng_reseed(&primary_crng, r);
-			entropy_bits = r->entropy_count >> ENTROPY_SHIFT;
+			entropy_bits = ENTROPY_BITS(r);
 		}
 	}
 }
@@ -1398,8 +1398,7 @@ retry:
 		goto retry;
 
 	trace_debit_entropy(r->name, 8 * ibytes);
-	if (ibytes &&
-	    (r->entropy_count >> ENTROPY_SHIFT) < random_write_wakeup_bits) {
+	if (ibytes && ENTROPY_BITS(r) < random_write_wakeup_bits) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}


