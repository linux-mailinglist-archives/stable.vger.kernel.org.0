Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99E2E676F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633223AbgL1QYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731328AbgL1NKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7989F208BA;
        Mon, 28 Dec 2020 13:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161000;
        bh=u0oCJXxMJ3xICbV8bdTrpRsE6r99GQjewMSFCa2WdC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe+gCFyXCgOm0B2xpNIaKB6KCERUNQzZeEFCQjVPPI90H7j7s8Fg85+I5+/f3rBmK
         ae8TxAVZ+4JnaekSkJnOq6UT2SsGPNY1AkIRl/gMen1Qr2XrHMcsRQZpAvqtFo948j
         PDFGjnkX4gtSvK/lmhm0aNZvPzzBjU8Ik9El7dbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/242] soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()
Date:   Mon, 28 Dec 2020 13:47:51 +0100
Message-Id: <20201228124907.931061857@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cf25d802e029c31efac8bdc979236927f37183bd ]

This code needs to call iounmap() on one error path.

Fixes: 2173fc7cb681 ("ARM: shmobile: R-Mobile: Add DT support for PM domains")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200923113142.GC1473821@mwanda
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-shmobile/pm-rmobile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 3a4ed4c33a68e..e312f676a0fdf 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -336,6 +336,7 @@ static int __init rmobile_init_pm_domains(void)
 
 		pmd = of_get_child_by_name(np, "pm-domains");
 		if (!pmd) {
+			iounmap(base);
 			pr_warn("%pOF lacks pm-domains node\n", np);
 			continue;
 		}
-- 
2.27.0



