Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3ED39FF44
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhFHSbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233837AbhFHSb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1DE4613C0;
        Tue,  8 Jun 2021 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176972;
        bh=2Db6rkopF7ONkmAIqwKKfx8ojq70/evfbaVxzrTkLWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGJa0Ua4MnRyq6wE9L70p9OF9xaKu9yDSQn2d3p9Q1awNJ7IEhgpuu9wU9aOyGPvq
         R0Ok1wHjQudtdylfO2tkXxqBpGvDRhBQTIXwqSX2BnhsxkEV6Y8U4kN9Kjdue9EFGI
         uF1Fq0qAMBRcZkWHHQVDiNriGT3qQ6SProiQ+44A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/29] efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared
Date:   Tue,  8 Jun 2021 20:26:56 +0200
Message-Id: <20210608175927.901577449@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
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
index 9faa09e7c31f..c2b991b9fa9e 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -68,11 +68,6 @@ static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
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



