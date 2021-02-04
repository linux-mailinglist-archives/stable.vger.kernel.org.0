Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BCB30C87D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbhBBRvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:51:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233975AbhBBOJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:09:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FE1865024;
        Tue,  2 Feb 2021 13:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273839;
        bh=225t3kwK2KZ7ukZYn/wuewzNvB32JjKVX+vIqFk4m5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugfvxUQIkxRo0REGH7kwYEb4ToA6oTkMvED4joHuew5RDY1FyTsMh2LUOm4i4vsdK
         CeIhC/6pPw/HzaBoBC61u7etyJY1uxjsaoNFMmxUmPfgFVF+mdlMFLwv+lUbfH4BB1
         IzYycVnMxwKZ3Dcmt2bRACxt6Zb6KP23DPHUfCes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 20/32] mt7601u: fix rx buffer refcounting
Date:   Tue,  2 Feb 2021 14:38:43 +0100
Message-Id: <20210202132942.823782029@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit d24c790577ef01bfa01da2b131313a38c843a634 upstream.

Fix the following crash due to erroneous page refcounting:

[   32.445919] BUG: Bad page state in process swapper/1  pfn:11f65a
[   32.447409] page:00000000938f0632 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x11f65a
[   32.449605] flags: 0x8000000000000000()
[   32.450421] raw: 8000000000000000 ffffffff825b0148 ffffea00045ae988 0000000000000000
[   32.451795] raw: 0000000000000000 0000000000000001 00000000ffffff7f 0000000000000000
[   32.452999] page dumped because: nonzero mapcount
[   32.453888] Modules linked in:
[   32.454492] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.11.0-rc2+ #1976
[   32.455695] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-1.fc33 04/01/2014
[   32.457157] Call Trace:
[   32.457636]  <IRQ>
[   32.457993]  dump_stack+0x77/0x97
[   32.458576]  bad_page.cold+0x65/0x96
[   32.459198]  get_page_from_freelist+0x46a/0x11f0
[   32.460008]  __alloc_pages_nodemask+0x10a/0x2b0
[   32.460794]  mt7601u_rx_tasklet+0x651/0x720
[   32.461505]  tasklet_action_common.constprop.0+0x6b/0xd0
[   32.462343]  __do_softirq+0x152/0x46c
[   32.462928]  asm_call_irq_on_stack+0x12/0x20
[   32.463610]  </IRQ>
[   32.463953]  do_softirq_own_stack+0x5b/0x70
[   32.464582]  irq_exit_rcu+0x9f/0xe0
[   32.465028]  common_interrupt+0xae/0x1a0
[   32.465536]  asm_common_interrupt+0x1e/0x40
[   32.466071] RIP: 0010:default_idle+0x18/0x20
[   32.468981] RSP: 0018:ffffc90000077f00 EFLAGS: 00000246
[   32.469648] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[   32.470550] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81aac3dd
[   32.471463] RBP: ffff88810022ab00 R08: 0000000000000001 R09: 0000000000000001
[   32.472335] R10: 0000000000000046 R11: 0000000000005aa0 R12: 0000000000000000
[   32.473235] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   32.474139]  ? default_idle_call+0x4d/0x200
[   32.474681]  default_idle_call+0x74/0x200
[   32.475192]  do_idle+0x1d5/0x250
[   32.475612]  cpu_startup_entry+0x19/0x20
[   32.476114]  secondary_startup_64_no_verify+0xb0/0xbb
[   32.476765] Disabling lock debugging due to kernel taint

Fixes: c869f77d6abb ("add mt7601u driver")
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/62b2380c8c2091834cfad05e1059b55f945bd114.1610643952.git.lorenzo@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt7601u/dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -160,8 +160,7 @@ mt7601u_rx_process_entry(struct mt7601u_
 
 	if (new_p) {
 		/* we have one extra ref from the allocator */
-		__free_pages(e->p, MT_RX_ORDER);
-
+		put_page(e->p);
 		e->p = new_p;
 	}
 }


