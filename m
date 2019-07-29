Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0A79803
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfG2TmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbfG2TmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:42:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0222171F;
        Mon, 29 Jul 2019 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429326;
        bh=Pc4AGbWAnFsdeRUAkr5mSLk9VgIA/HBJyrByJg+IG1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1R5DrQVvoJi1iIip6RGRe0y+k6hsQWSa7ajqlFMXVSZEuWd37tm8JHQMH3gz7vNl
         rZYORuVRImJfet+fRCtvMB021TTKDBcnKXPnvKEuoKA6LZc5aRsb1tyLgm8pICW5uy
         ZW899NuQzUN25We6fOT0h13kecVmprUfpw2uxIi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/113] arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64_HAS_RAS
Date:   Mon, 29 Jul 2019 21:22:28 +0200
Message-Id: <20190729190710.058948087@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2b68a2a963a157f024c67c0697b16f5f792c8a35 ]

The ESB-instruction is a nop on CPUs that don't implement the RAS
extensions. This lets us use it in places like the vectors without
having to use alternatives.

If someone disables CONFIG_ARM64_RAS_EXTN, this instruction still has
its RAS extensions behaviour, but we no longer read DISR_EL1 as this
register does depend on alternatives.

This could go wrong if we want to synchronize an SError from a KVM
guest. On a CPU that has the RAS extensions, but the KConfig option
was disabled, we consume the pending SError with no chance of ever
reading it.

Hide the ESB-instruction behind the CONFIG_ARM64_RAS_EXTN option,
outputting a regular nop if the feature has been disabled.

Reported-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index f90f5d83b228..5a97ac853168 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -112,7 +112,11 @@
  * RAS Error Synchronization barrier
  */
 	.macro  esb
+#ifdef CONFIG_ARM64_RAS_EXTN
 	hint    #16
+#else
+	nop
+#endif
 	.endm
 
 /*
-- 
2.20.1



