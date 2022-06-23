Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF3A558058
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiFWQrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiFWQql (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A35645ACF;
        Thu, 23 Jun 2022 09:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69AB061F91;
        Thu, 23 Jun 2022 16:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACD9C3411B;
        Thu, 23 Jun 2022 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002792;
        bh=qQIYNooHt6J28prKBGj0I1dPeKTwMJb17N07RA0jJ78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGcbEPSbHiGxzx5Cu6JWMC4H3d9s2S9UR4xGnsPsxOowmtOOtYALJq2J/hkLuUUPE
         yOWh0QgZaMeJJhyQza2Pl0c3c9FGQhtsXeUTAyaxQ8IoaRJPhs8Fr5aL9f1tDzv3i9
         1NyECekcPynrXhhuQizDQP6Xu/L7CCJU4F5EdmQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 027/264] random: always fill buffer in get_random_bytes_wait
Date:   Thu, 23 Jun 2022 18:40:20 +0200
Message-Id: <20220623164344.837725308@linuxfoundation.org>
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
@@ -63,10 +63,8 @@ static inline unsigned long get_random_l
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


