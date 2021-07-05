Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2E33BC106
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhGEPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233127AbhGEPhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:37:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B575D6199F;
        Mon,  5 Jul 2021 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499137;
        bh=b4Yuh9ZXGTBdk6of/NfxeZDGAlGbAWPMhlBaB7ZNN9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBpXU6aGmQRxqPm4h1tC5XbCaKW96/4RjRuoIrWsNyqMc71R+ZhdXSqrwjlTCA96l
         v7GTRjeqoNJQFGrnNmGOwcWHnonzhSkD/3HxfEZfwfrZhq/GgvxFdv32slMQ2TgiMy
         T8G9DeHvOXSDZ7y7ea7d+C23VvgQMfKXyNiHIuEqBjNbjceqSZzTBld45xU6rpp/4W
         VO8cf+3+Ld2a703bukB+GofAcVDSXbMFauSbkzYdT0Z7Qyd3F6OW720HNOOLX+AHwy
         PPakaVZ9V/eE/Nk62oiqAIgMhDNfl76MVCY5Xux0hswGkR1M2mA6JBkoZguR8jl9qA
         Fuq7ndKyh10GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 7/7] ia64: mca_drv: fix incorrect array size calculation
Date:   Mon,  5 Jul 2021 11:32:07 -0400
Message-Id: <20210705153208.1522553-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153208.1522553-1-sashal@kernel.org>
References: <20210705153208.1522553-1-sashal@kernel.org>
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

