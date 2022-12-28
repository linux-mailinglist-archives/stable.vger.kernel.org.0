Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF3657E97
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiL1PzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiL1PzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:55:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F2A186FA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:55:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2078B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A29C433D2;
        Wed, 28 Dec 2022 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242917;
        bh=1NvxhHXyieoEnwkcsiDEUb0ybq/zQFAIB3q5mfYIKTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmfFpRpPiE/YGMZ8gIVI5O4SfwcLEYmD1L65ar6KF3V5+8c93LkQM1wH8Gc5yUbk3
         KHYUlIjuRLFp0igYAA9B4rbRiR/jCgWoZqcTCJJxylZ4TqAsDoFYBSeU2bEdNkq4r/
         4MU+Q3BAX1yLmEgNzech9yvpux3iu1dMrwq7IG2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0469/1073] ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt
Date:   Wed, 28 Dec 2022 15:34:17 +0100
Message-Id: <20221228144340.776669662@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit cf2ea3c86ad90d63d1c572b43e1ca9276b0357ad ]

I got a null-ptr-defer error report when I do the following tests
on the qemu platform:

make defconfig and CONFIG_PARPORT=m, CONFIG_PARPORT_PC=m,
CONFIG_SND_MTS64=m

Then making test scripts:
cat>test_mod1.sh<<EOF
modprobe snd-mts64
modprobe snd-mts64
EOF

Executing the script, perhaps several times, we will get a null-ptr-defer
report, as follow:

syzkaller:~# ./test_mod.sh
snd_mts64: probe of snd_mts64.0 failed with error -5
modprobe: ERROR: could not insert 'snd_mts64': No such device
 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 0 P4D 0
 Oops: 0002 [#1] PREEMPT SMP PTI
 CPU: 0 PID: 205 Comm: modprobe Not tainted 6.1.0-rc8-00588-g76dcd734eca2 #6
 Call Trace:
  <IRQ>
  snd_mts64_interrupt+0x24/0xa0 [snd_mts64]
  parport_irq_handler+0x37/0x50 [parport]
  __handle_irq_event_percpu+0x39/0x190
  handle_irq_event_percpu+0xa/0x30
  handle_irq_event+0x2f/0x50
  handle_edge_irq+0x99/0x1b0
  __common_interrupt+0x5d/0x100
  common_interrupt+0xa0/0xc0
  </IRQ>
  <TASK>
  asm_common_interrupt+0x22/0x40
 RIP: 0010:_raw_write_unlock_irqrestore+0x11/0x30
  parport_claim+0xbd/0x230 [parport]
  snd_mts64_probe+0x14a/0x465 [snd_mts64]
  platform_probe+0x3f/0xa0
  really_probe+0x129/0x2c0
  __driver_probe_device+0x6d/0xc0
  driver_probe_device+0x1a/0xa0
  __device_attach_driver+0x7a/0xb0
  bus_for_each_drv+0x62/0xb0
  __device_attach+0xe4/0x180
  bus_probe_device+0x82/0xa0
  device_add+0x550/0x920
  platform_device_add+0x106/0x220
  snd_mts64_attach+0x2e/0x80 [snd_mts64]
  port_check+0x14/0x20 [parport]
  bus_for_each_dev+0x6e/0xc0
  __parport_register_driver+0x7c/0xb0 [parport]
  snd_mts64_module_init+0x31/0x1000 [snd_mts64]
  do_one_initcall+0x3c/0x1f0
  do_init_module+0x46/0x1c6
  load_module+0x1d8d/0x1e10
  __do_sys_finit_module+0xa2/0xf0
  do_syscall_64+0x37/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  </TASK>
 Kernel panic - not syncing: Fatal exception in interrupt
 Rebooting in 1 seconds..

The mts wa not initialized during interrupt,  we add check for
mts to fix this bug.

Fixes: 68ab801e32bb ("[ALSA] Add snd-mts64 driver for ESI Miditerminal 4140")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221206061004.1222966-1-cuigaosheng1@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/mts64.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
index d3bc9e8c407d..f0d34cf70c3e 100644
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -815,6 +815,9 @@ static void snd_mts64_interrupt(void *private)
 	u8 status, data;
 	struct snd_rawmidi_substream *substream;
 
+	if (!mts)
+		return;
+
 	spin_lock(&mts->lock);
 	ret = mts64_read(mts->pardev->port);
 	data = ret & 0x00ff;
-- 
2.35.1



