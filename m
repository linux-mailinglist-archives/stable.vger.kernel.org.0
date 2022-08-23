Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB0C59E2E3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354325AbiHWKY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354347AbiHWKVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB10381B16;
        Tue, 23 Aug 2022 02:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84D016157D;
        Tue, 23 Aug 2022 09:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EBEC433C1;
        Tue, 23 Aug 2022 09:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245354;
        bh=5F3L1hqSN/7exQ2u/UxDEhO+Ah+rnMqDKqPMrqS7AEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUS76DFmvKCheWThEAirjn6ZL9WaXMi4hWQxXyw5zun0/xKXPgctpM9fOP5XkrDaT
         KGu5RUKNImL1DDtYCfMzSyBW+HrRj48Y8XLVQYFWb93vniPkB1IavFdT9YEipgTciw
         mpR/PTxCBecYY+5YGDhbpZuNgGJOfDE1XCWjC+3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/287] ARM: findbit: fix overflowing offset
Date:   Tue, 23 Aug 2022 10:23:42 +0200
Message-Id: <20220823080102.024799738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

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



