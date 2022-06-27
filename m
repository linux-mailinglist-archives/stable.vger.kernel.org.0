Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B355D28B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbiF0Lyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbiF0Lwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29564DF2F;
        Mon, 27 Jun 2022 04:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1E98B80D92;
        Mon, 27 Jun 2022 11:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16798C3411D;
        Mon, 27 Jun 2022 11:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330393;
        bh=YImIa/liWRw7qo/4z5YHPpebSs0Y9/ZJ3JXz//szOtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwG/ZmHRDF3G6Sv+Xkc2Tlc6u9c74Jt2B5nh3WRQbxbbjD1TCAGkVGK+ue3yUcFee
         HcWjKscjHtgv/Eg/FBs43f1qh2k6k+SE7LydlOJnm1nMjqiA69EpefN4Mbkaf7E1sU
         NaKAnhklQdQVjswCpgcPryllILdBQUOG2lclTiyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 176/181] random: update comment from copy_to_user() -> copy_to_iter()
Date:   Mon, 27 Jun 2022 13:22:29 +0200
Message-Id: <20220627111949.787098845@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 63b8ea5e4f1a87dea4d3114293fc8e96a8f193d7 upstream.

This comment wasn't updated when we moved from read() to read_iter(), so
this patch makes the trivial fix.

Fixes: 1b388e7765f2 ("random: convert to using fops->read_iter()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -451,7 +451,7 @@ static ssize_t get_random_bytes_user(str
 
 	/*
 	 * Immediately overwrite the ChaCha key at index 4 with random
-	 * bytes, in case userspace causes copy_to_user() below to sleep
+	 * bytes, in case userspace causes copy_to_iter() below to sleep
 	 * forever, so that we still retain forward secrecy in that case.
 	 */
 	crng_make_state(chacha_state, (u8 *)&chacha_state[4], CHACHA_KEY_SIZE);


