Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DCF3289BF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhCASEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239172AbhCAR6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:58:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 346E9652BC;
        Mon,  1 Mar 2021 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620180;
        bh=lTYg9uYZ017PnZzvwFHZ4J0OykaGCo6ETK4twtwKWiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+N7SnhO4U0JaD1k7yn1yDhIJYSZxQjqJVQ/dOawBkIrfOOQXWF/pjGgTb4bdFhol
         aCeWvaGTIo+cwXL9a/brTI4Nm8gw7sPV6CFftNlzSpeqGnP9IAnCm8iNPUzaYwmRbn
         HLm0SBEsbVVMOpJ8Q1v/EnLKT+mrOUNwe96QRYyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 059/775] soc: ti: pm33xx: Fix some resource leak in the error handling paths of the probe function
Date:   Mon,  1 Mar 2021 17:03:47 +0100
Message-Id: <20210301161204.604631828@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 17ad4662595ea0c4fd7496b664523ef632e63349 ]

'am33xx_pm_rtc_setup()' allocates some resources that must be freed on the
error. Commit 2152fbbd47c0 ("soc: ti: pm33xx: Simplify RTC usage to prepare
to drop platform data") has introduced the use of these resources but has
only updated the remove function.

Fix the error handling path of the probe function now.

Fixes: 2152fbbd47c0 ("soc: ti: pm33xx: Simplify RTC usage to prepare to drop platform data")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/pm33xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/ti/pm33xx.c b/drivers/soc/ti/pm33xx.c
index 64f3e31055401..7bab4bbaf02dc 100644
--- a/drivers/soc/ti/pm33xx.c
+++ b/drivers/soc/ti/pm33xx.c
@@ -535,7 +535,7 @@ static int am33xx_pm_probe(struct platform_device *pdev)
 
 	ret = am33xx_push_sram_idle();
 	if (ret)
-		goto err_free_sram;
+		goto err_unsetup_rtc;
 
 	am33xx_pm_set_ipc_ops();
 
@@ -575,6 +575,9 @@ err_pm_runtime_put:
 err_pm_runtime_disable:
 	pm_runtime_disable(dev);
 	wkup_m3_ipc_put(m3_ipc);
+err_unsetup_rtc:
+	iounmap(rtc_base_virt);
+	clk_put(rtc_fck);
 err_free_sram:
 	am33xx_pm_free_sram();
 	pm33xx_dev = NULL;
-- 
2.27.0



