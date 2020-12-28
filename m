Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454992E660F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388769AbgL1NYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388765AbgL1NYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:24:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABC7222475;
        Mon, 28 Dec 2020 13:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161839;
        bh=hibfEYcZMpAQOZQcxA1X8HzL8fC7B2ItYcXpA3QsG5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwlJFUU4HAr5cJBwwnBkqOUDJ3Qmf+zKiw+80V57FM7t1CbUNO+4aQ48go2q395Ef
         NxppuN9M9sEkmGuCkvpGzw5/5F1N4ULudXrxj2kumOt1bPEFaMHPqBgYVpWicIwCzQ
         Ww2tR6+pFrDaDNyyinpDX8+LSK503OCZQuZK2OaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/346] soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()
Date:   Mon, 28 Dec 2020 13:46:59 +0100
Message-Id: <20201228124924.617704645@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index e348bcfe389da..cb8b02a1abe26 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -330,6 +330,7 @@ static int __init rmobile_init_pm_domains(void)
 
 		pmd = of_get_child_by_name(np, "pm-domains");
 		if (!pmd) {
+			iounmap(base);
 			pr_warn("%pOF lacks pm-domains node\n", np);
 			continue;
 		}
-- 
2.27.0



