Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA29558328
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiFWR0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiFWRZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:25:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4068E21800;
        Thu, 23 Jun 2022 10:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDD83B8248F;
        Thu, 23 Jun 2022 17:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D26C3411B;
        Thu, 23 Jun 2022 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003723;
        bh=dI4qzF7w/Q2TNL1Pmo70s4Lwm8qtiWZFZoBlD9iNMLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glDLeivp3mJm+k1phBA36et8hrmv5Ivy4JUWPIQWB8oyvVWbA1tl1FDU8bVrBRwEs
         J3XO6Dtyw4mJSKaL9SZ1At7MBB3CDCaSw3VVVU+wGRSlIW3ySeVHDEQoX729CgCRau
         6r/7TgCpUdisW8J+cI8CWwePtTtMTRZnwadxXx6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Mark Brown <broonie@kernel.org>, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 049/237] linux/random.h: Remove arch_has_random, arch_has_random_seed
Date:   Thu, 23 Jun 2022 18:41:23 +0200
Message-Id: <20220623164344.564457023@linuxfoundation.org>
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

From: Richard Henderson <richard.henderson@linaro.org>

commit 647f50d5d9d933b644b29c54f13ac52af1b1774d upstream.

The arm64 version of archrandom.h will need to be able to test for
support and read the random number without preemption, so a separate
query predicate is not practical.

Since this part of the generic interface is unused, remove it.

Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20200110145422.49141-5-broonie@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -126,10 +126,6 @@ static inline bool arch_get_random_int(u
 {
 	return 0;
 }
-static inline bool arch_has_random(void)
-{
-	return 0;
-}
 static inline bool arch_get_random_seed_long(unsigned long *v)
 {
 	return 0;
@@ -138,10 +134,6 @@ static inline bool arch_get_random_seed_
 {
 	return 0;
 }
-static inline bool arch_has_random_seed(void)
-{
-	return 0;
-}
 #endif
 
 #endif /* _LINUX_RANDOM_H */


