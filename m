Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2979F3DD7AE
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhHBNrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234262AbhHBNrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C738560527;
        Mon,  2 Aug 2021 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912013;
        bh=Gudp8J5W1gnJEbJwes9Zn2naYxoaEFxWmhDv7mTC0Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jn2otSIUwbT7JHpbXRT63fOnUAWHWXoyVNYo8MsADJ/ys2L0bPoLrDZEhcHsPdjUM
         xVnwVkLG9XAToSApqRNhKIHo96RU9nnO+Zfzj2G9qg2HjPe6ScTb0OD94b0Y8zK3cQ
         7r3pRYElN7EDKkSEpQwZmKs0QcikWW4WCBXllIbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <arbn@yandex-team.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.9 01/32] iommu/amd: Fix backport of 140456f994195b568ecd7fc2287a34eadffef3ca
Date:   Mon,  2 Aug 2021 15:44:21 +0200
Message-Id: <20210802134332.978902579@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

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
Acked-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1333,7 +1333,7 @@ static void increase_address_space(struc
 
 	pte = (void *)get_zeroed_page(gfp);
 	if (!pte)
-		goto out;
+		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
 


