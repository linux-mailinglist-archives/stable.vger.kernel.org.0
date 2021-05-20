Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876C738A7CA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbhETKmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237363AbhETKks (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:40:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45280613F7;
        Thu, 20 May 2021 09:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504547;
        bh=7oYuLHNwzc9jy8+tx7Q4sSHTjfKDMdJFbkcaYmc36R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt6rtNO53EfDdl6rcL7GB4hGEPpt2MXToREy5k679TRROcJxJQPjZSGFZUxGiRV3O
         2O5dc41MySFcCFiLIrtZqXk7il01Ay9NfH436sMTh9xG77IJWyCg+sR+Kfd4F9XZ3e
         HvZJJpSsvnSdSEQXRVYie4Wq8iaKqLvw+7er8lho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.14 295/323] MIPS: Avoid DIVU in `__div64_32 is result would be zero
Date:   Thu, 20 May 2021 11:23:07 +0200
Message-Id: <20210520092130.318513588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit c1d337d45ec0a802299688e17d568c4e3a585895 upstream.

We already check the high part of the divident against zero to avoid the
costly DIVU instruction in that case, needed to reduce the high part of
the divident, so we may well check against the divisor instead and set
the high part of the quotient to zero right away.  We need to treat the
high part the divident in that case though as the remainder that would
be calculated by the DIVU instruction we avoided.

This has passed correctness verification with test_div64 and reduced the
module's average execution time down to 1.0445s and 0.2619s from 1.0668s
and 0.2629s respectively for an R3400 CPU @40MHz and a 5Kc CPU @160MHz.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/div64.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
@@ -68,9 +68,11 @@
 									\
 	__high = __div >> 32;						\
 	__low = __div;							\
-	__upper = __high;						\
 									\
-	if (__high) {							\
+	if (__high < __radix) {						\
+		__upper = __high;					\
+		__high = 0;						\
+	} else {							\
 		__asm__("divu	$0, %z1, %z2"				\
 		: "=x" (__modquot)					\
 		: "Jr" (__high), "Jr" (__radix));			\


