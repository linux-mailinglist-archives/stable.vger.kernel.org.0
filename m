Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558B0811A3
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfHEFct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:32:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42041 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:32:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E5BAD2104C;
        Mon,  5 Aug 2019 01:32:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Utieei
        DDb9/gyPzQJPpfHwgGVzOCZeKzisY/CgcFm6k=; b=ntfSWrf1Y26qEoypMCTy6r
        Pya1qYm7VqQ5Fko+4H8HE3lvVaszb36HtgWjaIO0Ut8yfmLdZ69xkBjdCq4tcWei
        dchkRieeAVwmeNJjr45NN07gqKkr/IAPFT6sz+nrySkIjX3TkjKzVYytJPT2DhHv
        euJjNsr7SbazApl7O4n78wC9NGSWwfVmFOEriG7AtOe+Z62poL70rkY25vo5Y+02
        eXqLbEgZW0T76SWxQA0QDy8jb1Qev+cxb8RVWV9y90W1dwYLf9VAb84xre1vYqwy
        UZDn+5XC6eSvWALb9GaWOyljm3+fxtwtRfWdQVYsEGdyj+DZeQ5sAPTcMo8dsqGg
        ==
X-ME-Sender: <xms:f79HXVwxKurpmjF2OdGdljMdr0p24CDfkF7_GmJfmqqwuuIVXtmaKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:f79HXYIOq9NDhG1UWljCJfB6wnWHkTVgwkmiQcxhD5sAggwtAjAMAA>
    <xmx:f79HXQKZKcyBwi5TITDJaR5kotKxe9yUd4E6O6iWlua4iS_IQW6GEQ>
    <xmx:f79HXZXHwkg-mDIUSgDT0J8RPQZXNVZMvItFk0qLn6WhCeokh6Feyg>
    <xmx:f79HXfqkpegXnrNA-Tih1IX7YqdCI0wCoSahr8357Cdm3DltcIol9g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53737380074;
        Mon,  5 Aug 2019 01:32:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: cpufeature: Fix feature comparison for" failed to apply to 4.14-stable tree
To:     will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:32:46 +0200
Message-ID: <156498316678190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 147b9635e6347104b91f48ca9dca61eb0fbf2a54 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Tue, 30 Jul 2019 15:40:20 +0100
Subject: [PATCH] arm64: cpufeature: Fix feature comparison for
 CTR_EL0.{CWG,ERG}

If CTR_EL0.{CWG,ERG} are 0b0000 then they must be interpreted to have
their architecturally maximum values, which defeats the use of
FTR_HIGHER_SAFE when sanitising CPU ID registers on heterogeneous
machines.

Introduce FTR_HIGHER_OR_ZERO_SAFE so that these fields effectively
saturate at zero.

Fixes: 3c739b571084 ("arm64: Keep track of CPU feature registers")
Cc: <stable@vger.kernel.org> # 4.4.x-
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 407e2bf23676..c96ffa4722d3 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -35,9 +35,10 @@
  */
 
 enum ftr_type {
-	FTR_EXACT,	/* Use a predefined safe value */
-	FTR_LOWER_SAFE,	/* Smaller value is safe */
-	FTR_HIGHER_SAFE,/* Bigger value is safe */
+	FTR_EXACT,			/* Use a predefined safe value */
+	FTR_LOWER_SAFE,			/* Smaller value is safe */
+	FTR_HIGHER_SAFE,		/* Bigger value is safe */
+	FTR_HIGHER_OR_ZERO_SAFE,	/* Bigger value is safe, but 0 is biggest */
 };
 
 #define FTR_STRICT	true	/* SANITY check strict matching required */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f29f36a65175..d19d14ba9ae4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -225,8 +225,8 @@ static const struct arm64_ftr_bits ftr_ctr[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1), /* RES1 */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DIC_SHIFT, 1, 1),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_IDC_SHIFT, 1, 1),
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_CWG_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_ERG_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, CTR_CWG_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, CTR_ERG_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DMINLINE_SHIFT, 4, 1),
 	/*
 	 * Linux can handle differing I-cache policies. Userspace JITs will
@@ -468,6 +468,10 @@ static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 	case FTR_LOWER_SAFE:
 		ret = new < cur ? new : cur;
 		break;
+	case FTR_HIGHER_OR_ZERO_SAFE:
+		if (!cur || !new)
+			break;
+		/* Fallthrough */
 	case FTR_HIGHER_SAFE:
 		ret = new > cur ? new : cur;
 		break;

