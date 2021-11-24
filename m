Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6854045C0C7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346905AbhKXNLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344995AbhKXNJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E19613A7;
        Wed, 24 Nov 2021 12:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757653;
        bh=l2rqRYqbJxvKx+Xt1wp0A5WyzTXuYc54kSpde7tb8Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkCLWx24NA1ppbC49XD7rTOm3HXAcyn/aD6/Jlwu1VwRRer8OQ3+PXM9l5LRjMQ7d
         C4qVuxWbBuWCZmlY6T1kdFaHZLPoOrU3e56/8L2KBnjZQQA2124fKNtSLE59EHZZDJ
         07nE1JDsv7TJpyzq2uGqKglPmapBmtEVZx4CYtnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 233/323] ARM: 9155/1: fix early early_iounmap()
Date:   Wed, 24 Nov 2021 12:57:03 +0100
Message-Id: <20211124115726.788908755@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 0d08e7bf0d0d1a29aff7b16ef516f7415eb1aa05 upstream.

Currently __set_fixmap() bails out with a warning when called in early boot
from early_iounmap(). Fix it, and while at it, make the comment a bit easier
to understand.

Cc: <stable@vger.kernel.org>
Fixes: b089c31c519c ("ARM: 8667/3: Fix memory attribute inconsistencies when using fixmap")
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -416,9 +416,9 @@ void __set_fixmap(enum fixed_addresses i
 		     FIXADDR_END);
 	BUG_ON(idx >= __end_of_fixed_addresses);
 
-	/* we only support device mappings until pgprot_kernel has been set */
+	/* We support only device mappings before pgprot_kernel is set. */
 	if (WARN_ON(pgprot_val(prot) != pgprot_val(FIXMAP_PAGE_IO) &&
-		    pgprot_val(pgprot_kernel) == 0))
+		    pgprot_val(prot) && pgprot_val(pgprot_kernel) == 0))
 		return;
 
 	if (pgprot_val(prot))


