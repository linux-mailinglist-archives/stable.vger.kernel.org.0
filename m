Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E10D5582FE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiFWRXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiFWRWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:22:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AD6B6288;
        Thu, 23 Jun 2022 10:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE7B6B8248E;
        Thu, 23 Jun 2022 17:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFC3C3411B;
        Thu, 23 Jun 2022 17:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003685;
        bh=IRArbYD6t1efifI8AEPgeWzmvyXU3WSmW9IZMAI750Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IFbcu1RogDGbpRBFmAHyNHwaR4UN+d0y2F9yL2R2mt+6YrxzjeLOmsIHUXaNEHKm
         yi+TyKD5+IrM1JhvMx61r5D7HW++QRAqbXhSz/zr1z3CgKOsQYRz1pmJ4YED+Mo0tZ
         bTYo5ltgn0NR7nYtGWZ+yWdGmibcizfyJqvzbDvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 003/237] random: always fill buffer in get_random_bytes_wait
Date:   Thu, 23 Jun 2022 18:40:37 +0200
Message-Id: <20220623164343.240272190@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

commit 25e3fca492035a2e1d4ac6e3b1edd9c1acd48897 upstream.

In the unfortunate event that a developer fails to check the return
value of get_random_bytes_wait, or simply wants to make a "best effort"
attempt, for whatever that's worth, it's much better to still fill the
buffer with _something_ rather than catastrophically failing in the case
of an interruption. This is both a defense in depth measure against
inevitable programming bugs, as well as a means of making the API a bit
more useful.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -85,10 +85,8 @@ static inline unsigned long get_random_c
 static inline int get_random_bytes_wait(void *buf, int nbytes)
 {
 	int ret = wait_for_random_bytes();
-	if (unlikely(ret))
-		return ret;
 	get_random_bytes(buf, nbytes);
-	return 0;
+	return ret;
 }
 
 #define declare_get_random_var_wait(var) \


