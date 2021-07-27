Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1325A3D8376
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 00:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhG0W5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 18:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhG0W5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 18:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 550AE60F90;
        Tue, 27 Jul 2021 22:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627426636;
        bh=I5lctJVtilD0zOL0uvLUTsKd+U244CLKM1e4SusUdUE=;
        h=From:To:Cc:Subject:Date:From;
        b=sXr1QkRUu5pWTFjp9CRaOFjRvVWsUPZkqhrPd3E44MDsUtkwL1JZhxhq/dbVuYSjY
         92CE2EiqkUIWDhrQMo/fNMFFkRbrTMIDIBJeDlL9Ol/jBZsY+KxF3nTwDEjqBulwl+
         YPQ2H4WPYwDRsMgoVcoox2XKKDI76Fo2Oj6XOOGUsbjASqiMeAYe3bWTk0pSuOTNoL
         GsW6dtt47Dl7mvoBduLRNUjvb4L82597sr56L4OtNUWgZyuTc7hkjbXNWy18mUnSOb
         aN6oTi/B76AxKeZIQJ/KTB/qPBLkFR7N1iMCnntJuoc6BqroKYrWKNpRIvXvf0+5fi
         CzJhsDbkXkSyw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Andrey Ryabinin <arbn@yandex-team.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 4.9 1/2] iommu/amd: Fix backport of 140456f994195b568ecd7fc2287a34eadffef3ca
Date:   Tue, 27 Jul 2021 15:56:49 -0700
Message-Id: <20210727225650.726875-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.264.g75ae10bc75
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clang warns:

drivers/iommu/amd_iommu.c:1335:6: warning: variable 'flags' is used
uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
        if (!pte)
            ^~~~
drivers/iommu/amd_iommu.c:1352:40: note: uninitialized use occurs here
        spin_unlock_irqrestore(&domain->lock, flags);
                                              ^~~~~
drivers/iommu/amd_iommu.c:1335:2: note: remove the 'if' if its condition
is always false
        if (!pte)
        ^~~~~~~~~
drivers/iommu/amd_iommu.c:1331:21: note: initialize the variable 'flags'
to silence this warning
        unsigned long flags;
                           ^
                            = 0
1 warning generated.

The backport of commit 140456f99419 ("iommu/amd: Fix sleeping in atomic
in increase_address_space()") to 4.9 as commit 1d648460d7c5 ("iommu/amd:
Fix sleeping in atomic in increase_address_space()") failed to keep the
"return false", which in 4.9 needs to be a regular "return" due to a
lack of commit f15d9a992f90 ("iommu/amd: Remove domain->updated").

This resolves the warning and matches the 4.14-4.19 backport.

Cc: Andrey Ryabinin <arbn@yandex-team.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Fixes: 1d648460d7c5 ("iommu/amd: Fix sleeping in atomic in increase_address_space()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/iommu/amd_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 8377bd388d67..14e9b06829d5 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1333,7 +1333,7 @@ static void increase_address_space(struct protection_domain *domain,
 
 	pte = (void *)get_zeroed_page(gfp);
 	if (!pte)
-		goto out;
+		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
 

base-commit: 0db822f6dee813f746ed196fc561945eee4cd4b9
-- 
2.32.0.264.g75ae10bc75

