Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA17452561
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350551AbhKPBuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240725AbhKOSQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:16:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01459632A4;
        Mon, 15 Nov 2021 17:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998609;
        bh=rpmqs0E2kthm5Kw+YgsqiMgz1VIMiyGZq7wev7TEZ7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcIfgdRGvR0Mqs+noYITPlLPvxIKZSCP3cjZDshhyo34ESTGReGKCv+4USX7GNEVU
         CUyVshbc6YUXiSfv0FJrAPePnCREaVE0mjclD0uJ05MUrlQc//TmxlsDSN4eUa6cG5
         cUL09ZkJVXiVI2TAYKHl6gezYNniqDMmLJqTIm4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 539/575] ARM: 9155/1: fix early early_iounmap()
Date:   Mon, 15 Nov 2021 18:04:24 +0100
Message-Id: <20211115165402.325821442@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
@@ -391,9 +391,9 @@ void __set_fixmap(enum fixed_addresses i
 		     FIXADDR_END);
 	BUG_ON(idx >= __end_of_fixed_addresses);
 
-	/* we only support device mappings until pgprot_kernel has been set */
+	/* We support only device mappings before pgprot_kernel is set. */
 	if (WARN_ON(pgprot_val(prot) != pgprot_val(FIXMAP_PAGE_IO) &&
-		    pgprot_val(pgprot_kernel) == 0))
+		    pgprot_val(prot) && pgprot_val(pgprot_kernel) == 0))
 		return;
 
 	if (pgprot_val(prot))


