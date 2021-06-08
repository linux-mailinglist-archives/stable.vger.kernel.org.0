Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBC93A00B6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhFHSqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhFHSoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D56160FEA;
        Tue,  8 Jun 2021 18:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177396;
        bh=tWjMsLeOtb/NYgMrbgElfA9i5rrsbAZrDJrx7GY7N70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCoPwJyvYbo7b9ce3U8VW6O30gxYwCAVYPynlLev7l3UHTW4DgU2VhIQw+IHfFCPO
         09CSuNEW521FGIT56ulV0w0/+o0S87Iu08kJWxs3qDOqDeVwNvCshFdKBjfQZy7gOa
         RWf8i5mr7tVfjuO38IUSinfeIP5qofFe6A12SaWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/78] efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared
Date:   Tue,  8 Jun 2021 20:26:36 +0200
Message-Id: <20210608175935.513740979@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 45add3cc99feaaf57d4b6f01d52d532c16a1caee ]

UEFI spec 2.9, p.108, table 4-1 lists the scenario that both attributes
are cleared with the description "No memory access protection is
possible for Entry". So we can have valid entries where both attributes
are cleared, so remove the check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Fixes: 10f0d2f577053 ("efi: Implement generic support for the Memory Attributes table")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/memattr.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index 58452fde92cc..5d343dc8e535 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -66,11 +66,6 @@ static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
 		return false;
 	}
 
-	if (!(in->attribute & (EFI_MEMORY_RO | EFI_MEMORY_XP))) {
-		pr_warn("Entry attributes invalid: RO and XP bits both cleared\n");
-		return false;
-	}
-
 	if (PAGE_SIZE > EFI_PAGE_SIZE &&
 	    (!PAGE_ALIGNED(in->phys_addr) ||
 	     !PAGE_ALIGNED(in->num_pages << EFI_PAGE_SHIFT))) {
-- 
2.30.2



