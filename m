Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF70261C26
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbgIHTPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731187AbgIHQEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:04:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AABD421919;
        Tue,  8 Sep 2020 15:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579344;
        bh=ZjKWjBFa8jx2a1LkBVVi50zo2hxUJAg7OKt/hGAhRLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htl0xrJns/Pp0UfM96E84utMsGjDi1vo6QbdqAcJbi1WJf2QU1R8mXG5coQ/n07mp
         bEtxSVrpzo8cDXmY52/8SXSvkfH9i0LNlBOqO25To1bJuUybhXlDrtpQxHZpiucZM2
         H/uwVyZjsrgAPRClUAuXmyOvxY9cwJPDg5dQWrYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 038/186] fsldma: fix very broken 32-bit ppc ioread64 functionality
Date:   Tue,  8 Sep 2020 17:23:00 +0200
Message-Id: <20200908152243.525529018@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 0a4c56c80f90797e9b9f8426c6aae4c0cf1c9785 ]

Commit ef91bb196b0d ("kernel.h: Silence sparse warning in
lower_32_bits") caused new warnings to show in the fsldma driver, but
that commit was not to blame: it only exposed some very incorrect code
that tried to take the low 32 bits of an address.

That made no sense for multiple reasons, the most notable one being that
that code was intentionally limited to only 32-bit ppc builds, so "only
low 32 bits of an address" was completely nonsensical.  There were no
high bits to mask off to begin with.

But even more importantly fropm a correctness standpoint, turning the
address into an integer then caused the subsequent address arithmetic to
be completely wrong too, and the "+1" actually incremented the address
by one, rather than by four.

Which again was incorrect, since the code was reading two 32-bit values
and trying to make a 64-bit end result of it all.  Surprisingly, the
iowrite64() did not suffer from the same odd and incorrect model.

This code has never worked, but it's questionable whether anybody cared:
of the two users that actually read the 64-bit value (by way of some C
preprocessor hackery and eventually the 'get_cdar()' inline function),
one of them explicitly ignored the value, and the other one might just
happen to work despite the incorrect value being read.

This patch at least makes it not fail the build any more, and makes the
logic superficially sane.  Whether it makes any difference to the code
_working_ or not shall remain a mystery.

Compile-tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsldma.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index 56f18ae992332..308bed0a560ac 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -205,10 +205,10 @@ struct fsldma_chan {
 #else
 static u64 fsl_ioread64(const u64 __iomem *addr)
 {
-	u32 fsl_addr = lower_32_bits(addr);
-	u64 fsl_addr_hi = (u64)in_le32((u32 *)(fsl_addr + 1)) << 32;
+	u32 val_lo = in_le32((u32 __iomem *)addr);
+	u32 val_hi = in_le32((u32 __iomem *)addr + 1);
 
-	return fsl_addr_hi | in_le32((u32 *)fsl_addr);
+	return ((u64)val_hi << 32) + val_lo;
 }
 
 static void fsl_iowrite64(u64 val, u64 __iomem *addr)
@@ -219,10 +219,10 @@ static void fsl_iowrite64(u64 val, u64 __iomem *addr)
 
 static u64 fsl_ioread64be(const u64 __iomem *addr)
 {
-	u32 fsl_addr = lower_32_bits(addr);
-	u64 fsl_addr_hi = (u64)in_be32((u32 *)fsl_addr) << 32;
+	u32 val_hi = in_be32((u32 __iomem *)addr);
+	u32 val_lo = in_be32((u32 __iomem *)addr + 1);
 
-	return fsl_addr_hi | in_be32((u32 *)(fsl_addr + 1));
+	return ((u64)val_hi << 32) + val_lo;
 }
 
 static void fsl_iowrite64be(u64 val, u64 __iomem *addr)
-- 
2.25.1



