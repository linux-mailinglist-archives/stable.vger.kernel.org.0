Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B613E540A1A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiFGSSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350821AbiFGSOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:14:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D319215A743;
        Tue,  7 Jun 2022 10:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E2526170B;
        Tue,  7 Jun 2022 17:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F6AC34115;
        Tue,  7 Jun 2022 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624128;
        bh=W6/rJm2x4jEKbutBT4nzL4yNQLM+3X+Q8xBE+50Ah1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkIVpwjuoONSoIL7oa2qH6Uq2s8ViL+i7eoDdZ6hAtr84O30gwA73tjnMjpYdz5PY
         qqp0YijmIHcL2krCQwXQi1JPh25fGWKaeUsnBinR7/QkvzVVHsf9RhCb4Y0druGjvf
         ecLMC0p8slKSKzv/Bt2txHtrJcz5JhXRHTS9qDPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/667] NFC: NULL out the dev->rfkill to prevent UAF
Date:   Tue,  7 Jun 2022 18:57:58 +0200
Message-Id: <20220607164941.184698223@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 1b0e81416a24d6e9b8c2341e22e8bf48f8b8bfc9 ]

Commit 3e3b5dfcd16a ("NFC: reorder the logic in nfc_{un,}register_device")
assumes the device_is_registered() in function nfc_dev_up() will help
to check when the rfkill is unregistered. However, this check only
take effect when device_del(&dev->dev) is done in nfc_unregister_device().
Hence, the rfkill object is still possible be dereferenced.

The crash trace in latest kernel (5.18-rc2):

[   68.760105] ==================================================================
[   68.760330] BUG: KASAN: use-after-free in __lock_acquire+0x3ec1/0x6750
[   68.760756] Read of size 8 at addr ffff888009c93018 by task fuzz/313
[   68.760756]
[   68.760756] CPU: 0 PID: 313 Comm: fuzz Not tainted 5.18.0-rc2 #4
[   68.760756] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   68.760756] Call Trace:
[   68.760756]  <TASK>
[   68.760756]  dump_stack_lvl+0x57/0x7d
[   68.760756]  print_report.cold+0x5e/0x5db
[   68.760756]  ? __lock_acquire+0x3ec1/0x6750
[   68.760756]  kasan_report+0xbe/0x1c0
[   68.760756]  ? __lock_acquire+0x3ec1/0x6750
[   68.760756]  __lock_acquire+0x3ec1/0x6750
[   68.760756]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[   68.760756]  ? register_lock_class+0x18d0/0x18d0
[   68.760756]  lock_acquire+0x1ac/0x4f0
[   68.760756]  ? rfkill_blocked+0xe/0x60
[   68.760756]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[   68.760756]  ? mutex_lock_io_nested+0x12c0/0x12c0
[   68.760756]  ? nla_get_range_signed+0x540/0x540
[   68.760756]  ? _raw_spin_lock_irqsave+0x4e/0x50
[   68.760756]  _raw_spin_lock_irqsave+0x39/0x50
[   68.760756]  ? rfkill_blocked+0xe/0x60
[   68.760756]  rfkill_blocked+0xe/0x60
[   68.760756]  nfc_dev_up+0x84/0x260
[   68.760756]  nfc_genl_dev_up+0x90/0xe0
[   68.760756]  genl_family_rcv_msg_doit+0x1f4/0x2f0
[   68.760756]  ? genl_family_rcv_msg_attrs_parse.constprop.0+0x230/0x230
[   68.760756]  ? security_capable+0x51/0x90
[   68.760756]  genl_rcv_msg+0x280/0x500
[   68.760756]  ? genl_get_cmd+0x3c0/0x3c0
[   68.760756]  ? lock_acquire+0x1ac/0x4f0
[   68.760756]  ? nfc_genl_dev_down+0xe0/0xe0
[   68.760756]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[   68.760756]  netlink_rcv_skb+0x11b/0x340
[   68.760756]  ? genl_get_cmd+0x3c0/0x3c0
[   68.760756]  ? netlink_ack+0x9c0/0x9c0
[   68.760756]  ? netlink_deliver_tap+0x136/0xb00
[   68.760756]  genl_rcv+0x1f/0x30
[   68.760756]  netlink_unicast+0x430/0x710
[   68.760756]  ? memset+0x20/0x40
[   68.760756]  ? netlink_attachskb+0x740/0x740
[   68.760756]  ? __build_skb_around+0x1f4/0x2a0
[   68.760756]  netlink_sendmsg+0x75d/0xc00
[   68.760756]  ? netlink_unicast+0x710/0x710
[   68.760756]  ? netlink_unicast+0x710/0x710
[   68.760756]  sock_sendmsg+0xdf/0x110
[   68.760756]  __sys_sendto+0x19e/0x270
[   68.760756]  ? __ia32_sys_getpeername+0xa0/0xa0
[   68.760756]  ? fd_install+0x178/0x4c0
[   68.760756]  ? fd_install+0x195/0x4c0
[   68.760756]  ? kernel_fpu_begin_mask+0x1c0/0x1c0
[   68.760756]  __x64_sys_sendto+0xd8/0x1b0
[   68.760756]  ? lockdep_hardirqs_on+0xbf/0x130
[   68.760756]  ? syscall_enter_from_user_mode+0x1d/0x50
[   68.760756]  do_syscall_64+0x3b/0x90
[   68.760756]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   68.760756] RIP: 0033:0x7f67fb50e6b3
...
[   68.760756] RSP: 002b:00007f67fa91fe90 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[   68.760756] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f67fb50e6b3
[   68.760756] RDX: 000000000000001c RSI: 0000559354603090 RDI: 0000000000000003
[   68.760756] RBP: 00007f67fa91ff00 R08: 00007f67fa91fedc R09: 000000000000000c
[   68.760756] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffe824d496e
[   68.760756] R13: 00007ffe824d496f R14: 00007f67fa120000 R15: 0000000000000003

