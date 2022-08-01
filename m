Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE196587117
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiHATG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiHATFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:05:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7D643313;
        Mon,  1 Aug 2022 12:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D3C6B81615;
        Mon,  1 Aug 2022 19:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EFCC43470;
        Mon,  1 Aug 2022 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380623;
        bh=eJ/v+3pMrhsCBUeLH+bTGVxMH9aUHe0sDu0CXot8KL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qr36dVBfODTc1PgL8z6zomjMII1lfiGO0I0tT9etheAiLKQ20rZ0czz8p/myAdwJk
         8rd3+iLu3b3yMtvahDFbspzzfA0j7qSqnkF4GsFlYJ88u/BHOTafE+gVOltYAk3fcu
         yTCPPOK5EygNtk56K+coJfkmGj9TcQVQQhuhHtuwIT7dlUCru2ZM9mrgHu/dX+fO44
         C02Pw2mpz702OvcR0npkTVBX44MYDs9EYnYJyHQvHn7ulLMSB18+Kh7S1ZXD77nU3g
         69R1Slttu55XZRNiAHXHWRuPoQPUCdeZlf/jMmqsLTsa2tJGv09odv6emTyLwurkkd
         +pTRH2CyktCSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 4/4] ARM: findbit: fix overflowing offset
Date:   Mon,  1 Aug 2022 15:03:31 -0400
Message-Id: <20220801190331.3819791-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190331.3819791-1-sashal@kernel.org>
References: <20220801190331.3819791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit ec85bd369fd2bfaed6f45dd678706429d4f75b48 ]

When offset is larger than the size of the bit array, we should not
attempt to access the array as we can perform an access beyond the
end of the array. Fix this by changing the pre-condition.

Using "cmp r2, r1; bhs ..." covers us for the size == 0 case, since
this will always take the branch when r1 is zero, irrespective of
the value of r2. This means we can fix this bug without adding any
additional code!

Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/lib/findbit.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
index 7848780e8834..20fef6c41f6f 100644
--- a/arch/arm/lib/findbit.S
+++ b/arch/arm/lib/findbit.S
@@ -43,8 +43,8 @@ ENDPROC(_find_first_zero_bit_le)
  * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
  */
 ENTRY(_find_next_zero_bit_le)
-		teq	r1, #0
-		beq	3b
+		cmp	r2, r1
+		bhs	3b
 		ands	ip, r2, #7
 		beq	1b			@ If new byte, goto old routine
  ARM(		ldrb	r3, [r0, r2, lsr #3]	)
@@ -84,8 +84,8 @@ ENDPROC(_find_first_bit_le)
  * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
  */
 ENTRY(_find_next_bit_le)
-		teq	r1, #0
-		beq	3b
+		cmp	r2, r1
+		bhs	3b
 		ands	ip, r2, #7
 		beq	1b			@ If new byte, goto old routine
  ARM(		ldrb	r3, [r0, r2, lsr #3]	)
@@ -118,8 +118,8 @@ ENTRY(_find_first_zero_bit_be)
 ENDPROC(_find_first_zero_bit_be)
 
 ENTRY(_find_next_zero_bit_be)
-		teq	r1, #0
-		beq	3b
+		cmp	r2, r1
+		bhs	3b
 		ands	ip, r2, #7
 		beq	1b			@ If new byte, goto old routine
 		eor	r3, r2, #0x18		@ big endian byte ordering
@@ -152,8 +152,8 @@ ENTRY(_find_first_bit_be)
 ENDPROC(_find_first_bit_be)
 
 ENTRY(_find_next_bit_be)
-		teq	r1, #0
-		beq	3b
+		cmp	r2, r1
+		bhs	3b
 		ands	ip, r2, #7
 		beq	1b			@ If new byte, goto old routine
 		eor	r3, r2, #0x18		@ big endian byte ordering
-- 
2.35.1

