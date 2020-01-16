Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5A713E402
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAPRFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388720AbgAPRF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A03E72077B;
        Thu, 16 Jan 2020 17:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194328;
        bh=A6Z7jOfd+OQTDKe1kq58OeNgsQqWUkVXWSp8srLhlIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzlqwGPB7jsNwvb30iPS+PEdmVSY0tLg/JxV9pvMNgpx6XGtj3oghgDvRhWfrNjM5
         Auxk6GyzZ9E9+KTK0in3e3IhMghzUv3NKXEVqfzaWIEfVeoxOKT1ctIMNqkUubWl41
         FeUX6Cox+5sET37hnvmBFRppgQh2NUSQJxR+RMRA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matteo Croce <mcroce@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 276/671] arm64/vdso: don't leak kernel addresses
Date:   Thu, 16 Jan 2020 11:58:34 -0500
Message-Id: <20200116170509.12787-13-sashal@kernel.org>
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

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit 0f1bf7e39822476b2f921435cf990f67a61f5f92 ]

Since commit ad67b74d2469d9b8 ("printk: hash addresses printed with %p"),
two obfuscated kernel pointer are printed at every boot:

    vdso: 2 pages (1 code @ (____ptrval____), 1 data @ (____ptrval____))

Remove the the print completely, as it's useless without the addresses.

Fixes: ad67b74d2469d9b8 ("printk: hash addresses printed with %p")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index ec0bb588d755..42b7082029e1 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -146,8 +146,6 @@ static int __init vdso_init(void)
 	}
 
 	vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
-	pr_info("vdso: %ld pages (%ld code @ %p, %ld data @ %p)\n",
-		vdso_pages + 1, vdso_pages, vdso_start, 1L, vdso_data);
 
 	/* Allocate the vDSO pagelist, plus a page for the data. */
 	vdso_pagelist = kcalloc(vdso_pages + 1, sizeof(struct page *),
-- 
2.20.1

