Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EFC461F48
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379961AbhK2Spc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:32 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56904 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380315AbhK2Snb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8EEB1CE13D4;
        Mon, 29 Nov 2021 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF20C53FAD;
        Mon, 29 Nov 2021 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211210;
        bh=MgxAahCUDdZzStYtfvViBiT8zF7MBgEgRPzPpedL6d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0YPJnov79NiUaHD0lO75caxHIHarJ/xhMlDx+9M9kGHE+iJqaFmKXfnShHtVY4Ey
         nqBY5rJaL8hMo0VpfY3OYbrIpGPc7I0TSwfeVABcA/hPdaMtVqTb0s148BWOI4ISV0
         +fs+s6ehKvdhbfv1bbp/Hk9AFE5IGuzJqEifF5x8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/179] MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48
Date:   Mon, 29 Nov 2021 19:18:56 +0100
Message-Id: <20211129181723.616732605@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit 41ce097f714401e6ad8f3f5eb30d7f91b0b5e495 ]

It hangup when booting Loongson 3A1000 with BOTH
CONFIG_PAGE_SIZE_64KB and CONFIG_MIPS_VA_BITS_48, that it turn
out to use 2-level pgtable instead of 3-level. 64KB page size
with 2-level pgtable only cover 42 bits VA, use 3-level pgtable
to cover all 48 bits VA(55 bits)

Fixes: 1e321fa917fb ("MIPS64: Support of at least 48 bits of SEGBITS)
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index a917d408d27d8..23654ccdbfb12 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3189,7 +3189,7 @@ config STACKTRACE_SUPPORT
 config PGTABLE_LEVELS
 	int
 	default 4 if PAGE_SIZE_4KB && MIPS_VA_BITS_48
-	default 3 if 64BIT && !PAGE_SIZE_64KB
+	default 3 if 64BIT && (!PAGE_SIZE_64KB || MIPS_VA_BITS_48)
 	default 2
 
 config MIPS_AUTO_PFN_OFFSET
-- 
2.33.0



