Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E621461E09
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378637AbhK2Sbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbhK2S3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1358CB815DD;
        Mon, 29 Nov 2021 18:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA2AC53FAD;
        Mon, 29 Nov 2021 18:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210391;
        bh=T5enEzDvju4eqCRp0+9vRIMXYcHCbrA99eRuEQa7wIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lt63gUVWdDK1Mq4pMG6bqvcZASatryz/yAtZI6sAa8meQSNqts2FJ7APHV8x49HVw
         Tw2GzyRwxbvrNaMHRzOR2I06gWX8EaZNXSqRdMigKm+diDuJEMqUSWe4Fv/won4Pvd
         EmPL9vg25K6NfyR5PK1zATeMjcVuPCHIx46KJvFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 70/92] MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48
Date:   Mon, 29 Nov 2021 19:18:39 +0100
Message-Id: <20211129181709.742071547@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index 9749818eed6d6..2811ecc1f3c71 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3059,7 +3059,7 @@ config STACKTRACE_SUPPORT
 config PGTABLE_LEVELS
 	int
 	default 4 if PAGE_SIZE_4KB && MIPS_VA_BITS_48
-	default 3 if 64BIT && !PAGE_SIZE_64KB
+	default 3 if 64BIT && (!PAGE_SIZE_64KB || MIPS_VA_BITS_48)
 	default 2
 
 config MIPS_AUTO_PFN_OFFSET
-- 
2.33.0



