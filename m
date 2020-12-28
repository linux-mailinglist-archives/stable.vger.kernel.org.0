Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCF82E40F7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392484AbgL1PAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440286AbgL1ON5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E5722AAA;
        Mon, 28 Dec 2020 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164822;
        bh=z+/1Q0ebQr1TYmB6NIl35kKPnYKCKGArYFXs5zlAUiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5nG27qGwrXXGGhZthq48Ht7ACh25ke21Sq2yxLmZweEcp2qsoVsYzCIxJmQRmj2l
         RwebNbb3pwirZ0mvCbYCnoR3ARWKViaUKtOSfqqrZhzvwc9kLapnpW2FzUHCay4mkv
         csIRk/BzdMzdFIzdA0jNxrgPRpMvuu7p9j5H6wQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/717] powerpc/64: Fix an EMIT_BUG_ENTRY in head_64.S
Date:   Mon, 28 Dec 2020 13:44:38 +0100
Message-Id: <20201228125034.437621766@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit fe18a35e685c9bdabc8b11b3e19deb85a068b75d ]

Commit 63ce271b5e37 ("powerpc/prom: convert PROM_BUG() to standard
trap") added an EMIT_BUG_ENTRY for the trap after the branch to
start_kernel(). The EMIT_BUG_ENTRY was for the address "0b", however the
trap was not labeled with "0". Hence the address used for bug is in
relative_toc() where the previous "0" label is. Label the trap as "0" so
the correct address is used.

Fixes: 63ce271b5e37 ("powerpc/prom: convert PROM_BUG() to standard trap")
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201130004404.30953-1-jniethe5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 7b7c8c5ee6602..2d6581db0c7b6 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -990,7 +990,7 @@ start_here_common:
 	bl	start_kernel
 
 	/* Not reached */
-	trap
+0:	trap
 	EMIT_BUG_ENTRY 0b, __FILE__, __LINE__, 0
 	.previous
 
-- 
2.27.0



