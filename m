Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFD63C53E9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348674AbhGLH4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350775AbhGLHvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 327B461152;
        Mon, 12 Jul 2021 07:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076104;
        bh=herbolRfz+YAMc9SytYGEpjiUP+DJuqLRcskqbMqYNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9DeVOIOVjBg06MgLFrqS9U1XqOsaZemo8OjIb/eEcComzK6oyeUVRztujfGve3sS
         TciCElcziVMMlQYHo+QhF5MYeOecM22p/OmqEDpTGTAN42zdCONTP/e9ktyK9/+nTB
         QKJPeoSE9PMMKt1/5YfXvcbk2xzdckDD3IRpVwtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 500/800] mt76: mt7921: do not schedule hw reset if the device is not running
Date:   Mon, 12 Jul 2021 08:08:43 +0200
Message-Id: <20210712061020.396248724@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d74c4b5667425c35d74906795a08e02e29df5b46 ]

Do not schedule hw full reset if the device is not fully initialized
(e.g if the channel has not been configured yet). This patch fixes
the kernel crash reported below

[   44.440266] mt7921e 0000:01:00.0: chip reset failed
[   44.527575] Unable to handle kernel paging request at virtual address ffffffc02f3e0000
[   44.535771] Mem abort info:
[   44.538646]   ESR = 0x96000006
[   44.541792]   EC = 0x25: DABT (current EL), IL = 32 bits
[   44.547268]   SET = 0, FnV = 0
[   44.550413]   EA = 0, S1PTW = 0
[   44.553648] Data abort info:
[   44.556613]   ISV = 0, ISS = 0x00000006
[   44.560563]   CM = 0, WnR = 0
[   44.563619] swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000000955000
[   44.570530] [ffffffc02f3e0000] pgd=100000003ffff003, p4d=100000003ffff003, pud=100000003ffff003, pmd=0000000000000000
[   44.581489] Internal error: Oops: 96000006 [#1] SMP
[   44.606406] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.13.0-rc1-espressobin-12875-g6dc7f82ebc26 #33
[   44.617264] Hardware name: Globalscale Marvell ESPRESSOBin Board (DT)
[   44.623905] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO BTYPE=--)
[   44.630100] pc : __queue_work+0x1f0/0x500
[   44.634249] lr : __queue_work+0x1e8/0x500
[   44.638384] sp : ffffffc010003d70
[   44.641798] x29: ffffffc010003d70 x28: 0000000000000000 x27: ffffff8003989200
[   44.649166] x26: ffffffc010c08510 x25: 0000000000000002 x24: ffffffc010ad90b0
[   44.656533] x23: ffffffc010c08508 x22: 0000000000000012 x21: 0000000000000000
[   44.663899] x20: ffffff8006385238 x19: ffffffc02f3e0000 x18: 00000000000003c9
[   44.671266] x17: 0000000000000000 x16: 0000000000000000 x15: 000009b1a8a3bf90
[   44.678632] x14: 0098968000000000 x13: 0000000000000000 x12: 0000000000000325
[   44.685998] x11: ffffff803fda1928 x10: 0000000000000001 x9 : ffffffc010003e98
[   44.693365] x8 : 0000000000000032 x7 : fff8000000000000 x6 : 0000000000000035
[   44.700732] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffffc010adf700
[   44.708098] x2 : ffffff8006385238 x1 : 000000007fffffff x0 : 0000000000000000
[   44.715465] Call trace:
[   44.717982]  __queue_work+0x1f0/0x500
[   44.721760]  delayed_work_timer_fn+0x18/0x20
[   44.726167]  call_timer_fn+0x2c/0x178
[   44.729947]  run_timer_softirq+0x488/0x5c8
[   44.734172]  _stext+0x11c/0x378
[   44.737411]  irq_exit+0x100/0x108
[   44.740830]  __handle_domain_irq+0x60/0xb0
[   44.745059]  gic_handle_irq+0x70/0x2b4
[   44.748929]  el1_irq+0xb8/0x13c
[   44.752167]  arch_cpu_idle+0x14/0x30
[   44.755858]  default_idle_call+0x38/0x168
[   44.759994]  do_idle+0x1fc/0x210
[   44.763325]  cpu_startup_entry+0x20/0x58
[   44.767372]  rest_init+0xb8/0xc8
[   44.770703]  arch_call_rest_init+0xc/0x14
[   44.774841]  start_kernel+0x408/0x424
[   44.778623] Code: aa1403e0 97fff54f aa0003f5 b5fff500 (f9400275)
[   44.784907] ---[ end trace be73c3142d8c36a9 ]---
[   44.789668] Kernel panic - not syncing: Oops: Fatal exception in interrupt

Fixes: 0c1ce9884607 ("mt76: mt7921: add wifi reset support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 4eac7c3206f9..5e00dd589331 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1308,6 +1308,9 @@ void mt7921_reset(struct mt76_dev *mdev)
 {
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
 
+	if (!test_bit(MT76_STATE_RUNNING, &dev->mphy.state))
+		return;
+
 	if (!dev->hw_full_reset)
 		queue_work(dev->mt76.wq, &dev->reset_work);
 }
-- 
2.30.2



