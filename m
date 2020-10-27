Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED3129B54B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794212AbgJ0PKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794202AbgJ0PKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B220F20657;
        Tue, 27 Oct 2020 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811431;
        bh=Yy/V6wqg3pFNjUhu9m9xh4868mWtP3TNBy/8sGlApSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5Y1cV/tXkf1essbFw1mV+snLytNs7xOYV8CJ9Lo3Lxkyd/ZEfqzPrayMfJjIF/xI
         +MYIDiFHaNL1YaX+MK7XC80bMsK9PNLM2sSwi/sg53l9ejUjgUIX2vHTkBe5PEjKFc
         dJtTYZVfXign6vGmBJhuzzLcevzpXt9R/9frRkVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 491/633] firmware: arm_scmi: Fix NULL pointer dereference in mailbox_chan_free
Date:   Tue, 27 Oct 2020 14:53:54 +0100
Message-Id: <20201027135545.769404307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 6ed6c558234f0b6c22e47a3c2feddce3d02324dd ]

scmi_mailbox is obtained from cinfo->transport_info and the first
call to mailbox_chan_free frees the channel and sets cinfo->transport_info
to NULL. Care is taken to check for non NULL smbox->chan but smbox can
itself be NULL. Fix it by checking for it without which, kernel crashes
with below NULL pointer dereference and eventually kernel panic.

   Unable to handle kernel NULL pointer dereference at
   		virtual address 0000000000000038
   Modules linked in: scmi_module(-)
   Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno
   		Development Platform, BIOS EDK II Sep  2 2020
   pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
   pc : mailbox_chan_free+0x2c/0x70 [scmi_module]
   lr : idr_for_each+0x6c/0xf8
   Call trace:
    mailbox_chan_free+0x2c/0x70 [scmi_module]
    idr_for_each+0x6c/0xf8
    scmi_remove+0xa8/0xf0 [scmi_module]
    platform_drv_remove+0x34/0x58
    device_release_driver_internal+0x118/0x1f0
    driver_detach+0x58/0xe8
    bus_remove_driver+0x64/0xe0
    driver_unregister+0x38/0x68
    platform_driver_unregister+0x1c/0x28
    scmi_driver_exit+0x38/0x44 [scmi_module]
   ---[ end trace 17bde19f50436de9 ]---
   Kernel panic - not syncing: Fatal exception
   SMP: stopping secondary CPUs
   Kernel Offset: 0x1d0000 from 0xffff800010000000
   PHYS_OFFSET: 0x80000000
   CPU features: 0x0240022,25806004
   Memory Limit: none
   ---[ end Kernel panic - not syncing: Fatal exception ]---

Link: https://lore.kernel.org/r/20200908112611.31515-1-sudeep.holla@arm.com
Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Cc: Cristian Marussi <cristian.marussi@arm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 6998dc86b5ce8..b797a713c3313 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -110,7 +110,7 @@ static int mailbox_chan_free(int id, void *p, void *data)
 	struct scmi_chan_info *cinfo = p;
 	struct scmi_mailbox *smbox = cinfo->transport_info;
 
-	if (!IS_ERR(smbox->chan)) {
+	if (smbox && !IS_ERR(smbox->chan)) {
 		mbox_free_channel(smbox->chan);
 		cinfo->transport_info = NULL;
 		smbox->chan = NULL;
-- 
2.25.1



