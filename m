Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296992473D9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388688AbgHQTBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729827AbgHQPrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F862245C;
        Mon, 17 Aug 2020 15:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679252;
        bh=2l1aXrljkjYFuI4PbaHOVTIBQO+WIICFSgJ/wbYeAwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnNbIh2g3SM1AqGXNQxo/Hqdli2rXm4V8xT8bcoF3DldqX6OtnM+9Y5mfuaNmLrMa
         qxExwi4DrEpqCpOuoCwwh/E+A69Ugh0ml2pX9uOHnDjoLyE5vh+KiahR4meYB02wLW
         Af+jpTD8f0pQ492R4vg8xw47/XPuQEeKlnFYUJ7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 147/393] powerpc/mm: Fix typo in IS_ENABLED()
Date:   Mon, 17 Aug 2020 17:13:17 +0200
Message-Id: <20200817143826.743412477@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

[ Upstream commit 55bd9ac468397c4f12a33b7ec714b5d0362c3aa2 ]

IS_ENABLED() matches names exactly, so the missing "CONFIG_" prefix
means this code would never be built.

Also fixes a missing newline in pr_warn().

Fixes: 970d54f99cea ("powerpc/book3s64/hash: Disable 16M linear mapping size if not aligned")
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/202006050717.A2F9809E@keescook
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 8ed2411c3f395..cf2e1b06e5d48 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -660,11 +660,10 @@ static void __init htab_init_page_sizes(void)
 		 * Pick a size for the linear mapping. Currently, we only
 		 * support 16M, 1M and 4K which is the default
 		 */
-		if (IS_ENABLED(STRICT_KERNEL_RWX) &&
+		if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX) &&
 		    (unsigned long)_stext % 0x1000000) {
 			if (mmu_psize_defs[MMU_PAGE_16M].shift)
-				pr_warn("Kernel not 16M aligned, "
-					"disabling 16M linear map alignment");
+				pr_warn("Kernel not 16M aligned, disabling 16M linear map alignment\n");
 			aligned = false;
 		}
 
-- 
2.25.1



