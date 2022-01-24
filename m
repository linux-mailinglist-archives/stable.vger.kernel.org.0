Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363DF499CAD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354798AbiAXWG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578728AbiAXWDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:03:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A60C024175;
        Mon, 24 Jan 2022 12:41:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B06B1B81061;
        Mon, 24 Jan 2022 20:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B4CC340E5;
        Mon, 24 Jan 2022 20:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056914;
        bh=W+gIyHCzwKJCzsPRztsa87x8obRA+/Weo/X84U4dV/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLE5l82OdjlB2WEhgaTHx383Ps5CzjIQzAkUM/D3silMAh8DUspPQCb/B3/Il06KY
         VNBbIvYXlWT5VaOuVI4IB+E54YXyaGaXk3/IT3Oiln9FmHZAcD9uNB2hyEgviCkLOV
         HHAZyqsFIfDGKOHDxiw2yCWaYqTEdwqQBIELXQI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 640/846] scsi: ufs: Fix a kernel crash during shutdown
Date:   Mon, 24 Jan 2022 19:42:37 +0100
Message-Id: <20220124184123.109378318@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 3489c34bd02b73a72646037d673a122a53cee174 ]

Fix the following kernel crash:

Unable to handle kernel paging request at virtual address ffffffc91e735000
Call trace:
 __queue_work+0x26c/0x624
 queue_work_on+0x6c/0xf0
 ufshcd_hold+0x12c/0x210
 __ufshcd_wl_suspend+0xc0/0x400
 ufshcd_wl_shutdown+0xb8/0xcc
 device_shutdown+0x184/0x224
 kernel_restart+0x4c/0x124
 __arm64_sys_reboot+0x194/0x264
 el0_svc_common+0xc8/0x1d4
 do_el0_svc+0x30/0x8c
 el0_svc+0x20/0x30
 el0_sync_handler+0x84/0xe4
 el0_sync+0x1bc/0x1c0

Fix this crash by ungating the clock before destroying the work queue on
which clock gating work is queued.

Link: https://lore.kernel.org/r/20211203231950.193369-15-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 300bf00765d5b..ae7bdd8703198 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1657,7 +1657,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	bool flush_result;
 	unsigned long flags;
 
-	if (!ufshcd_is_clkgating_allowed(hba))
+	if (!ufshcd_is_clkgating_allowed(hba) ||
+	    !hba->clk_gating.is_initialized)
 		goto out;
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->clk_gating.active_reqs++;
@@ -1817,7 +1818,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks ||
+	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
 	    hba->active_uic_cmd || hba->uic_async_done ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
@@ -1952,11 +1953,15 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 {
 	if (!hba->clk_gating.is_initialized)
 		return;
+
 	ufshcd_remove_clk_gating_sysfs(hba);
-	cancel_work_sync(&hba->clk_gating.ungate_work);
-	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
-	destroy_workqueue(hba->clk_gating.clk_gating_workq);
+
+	/* Ungate the clock if necessary. */
+	ufshcd_hold(hba, false);
 	hba->clk_gating.is_initialized = false;
+	ufshcd_release(hba);
+
+	destroy_workqueue(hba->clk_gating.clk_gating_workq);
 }
 
 /* Must be called with host lock acquired */
-- 
2.34.1



