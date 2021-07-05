Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA123BC0BA
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhGEPhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233192AbhGEPgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AE7C61A30;
        Mon,  5 Jul 2021 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499115;
        bh=b4Yuh9ZXGTBdk6of/NfxeZDGAlGbAWPMhlBaB7ZNN9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCJPWXFVgB0oPmXXYL8pf44XyaROplYoXqhhaAt9IsQmxF4gBIxNpKsyxYAY3F1m0
         ypDlkfkOCctdLCyjKw8z33CM9FFcccyemfrM/bMUMjCvD/OcKYkHIwnEOYVwzqMFYO
         w3/2R/M06XS+4gVfXKqbxLDo2NUKWOG2MnbNORO7zro9ZeYpeCkDo6pyhegrhC0vy0
         +UT+0XvpS0zPGN1oITzLGka87Ng4e6WCu+nHKzN2SJ5CGmXU8qqK+Eha6lMVPGfX7s
         K7RqjsAvTncfgULEmtmDvb/+JEFkCJ6F1Y8Hc6lcO6ODYBtctTDpQpMk+ypfv5RGXy
         jrV2/ZSqZ+Dcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/15] ia64: mca_drv: fix incorrect array size calculation
Date:   Mon,  5 Jul 2021 11:31:36 -0400
Message-Id: <20210705153136.1522245-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c5f320ff8a79501bb59338278336ec43acb9d7e2 ]

gcc points out a mistake in the mca driver that goes back to before the
git history:

arch/ia64/kernel/mca_drv.c: In function 'init_record_index_pools':
arch/ia64/kernel/mca_drv.c:346:54: error: expression does not compute the number of elements in this array; element typ
e is 'int', not 'size_t' {aka 'long unsigned int'} [-Werror=sizeof-array-div]
  346 |         for (i = 1; i < sizeof sal_log_sect_min_sizes/sizeof(size_t); i++)
      |                                                      ^

This is the same as sizeof(size_t), which is two shorter than the actual
array.  Use the ARRAY_SIZE() macro to get the correct calculation instead.

Link: https://lkml.kernel.org/r/20210514214123.875971-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/mca_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 94f8bf777afa..3503d488e9b3 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -343,7 +343,7 @@ init_record_index_pools(void)
 
 	/* - 2 - */
 	sect_min_size = sal_log_sect_min_sizes[0];
-	for (i = 1; i < sizeof sal_log_sect_min_sizes/sizeof(size_t); i++)
+	for (i = 1; i < ARRAY_SIZE(sal_log_sect_min_sizes); i++)
 		if (sect_min_size > sal_log_sect_min_sizes[i])
 			sect_min_size = sal_log_sect_min_sizes[i];
 
-- 
2.30.2

