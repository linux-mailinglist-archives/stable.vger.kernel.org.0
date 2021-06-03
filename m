Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7D139A6E2
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFCRJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhFCRJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 396C461402;
        Thu,  3 Jun 2021 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740076;
        bh=1A4NNRnPrmv50ddFZQMqK+SrD3mHwHoBon8kv7V9k20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rROAjykavxmuDwcWKfY7zIc5FdBKJ7W8E/BglSkJjx1zd9qy30GjAEwHikgIyjW0G
         bsvaEMIaTH2qdMbFaDBWh9jxeDKT/ZFgX5AhZLDN5uucWlu8u+kaWu/ByXAa5Cc9ne
         A/0pANViV+ngrYa5QN8fNRpfmOG+7xA+YAK6L61UePW2A7X+FUbq5Y6A89Jzom/gEd
         YzDSlzvkEk6J0rg/i1GXdpUNS28SgkDI1f0H8QIvq0YPIliPQAmD8aKPtYPZKRcubR
         N7YCcGAu3LT/fZe4+yc1D0kdmS4Z8t+rUMGntWE2+OMEOVe3UW6HijyUBBJ3cbpDu6
         fGI4+AdMNe3YA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Jun <jun.li@nxp.com>, "faqiang . zhu" <faqiang.zhu@nxp.com>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 17/43] usb: chipidea: udc: assign interrupt number to USB gadget structure
Date:   Thu,  3 Jun 2021 13:07:07 -0400
Message-Id: <20210603170734.3168284-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

[ Upstream commit 9e3927f6373da54cb17e17f4bd700907e1123d2f ]

Chipidea also need sync interrupt before unbind the udc while
gadget remove driver, otherwise setup irq handling may happen
while unbind, see below dump generated from android function
switch stress test:

[ 4703.503056] android_work: sent uevent USB_STATE=CONNECTED
[ 4703.514642] android_work: sent uevent USB_STATE=DISCONNECTED
[ 4703.651339] android_work: sent uevent USB_STATE=CONNECTED
[ 4703.661806] init: Control message: Processed ctl.stop for 'adbd' from pid: 561 (system_server)
[ 4703.673469] init: processing action (init.svc.adbd=stopped) from (/system/etc/init/hw/init.usb.configfs.rc:14)
[ 4703.676451] Unable to handle kernel read from unreadable memory at virtual address 0000000000000090
[ 4703.676454] Mem abort info:
[ 4703.676458]   ESR = 0x96000004
[ 4703.676461]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 4703.676464]   SET = 0, FnV = 0
[ 4703.676466]   EA = 0, S1PTW = 0
[ 4703.676468] Data abort info:
[ 4703.676471]   ISV = 0, ISS = 0x00000004
[ 4703.676473]   CM = 0, WnR = 0
[ 4703.676478] user pgtable: 4k pages, 48-bit VAs, pgdp=000000004a867000
[ 4703.676481] [0000000000000090] pgd=0000000000000000, p4d=0000000000000000
[ 4703.676503] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[ 4703.758297] Modules linked in: synaptics_dsx_i2c moal(O) mlan(O)
[ 4703.764327] CPU: 0 PID: 235 Comm: lmkd Tainted: G        W  O      5.10.9-00001-g3f5fd8487c38-dirty #63
[ 4703.773720] Hardware name: NXP i.MX8MNano EVK board (DT)
[ 4703.779033] pstate: 60400085 (nZCv daIf +PAN -UAO -TCO BTYPE=--)
[ 4703.785046] pc : _raw_write_unlock_bh+0xc0/0x2c8
[ 4703.789667] lr : android_setup+0x4c/0x168
[ 4703.793676] sp : ffff80001256bd80
[ 4703.796989] x29: ffff80001256bd80 x28: 00000000000000a8
[ 4703.802304] x27: ffff800012470000 x26: ffff80006d923000
[ 4703.807616] x25: ffff800012471000 x24: ffff00000b091140
[ 4703.812929] x23: ffff0000077dbd38 x22: ffff0000077da490
[ 4703.818242] x21: ffff80001256be30 x20: 0000000000000000
[ 4703.823554] x19: 0000000000000080 x18: ffff800012561048
[ 4703.828867] x17: 0000000000000000 x16: 0000000000000039
[ 4703.834180] x15: ffff8000106ad258 x14: ffff80001194c277
[ 4703.839493] x13: 0000000000003934 x12: 0000000000000000
[ 4703.844805] x11: 0000000000000000 x10: 0000000000000001
[ 4703.850117] x9 : 0000000000000000 x8 : 0000000000000090
[ 4703.855429] x7 : 6f72646e61203a70 x6 : ffff8000124f2450
[ 4703.860742] x5 : ffffffffffffffff x4 : 0000000000000009
[ 4703.866054] x3 : ffff8000108a290c x2 : ffff00007fb3a9c8
[ 4703.871367] x1 : 0000000000000000 x0 : 0000000000000090
[ 4703.876681] Call trace:
[ 4703.879129]  _raw_write_unlock_bh+0xc0/0x2c8
[ 4703.883397]  android_setup+0x4c/0x168
[ 4703.887059]  udc_irq+0x824/0xa9c
[ 4703.890287]  ci_irq+0x124/0x148
[ 4703.893429]  __handle_irq_event_percpu+0x84/0x268
[ 4703.898131]  handle_irq_event+0x64/0x14c
[ 4703.902054]  handle_fasteoi_irq+0x110/0x210
[ 4703.906236]  __handle_domain_irq+0x8c/0xd4
[ 4703.910332]  gic_handle_irq+0x6c/0x124
[ 4703.914081]  el1_irq+0xdc/0x1c0
[ 4703.917221]  _raw_spin_unlock_irq+0x20/0x54
[ 4703.921405]  finish_task_switch+0x84/0x224
[ 4703.925502]  __schedule+0x4a4/0x734
[ 4703.928990]  schedule+0xa0/0xe8
[ 4703.932132]  do_notify_resume+0x150/0x184
[ 4703.936140]  work_pending+0xc/0x40c
[ 4703.939633] Code: d5384613 521b0a69 d5184609 f9800111 (885ffd01)
[ 4703.945732] ---[ end trace ba5c1875ae49d53c ]---
[ 4703.950350] Kernel panic - not syncing: Oops: Fatal exception in interrupt
[ 4703.957223] SMP: stopping secondary CPUs
[ 4703.961151] Kernel Offset: disabled
[ 4703.964638] CPU features: 0x0240002,2000200c
[ 4703.968905] Memory Limit: none
[ 4703.971963] Rebooting in 5 seconds..

Tested-by: faqiang.zhu <faqiang.zhu@nxp.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1620989984-7653-1-git-send-email-jun.li@nxp.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index c16d900cdaee..393f216b9161 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -2061,6 +2061,7 @@ static int udc_start(struct ci_hdrc *ci)
 	ci->gadget.name         = ci->platdata->name;
 	ci->gadget.otg_caps	= otg_caps;
 	ci->gadget.sg_supported = 1;
+	ci->gadget.irq		= ci->irq;
 
 	if (ci->platdata->flags & CI_HDRC_REQUIRES_ALIGNED_DMA)
 		ci->gadget.quirk_avoids_skb_reserve = 1;
-- 
2.30.2

