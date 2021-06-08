Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49383A000C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhFHSip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhFHSgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:36:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD242613AC;
        Tue,  8 Jun 2021 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177171;
        bh=podLt0Q3vRWbWw6k5D1sRvkgt8TqwjcT4GxfTMqQ2H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeF0CboJNHbg0RTI8AaKiQ737MWk7PROJl5dTSPY/YN/Bm1FAUssAtUqwz53FhhxS
         ipUmduiT+yt3qpoLWQvOqLKLh+7PNp9yPg4UTQfTsq495ff3wfDdIq5xK4PiwFbseA
         IzRf2Ox+X0WBsvsVOEOo9goRkqRrReJpZmkk8EUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/58] efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared
Date:   Tue,  8 Jun 2021 20:26:45 +0200
Message-Id: <20210608175932.415213638@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
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
index aac972b056d9..e0889922cc6d 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -69,11 +69,6 @@ static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
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



