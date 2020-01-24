Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD3F14828A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387874AbgAXL3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391768AbgAXL3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:03 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D60E20704;
        Fri, 24 Jan 2020 11:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865343;
        bh=qCRfSDyxX8ddBJkJ1Nhmhf7hJPevwkuUZYm+NW2GXxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTbgWmpFvm1rNgHN9a6wDh7hBELOKqspYid+SrghGWMPAdGslxUmI/BtB1OD8hpYr
         358RQvEgN8PHSnKrUvDfExdrb7dWc26gqsjcmvKAwWenQBy1jQnIU9SDrfejH2Vwcp
         vpVKIiWdxhRH/6HeNc8jJeC07HRrRI4GyJO5JLfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 520/639] ARM: 8896/1: VDSO: Dont leak kernel addresses
Date:   Fri, 24 Jan 2020 10:31:30 +0100
Message-Id: <20200124093153.931381442@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 3e07590e7248db951fed6a2039403b5a39010be7 ]

Since commit ad67b74d2469d9b8 ("printk: hash addresses printed with
%p"), an obfuscated kernel pointer is printed at every boot if
debugging is enabled:

    vdso: 1 text pages at base (____ptrval____)

Remove the print completely, as it's useless without the address.

Based on commit 0f1bf7e39822476b ("arm64/vdso: don't leak kernel
addresses").

Fixes: ad67b74d2469d9b8 ("printk: hash addresses printed with %p")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/vdso.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
index f4dd7f9663c10..e8cda5e02b4ea 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -205,7 +205,6 @@ static int __init vdso_init(void)
 	}
 
 	text_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
-	pr_debug("vdso: %i text pages at base %p\n", text_pages, vdso_start);
 
 	/* Allocate the VDSO text pagelist */
 	vdso_text_pagelist = kcalloc(text_pages, sizeof(struct page *),
-- 
2.20.1



