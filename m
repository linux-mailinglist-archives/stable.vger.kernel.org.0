Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F9599F3E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350690AbiHSP44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350949AbiHSP4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:56:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED37810447B;
        Fri, 19 Aug 2022 08:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB86F616FD;
        Fri, 19 Aug 2022 15:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0293DC433D6;
        Fri, 19 Aug 2022 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924254;
        bh=lC1PDtOD4kVcf3eDjo4yBR1rOPmdYM1OQZgn1WPyCNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQTSmdZMjeLzLNqmEJQ4RHvDvI9/SpPj8PGUesEpHBHB0QIdelVnR4S6W2anmeZrJ
         DpGYJpDHhJTwAYjvYJhKYUYzxVd2k7qQdnY/yhiQQnTnGeGodaFfuhjgtpEFvqZ+5e
         HSjohDrLIDRhsBO7XBjdyxqYj/odRbKfFbor1/7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/545] ARM: findbit: fix overflowing offset
Date:   Fri, 19 Aug 2022 17:37:58 +0200
Message-Id: <20220819153834.132913415@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index b5e8b9ae4c7d..7fd3600db8ef 100644
--- a/arch/arm/lib/findbit.S
+++ b/arch/arm/lib/findbit.S
@@ -40,8 +40,8 @@ ENDPROC(_find_first_zero_bit_le)
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
@@ -81,8 +81,8 @@ ENDPROC(_find_first_bit_le)
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
@@ -115,8 +115,8 @@ ENTRY(_find_first_zero_bit_be)
 ENDPROC(_find_first_zero_bit_be)
 
 ENTRY(_find_next_zero_bit_be)
-		teq	r1, #0
-		beq	3b
+		cmp	r2, r1
+		bhs	3b
 		ands	ip, r2, #7
 		beq	1b			@ If new byte, goto old routine
 		eor	r3, r2, #0x18		@ big endian byte ordering
@@ -149,8 +149,8 @@ ENTRY(_find_first_bit_be)
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



