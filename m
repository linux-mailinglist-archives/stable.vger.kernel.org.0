Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4072E3D20
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439704AbgL1OLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439679AbgL1OLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD214206D8;
        Mon, 28 Dec 2020 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164659;
        bh=TXmHWA5i4ADZoYAD6YP/2ICw8bmzH/5PlNx/ghfPBEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xq6/wAvCaFhAcUB5vyguemU+0rQfEGnfphipWQu/8Fg7V1kP48NESvMF9gSDaNgaJ
         cPM0WYbq8442HzHf1wURekUoNMiWvzhcSDuD9AgDZLmyPZg4UwGw/DyHYrv7t2pbVZ
         14GH1qMoVSnEOo0pFK/qjzv02bLRKwOm1npbJXlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/717] mailbox: arm_mhu_db: Fix mhu_db_shutdown by replacing kfree with devm_kfree
Date:   Mon, 28 Dec 2020 13:44:11 +0100
Message-Id: <20201228125033.106476023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9905f728b0bda737fe2c2afd7c24f3365a45cc7b ]

The mhu_db_channel info is allocated per channel using devm_kzalloc from
mhu_db_mbox_xlate which gets called from mbox_request_channel. However
we are releasing the allocated mhu_db_channel info using plain kfree from
mhu_db_shutdown which is called from mbox_free_channel.

This leads to random crashes when the channel is freed like below one:

  Unable to handle kernel paging request at virtual address 0080000400000008
  [0080000400000008] address between user and kernel address ranges
  Internal error: Oops: 96000044 [#1] PREEMPT SMP
  Modules linked in: scmi_module(-)
  CPU: 1 PID: 2212 Comm: rmmod Not tainted 5.10.0-rc5 #31
  Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno
  	Development Platform, BIOS EDK II Nov 19 2020
  pstate: 20000085 (nzCv daIf -PAN -UAO -TCO BTYPE=--)
  pc : release_nodes+0x74/0x230
  lr : devres_release_all+0x40/0x68
  Call trace:
   release_nodes+0x74/0x230
   devres_release_all+0x40/0x68
   device_release_driver_internal+0x12c/0x1f8
   driver_detach+0x58/0xe8
   bus_remove_driver+0x64/0xe0
   driver_unregister+0x38/0x68
   platform_driver_unregister+0x1c/0x28
   scmi_driver_exit+0x38/0x44 [scmi_module]
   __arm64_sys_delete_module+0x188/0x260
   el0_svc_common.constprop.0+0x80/0x1a8
   do_el0_svc+0x2c/0x98
   el0_sync_handler+0x160/0x168
   el0_sync+0x174/0x180
  Code: 1400000d eb07009f 54000460 f9400486 (f90004a6)
  ---[ end trace c55ffd306c140233 ]---

Fix it by replacing kfree with devm_kfree as required.

Fixes: 7002ca237b21 ("mailbox: arm_mhu: Add ARM MHU doorbell driver")
Reported-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhu_db.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/arm_mhu_db.c b/drivers/mailbox/arm_mhu_db.c
index 275efe4cca0c2..8eb66c4ecf5bf 100644
--- a/drivers/mailbox/arm_mhu_db.c
+++ b/drivers/mailbox/arm_mhu_db.c
@@ -180,7 +180,7 @@ static void mhu_db_shutdown(struct mbox_chan *chan)
 
 	/* Reset channel */
 	mhu_db_mbox_clear_irq(chan);
-	kfree(chan->con_priv);
+	devm_kfree(mbox->dev, chan->con_priv);
 	chan->con_priv = NULL;
 }
 
-- 
2.27.0



