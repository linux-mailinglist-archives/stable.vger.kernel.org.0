Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861E3328F44
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242219AbhCATsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235942AbhCATjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:39:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E0B764F0D;
        Mon,  1 Mar 2021 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620925;
        bh=16Xium9/mJhPOnQgINPgCCZJEyE+4Txv8T3M1DusMBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKllmwcKdxU81gq27nmTFKMGZEVcX7/kcNFsdsbJ2smQ5t8DkuFhER3C55Rpg4M+P
         vWJmyXNF8VcJizTEOEezuJN1MyhwkQadHEI8ezyuNHJ+gxxclBCpNJezCFsiGMOJ8J
         deH5QofTWgIhesM94W0lP+GdCUdrrd/AOTtTnt1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 328/775] dmaengine: qcom: Always inline gpi_update_reg
Date:   Mon,  1 Mar 2021 17:08:16 +0100
Message-Id: <20210301161217.829947027@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 0a6d3038d914b51d6860f23ea2b508590e8340de ]

When building with CONFIG_UBSAN_UNSIGNED_OVERFLOW, clang decides not to
inline gpi_update_reg, which causes a linkage failure around __bad_mask:

ld.lld: error: undefined symbol: __bad_mask
>>> referenced by bitfield.h:119 (include/linux/bitfield.h:119)
>>>               dma/qcom/gpi.o:(gpi_update_reg) in archive drivers/built-in.a
>>> referenced by bitfield.h:119 (include/linux/bitfield.h:119)
>>>               dma/qcom/gpi.o:(gpi_update_reg) in archive drivers/built-in.a

If gpi_update_reg is not inlined, the mask value will not be known at
compile time so the check in field_multiplier stays in the final
object file, causing the above linkage failure. Always inline
gpi_update_reg so that this check can never fail.

Fixes: 5d0c3533a19f ("dmaengine: qcom: Add GPI dma driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1243
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20210112191214.1264793-1-natechancellor@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/gpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/qcom/gpi.c b/drivers/dma/qcom/gpi.c
index 1a0bf6b0567a5..e48eb397f433d 100644
--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -584,7 +584,7 @@ static inline void gpi_write_reg_field(struct gpii *gpii, void __iomem *addr,
 	gpi_write_reg(gpii, addr, val);
 }
 
-static inline void
+static __always_inline void
 gpi_update_reg(struct gpii *gpii, u32 offset, u32 mask, u32 val)
 {
 	void __iomem *addr = gpii->regs + offset;
-- 
2.27.0



