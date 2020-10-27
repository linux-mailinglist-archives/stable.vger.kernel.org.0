Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE2129B832
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799877AbgJ0Pdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799871AbgJ0Pdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB19222202;
        Tue, 27 Oct 2020 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812829;
        bh=hJBNhoAZFn+cULseKMNavMk7Bz1ge3I10oCm81xtbaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBUDzB/tivNRT1Wrk/TYes/4FrZaqobi5sicxlVmcP3ReKjT1WdwyPbcW11OkhOgE
         Dj0EbzqSCEejZk7uEPh+XRkLS21dsBJYp32Z0Bc6imD4qK1zHJus5sOn54lXxHzN9i
         J8N8v7Iqncn9RNuap6ptTnrMwwP4lrOq74NCgL/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan-Hsuan Chuang <yhchuang@realtek.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 313/757] rtw88: Fix probe error handling race with firmware loading
Date:   Tue, 27 Oct 2020 14:49:23 +0100
Message-Id: <20201027135505.219620791@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Färber <afaerber@suse.de>

[ Upstream commit ecda9cda3338b594a1b82d62018c247132a39e57 ]

In case of rtw8822be, a probe failure after successful rtw_core_init()
has been observed to occasionally lead to an oops from rtw_load_firmware_cb():

[    3.924268] pci 0001:01:00.0: [10ec:b822] type 00 class 0xff0000
[    3.930531] pci 0001:01:00.0: reg 0x10: [io  0x0000-0x00ff]
[    3.936360] pci 0001:01:00.0: reg 0x18: [mem 0x00000000-0x0000ffff 64bit]
[    3.944042] pci 0001:01:00.0: supports D1 D2
[    3.948438] pci 0001:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.957312] pci 0001:01:00.0: BAR 2: no space for [mem size 0x00010000 64bit]
[    3.964645] pci 0001:01:00.0: BAR 2: failed to assign [mem size 0x00010000 64bit]
[    3.972332] pci 0001:01:00.0: BAR 0: assigned [io  0x10000-0x100ff]
[    3.986240] rtw_8822be 0001:01:00.0: enabling device (0000 -> 0001)
[    3.992735] rtw_8822be 0001:01:00.0: failed to map pci memory
[    3.998638] rtw_8822be 0001:01:00.0: failed to request pci io region
[    4.005166] rtw_8822be 0001:01:00.0: failed to setup pci resources
[    4.011580] rtw_8822be: probe of 0001:01:00.0 failed with error -12
[    4.018827] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    4.029121] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    4.050828] Unable to handle kernel paging request at virtual address edafeaac9607952c
[    4.058975] Mem abort info:
[    4.058980]   ESR = 0x96000004
[    4.058990]   EC = 0x25: DABT (current EL), IL = 32 bits
[    4.070353]   SET = 0, FnV = 0
[    4.073487]   EA = 0, S1PTW = 0
[    4.073501] dw-apb-uart 98007800.serial: forbid DMA for kernel console
[    4.076723] Data abort info:
[    4.086415]   ISV = 0, ISS = 0x00000004
[    4.087731] Freeing unused kernel memory: 1792K
[    4.090391]   CM = 0, WnR = 0
[    4.098091] [edafeaac9607952c] address between user and kernel address ranges
[    4.105418] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    4.111129] Modules linked in:
[    4.114275] CPU: 1 PID: 31 Comm: kworker/1:1 Not tainted 5.9.0-rc5-next-20200915+ #700
[    4.122386] Hardware name: Realtek Saola EVB (DT)
[    4.127223] Workqueue: events request_firmware_work_func
[    4.132676] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    4.138393] pc : rtw_load_firmware_cb+0x54/0xbc
[    4.143040] lr : request_firmware_work_func+0x44/0xb4
[    4.148217] sp : ffff800010133d70
[    4.151616] x29: ffff800010133d70 x28: 0000000000000000
[    4.157069] x27: 0000000000000000 x26: 0000000000000000
[    4.162520] x25: 0000000000000000 x24: 0000000000000000
[    4.167971] x23: ffff00007ac21908 x22: ffff00007ebb2100
[    4.173424] x21: ffff00007ad35880 x20: edafeaac96079504
[    4.178877] x19: ffff00007ad35870 x18: 0000000000000000
[    4.184328] x17: 00000000000044d8 x16: 0000000000004310
[    4.189780] x15: 0000000000000800 x14: 00000000ef006305
[    4.195231] x13: ffffffff00000000 x12: ffffffffffffffff
[    4.200682] x11: 0000000000000020 x10: 0000000000000003
[    4.206135] x9 : 0000000000000000 x8 : ffff00007e73f680
[    4.211585] x7 : 0000000000000000 x6 : ffff80001119b588
[    4.217036] x5 : ffff00007e649c80 x4 : ffff00007e649c80
[    4.222487] x3 : ffff80001119b588 x2 : ffff8000108d1718
[    4.227940] x1 : ffff800011bd5000 x0 : ffff00007ac21600
[    4.233391] Call trace:
[    4.235906]  rtw_load_firmware_cb+0x54/0xbc
[    4.240198]  request_firmware_work_func+0x44/0xb4
[    4.245027]  process_one_work+0x178/0x1e4
[    4.249142]  worker_thread+0x1d0/0x268
[    4.252989]  kthread+0xe8/0xf8
[    4.256127]  ret_from_fork+0x10/0x18
[    4.259800] Code: f94013f5 a8c37bfd d65f03c0 f9000260 (f9401681)
[    4.266049] ---[ end trace f822ebae1a8545c2 ]---

To avoid this, wait on the completion callbacks in rtw_core_deinit()
before releasing firmware and continuing teardown.

Note that rtw_wait_firmware_completion() was introduced with
c8e5695eae9959fc5774c0f490f2450be8bad3de ("rtw88: load wowlan firmware
if wowlan is supported"), so backports to earlier branches may need to
inline wait_for_completion(&rtwdev->fw.completion) instead.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Fixes: c8e5695eae99 ("rtw88: load wowlan firmware if wowlan is supported")
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200920132621.26468-2-afaerber@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 54044abf30d7c..58c760dfd6b80 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1487,6 +1487,8 @@ void rtw_core_deinit(struct rtw_dev *rtwdev)
 	struct rtw_rsvd_page *rsvd_pkt, *tmp;
 	unsigned long flags;
 
+	rtw_wait_firmware_completion(rtwdev);
+
 	if (fw->firmware)
 		release_firmware(fw->firmware);
 
-- 
2.25.1



