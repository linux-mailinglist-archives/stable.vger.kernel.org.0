Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BBE55836E
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiFWR3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiFWR1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:27:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C3050E04;
        Thu, 23 Jun 2022 10:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81CE1B8248E;
        Thu, 23 Jun 2022 17:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCBAC3411B;
        Thu, 23 Jun 2022 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003803;
        bh=VX61gT+Y08KmB0rcQK6oQt7Le4cwnWnzjxbdvU33n7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjeTvyrNxZbsGPY5YnGxNx6tUNQ86hOPVcqi+a+TQMJW9Snh4nvFrubZphgMWpRHk
         7J5GvTYZBUo0WDNupXucnqokzsV+y5lp+foFdWN5bCRPuC558UpoNCjkS8V9SkTyR2
         oSfjMbdQz7pFnVxZOI/aq0wn6ckBqpPkE9KVBrPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Mark Brown <broonie@kernel.org>, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 052/237] powerpc: Use bool in archrandom.h
Date:   Thu, 23 Jun 2022 18:41:26 +0200
Message-Id: <20220623164344.650423060@linuxfoundation.org>
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

commit 98dcfce69729f9ce0fb14f96a39bbdba21429597 upstream.

The generic interface uses bool not int; match that.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20200110145422.49141-9-broonie@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/archrandom.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -6,27 +6,28 @@
 
 #include <asm/machdep.h>
 
-static inline int arch_get_random_long(unsigned long *v)
+static inline bool arch_get_random_long(unsigned long *v)
 {
-	return 0;
+	return false;
 }
 
-static inline int arch_get_random_int(unsigned int *v)
+static inline bool arch_get_random_int(unsigned int *v)
 {
-	return 0;
+	return false;
 }
 
-static inline int arch_get_random_seed_long(unsigned long *v)
+static inline bool arch_get_random_seed_long(unsigned long *v)
 {
 	if (ppc_md.get_random_seed)
 		return ppc_md.get_random_seed(v);
 
-	return 0;
+	return false;
 }
-static inline int arch_get_random_seed_int(unsigned int *v)
+
+static inline bool arch_get_random_seed_int(unsigned int *v)
 {
 	unsigned long val;
-	int rc;
+	bool rc;
 
 	rc = arch_get_random_seed_long(&val);
 	if (rc)


