Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AB03A01AF
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbhFHSzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234084AbhFHSwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 844EB61351;
        Tue,  8 Jun 2021 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177625;
        bh=FxkRkH0E9G2XWpm2+AFFrGDy/r8ng+80Ved7jl4n/NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzo2VatruiG3nG17JDIbXv6CrEvOifUcaanuy9l8JzCHFCXekvx1UVnb9QjiFt3Hs
         lcz1uk8NwJMFgCCF/aJFu4bVkVyJiwJx9mqNeg/WFoPa5gFwzK3p9TJ5o63hoTTKiB
         5laOjJEILS6Q8Xn7FhgM69FTHGKqoKqpTHd6cxqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/137] efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared
Date:   Tue,  8 Jun 2021 20:25:47 +0200
Message-Id: <20210608175942.635782102@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
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
index 5737cb0fcd44..0a9aba5f9cef 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -67,11 +67,6 @@ static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
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



