Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98DA148499
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390283AbgAXLPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388378AbgAXLPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:30 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC42320708;
        Fri, 24 Jan 2020 11:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864529;
        bh=zEjikqgN+4XezL7ZwWvV/RPtGlMNwTf5fCbigx2ZWuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bu+/jYOM89ZRpDzD8bSXj8Fjsc8eUPdngPOYMXpFnfbM4qwKPdBxdtsJLIGnoSsxP
         LYn1MWR2Ha4l70sRZjUahMcL4dpI/VnTu6QHVikglzVLVA/0+sp2tMZ+v6aSBsZmZh
         3c/UAVatNjbXc84HuXRm9Z/7xbEa8qDyDU7krsRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Matteo Croce <mcroce@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 291/639] arm64/vdso: dont leak kernel addresses
Date:   Fri, 24 Jan 2020 10:27:41 +0100
Message-Id: <20200124093123.346392872@linuxfoundation.org>
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
index ec0bb588d7553..42b7082029e1d 100644
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



