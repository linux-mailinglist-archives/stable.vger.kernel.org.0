Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C0713F3AE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388005AbgAPSo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390070AbgAPRKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D26924681;
        Thu, 16 Jan 2020 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194652;
        bh=kd2oORSfcd0NFsaqVRs4srB+IOVU7V1SjKKyE1YnOWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gM1FOUx3BwXl90dW6e7FwhjZs6MbeSjaSonbnI8JyP1+GsuelvsP3p2M6vx4zzWBD
         wVhL9oBcdN1sbrI4zqP0rYfcfQivarRuKliIJKXbuwjZ4GSRo9gimdSeIciVcUUlAX
         bE0HQrEGZsobWEvS2Bpt11sgfEidSnGGfw1MtI4M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 506/671] ARM: 8896/1: VDSO: Don't leak kernel addresses
Date:   Thu, 16 Jan 2020 12:02:24 -0500
Message-Id: <20200116170509.12787-243-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f4dd7f9663c1..e8cda5e02b4e 100644
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

