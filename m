Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F20328A68
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhCASRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239057AbhCASJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F8F64F3E;
        Mon,  1 Mar 2021 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618357;
        bh=JxfD2xSjmuUV9FC76sMH0DWAc9vUOhn/rSQ2t0OJ/V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9y56WaWt5tlVyDhEhJz5U2gL1M8kn3aLxGfWygU3hEZLDhiZRfrmRR9YqVlc1YNA
         BuhYRO1M6JOFQOvV1FcAoPg4iGjgvUGedo6PezM0ndJlVBRcbAUtSmv5Y8KmF9tgG2
         nxBAQpNO7UXoN8kJnNmElINiZgEV+6eZTzWqZyQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/663] soc: ti: pm33xx: Fix some resource leak in the error handling paths of the probe function
Date:   Mon,  1 Mar 2021 17:05:05 +0100
Message-Id: <20210301161144.578332479@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index d2f5e7001a93c..dc21aa855a458 100644
--- a/drivers/soc/ti/pm33xx.c
+++ b/drivers/soc/ti/pm33xx.c
@@ -536,7 +536,7 @@ static int am33xx_pm_probe(struct platform_device *pdev)
 
 	ret = am33xx_push_sram_idle();
 	if (ret)
-		goto err_free_sram;
+		goto err_unsetup_rtc;
 
 	am33xx_pm_set_ipc_ops();
 
@@ -566,6 +566,9 @@ static int am33xx_pm_probe(struct platform_device *pdev)
 
 err_put_wkup_m3_ipc:
 	wkup_m3_ipc_put(m3_ipc);
+err_unsetup_rtc:
+	iounmap(rtc_base_virt);
+	clk_put(rtc_fck);
 err_free_sram:
 	am33xx_pm_free_sram();
 	pm33xx_dev = NULL;
-- 
2.27.0



