Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714BE5582FF
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiFWRXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiFWRW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:22:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3795B62A0;
        Thu, 23 Jun 2022 10:01:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7661E61408;
        Thu, 23 Jun 2022 17:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4973FC3411B;
        Thu, 23 Jun 2022 17:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003688;
        bh=nvgdiBJ7BD3uKpg5Q+GCBeISfW/+zmEsuUGDmnbJQAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQ3F8pW0bSC/Du/rUUfY0Q/L93GmEgJ1ulhPYbzhcuCuFNMEvsehjz5WKc33GRMXl
         F1yGj0n80gmc4peXLkl6FlZI8YKkY1umxb4rJSJsr/cxjb0+S6CYpoX91jupczO3Y0
         +oYHvRZLrUXA9m7/vYxI/ElEhnMkE43qsD+IjuZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Mark Brown <broonie@kernel.org>, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 048/237] s390: Remove arch_has_random, arch_has_random_seed
Date:   Thu, 23 Jun 2022 18:41:22 +0200
Message-Id: <20220623164344.535968271@linuxfoundation.org>
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

commit 5e054c820f59bbb9714d5767f5f476581c309ca8 upstream.

These symbols are currently part of the generic archrandom.h
interface, but are currently unused and can be removed.

Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20200110145422.49141-4-broonie@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/archrandom.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -26,18 +26,6 @@ static void s390_arch_random_generate(u8
 	atomic64_add(nbytes, &s390_arch_random_counter);
 }
 
-static inline bool arch_has_random(void)
-{
-	if (static_branch_likely(&s390_arch_random_available))
-		return true;
-	return false;
-}
-
-static inline bool arch_has_random_seed(void)
-{
-	return arch_has_random();
-}
-
 static inline bool arch_get_random_long(unsigned long *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {


