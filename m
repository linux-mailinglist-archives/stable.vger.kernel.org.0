Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52F1689529
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjBCKRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjBCKRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:17:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D356AA07D7
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:17:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C9D8B82A71
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F14C433D2;
        Fri,  3 Feb 2023 10:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419430;
        bh=VdjsCAxSNrp+NW/KQFKQz+IBAxYjtVyGmI7lmtSM3+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3UOQLYlryFEZemjPaylqpJCqYwVX1jyHqsuNjFkPw5SbyJXyT0gLKptJTIQuetq2
         scLFr0O5FR3N+xz4fRKUPmV7QhteIpuTOYXLhXK3E8cAZ82PSDDIdqnRrmgUh1qccc
         A3HFsjNzJKitZH0uXgZ1/ikZJlb/vaSBeTPTXQsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        David Christensen <drc@linux.vnet.ibm.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/62] net/tg3: resolve deadlock in tg3_reset_task() during EEH
Date:   Fri,  3 Feb 2023 11:12:32 +0100
Message-Id: <20230203101014.561386102@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Christensen <drc@linux.vnet.ibm.com>

[ Upstream commit 6c4ca03bd890566d873e3593b32d034bf2f5a087 ]

During EEH error injection testing, a deadlock was encountered in the tg3
driver when tg3_io_error_detected() was attempting to cancel outstanding
reset tasks:

crash> foreach UN bt
...
PID: 159    TASK: c0000000067c6000  CPU: 8   COMMAND: "eehd"
...
 #5 [c00000000681f990] __cancel_work_timer at c00000000019fd18
 #6 [c00000000681fa30] tg3_io_error_detected at c00800000295f098 [tg3]
 #7 [c00000000681faf0] eeh_report_error at c00000000004e25c
...

PID: 290    TASK: c000000036e5f800  CPU: 6   COMMAND: "kworker/6:1"
...
 #4 [c00000003721fbc0] rtnl_lock at c000000000c940d8
 #5 [c00000003721fbe0] tg3_reset_task at c008000002969358 [tg3]
 #6 [c00000003721fc60] process_one_work at c00000000019e5c4
...

PID: 296    TASK: c000000037a65800  CPU: 21  COMMAND: "kworker/21:1"
...
 #4 [c000000037247bc0] rtnl_lock at c000000000c940d8
 #5 [c000000037247be0] tg3_reset_task at c008000002969358 [tg3]
 #6 [c000000037247c60] process_one_work at c00000000019e5c4
...

PID: 655    TASK: c000000036f49000  CPU: 16  COMMAND: "kworker/16:2"
...:1

 #4 [c0000000373ebbc0] rtnl_lock at c000000000c940d8
 #5 [c0000000373ebbe0] tg3_reset_task at c008000002969358 [tg3]
 #6 [c0000000373ebc60] process_one_work at c00000000019e5c4
...

Code inspection shows that both tg3_io_error_detected() and
tg3_reset_task() attempt to acquire the RTNL lock at the beginning of
their code blocks.  If tg3_reset_task() should happen to execute between
the times when tg3_io_error_deteced() acquires the RTNL lock and
tg3_reset_task_cancel() is called, a deadlock will occur.

Moving tg3_reset_task_cancel() call earlier within the code block, prior
to acquiring RTNL, prevents this from happening, but also exposes another
deadlock issue where tg3_reset_task() may execute AFTER
tg3_io_error_detected() has executed:

crash> foreach UN bt
PID: 159    TASK: c0000000067d2000  CPU: 9   COMMAND: "eehd"
...
 #4 [c000000006867a60] rtnl_lock at c000000000c940d8
 #5 [c000000006867a80] tg3_io_slot_reset at c0080000026c2ea8 [tg3]
 #6 [c000000006867b00] eeh_report_reset at c00000000004de88
...
PID: 363    TASK: c000000037564000  CPU: 6   COMMAND: "kworker/6:1"
...
 #3 [c000000036c1bb70] msleep at c000000000259e6c
 #4 [c000000036c1bba0] napi_disable at c000000000c6b848
 #5 [c000000036c1bbe0] tg3_reset_task at c0080000026d942c [tg3]
 #6 [c000000036c1bc60] process_one_work at c00000000019e5c4
...

This issue can be avoided by aborting tg3_reset_task() if EEH error
recovery is already in progress.

Fixes: db84bf43ef23 ("tg3: tg3_reset_task() needs to use rtnl_lock to synchronize")
Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230124185339.225806-1-drc@linux.vnet.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3279a6e48f3b..e0eacfc46dd4 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11158,7 +11158,7 @@ static void tg3_reset_task(struct work_struct *work)
 	rtnl_lock();
 	tg3_full_lock(tp, 0);
 
-	if (!netif_running(tp->dev)) {
+	if (tp->pcierr_recovery || !netif_running(tp->dev)) {
 		tg3_flag_clear(tp, RESET_TASK_PENDING);
 		tg3_full_unlock(tp);
 		rtnl_unlock();
@@ -18190,6 +18190,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	netdev_info(netdev, "PCI I/O error detected\n");
 
+	/* Want to make sure that the reset task doesn't run */
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
 
 	/* Could be second call or maybe we don't have netdev yet */
@@ -18206,9 +18209,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	tg3_timer_stop(tp);
 
-	/* Want to make sure that the reset task doesn't run */
-	tg3_reset_task_cancel(tp);
-
 	netif_device_detach(netdev);
 
 	/* Clean up software state, even if MMIO is blocked */
-- 
2.39.0