[   68.760756]  </TASK>
[   68.760756]
[   68.760756] Allocated by task 279:
[   68.760756]  kasan_save_stack+0x1e/0x40
[   68.760756]  __kasan_kmalloc+0x81/0xa0
[   68.760756]  rfkill_alloc+0x7f/0x280
[   68.760756]  nfc_register_device+0xa3/0x1a0
[   68.760756]  nci_register_device+0x77a/0xad0
[   68.760756]  nfcmrvl_nci_register_dev+0x20b/0x2c0
[   68.760756]  nfcmrvl_nci_uart_open+0xf2/0x1dd
[   68.760756]  nci_uart_tty_ioctl+0x2c3/0x4a0
[   68.760756]  tty_ioctl+0x764/0x1310
[   68.760756]  __x64_sys_ioctl+0x122/0x190
[   68.760756]  do_syscall_64+0x3b/0x90
[   68.760756]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   68.760756]
[   68.760756] Freed by task 314:
[   68.760756]  kasan_save_stack+0x1e/0x40
[   68.760756]  kasan_set_track+0x21/0x30
[   68.760756]  kasan_set_free_info+0x20/0x30
[   68.760756]  __kasan_slab_free+0x108/0x170
[   68.760756]  kfree+0xb0/0x330
[   68.760756]  device_release+0x96/0x200
[   68.760756]  kobject_put+0xf9/0x1d0
[   68.760756]  nfc_unregister_device+0x77/0x190
[   68.760756]  nfcmrvl_nci_unregister_dev+0x88/0xd0
[   68.760756]  nci_uart_tty_close+0xdf/0x180
[   68.760756]  tty_ldisc_kill+0x73/0x110
[   68.760756]  tty_ldisc_hangup+0x281/0x5b0
[   68.760756]  __tty_hangup.part.0+0x431/0x890
[   68.760756]  tty_release+0x3a8/0xc80
[   68.760756]  __fput+0x1f0/0x8c0
[   68.760756]  task_work_run+0xc9/0x170
[   68.760756]  exit_to_user_mode_prepare+0x194/0x1a0
[   68.760756]  syscall_exit_to_user_mode+0x19/0x50
[   68.760756]  do_syscall_64+0x48/0x90
[   68.760756]  entry_SYSCALL_64_after_hwframe+0x44/0xae

This patch just add the null out of dev->rfkill to make sure such
dereference cannot happen. This is safe since the device_lock() already
protect the check/write from data race.

Fixes: 3e3b5dfcd16a ("NFC: reorder the logic in nfc_{un,}register_device")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 5b286e1e0a6f..6ff3e10ff8e3 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -1166,6 +1166,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
 	if (dev->rfkill) {
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
+		dev->rfkill = NULL;
 	}
 	dev->shutting_down = true;
 	device_unlock(&dev->dev);
-- 
2.35.1



