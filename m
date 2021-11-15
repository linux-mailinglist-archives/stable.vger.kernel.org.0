Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250AA452615
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356012AbhKPCBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240141AbhKOSF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E426337E;
        Mon, 15 Nov 2021 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998187;
        bh=mNXC79MpoLchEh0wVYFIsOCuo2/bIiU/kRAse4h7NeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snO2YEZ92ldOUUatPG6XG4c6RC3RFPJU55p1ST+s3soxMyCFsGmB9y7yi0GSwxXZS
         GfzBELpllvtMBa2uzMjUipxiArPJcn3NJLafa4xiA8GBKvxzx51+KByNXrwRAJVpVL
         IYj84i3PPCgCV50t+NLiWtDNN/kBkPcThcnGgr/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/575] video: fbdev: chipsfb: use memset_io() instead of memset()
Date:   Mon, 15 Nov 2021 18:02:24 +0100
Message-Id: <20211115165358.254383898@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit f2719b26ae27282c145202ffd656d5ff1fe737cc ]

While investigating a lockup at startup on Powerbook 3400C, it was
identified that the fbdev driver generates alignment exception at
startup:

  --- interrupt: 600 at memset+0x60/0xc0
  NIP:  c0021414 LR: c03fc49c CTR: 00007fff
  REGS: ca021c10 TRAP: 0600   Tainted: G        W          (5.14.2-pmac-00727-g12a41fa69492)
  MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 44008442  XER: 20000100
  DAR: cab80020 DSISR: 00017c07
  GPR00: 00000007 ca021cd0 c14412e0 cab80000 00000000 00100000 cab8001c 00000004
  GPR08: 00100000 00007fff 00000000 00000000 84008442 00000000 c0006fb4 00000000
  GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00100000
  GPR24: 00000000 81800000 00000320 c15fa400 c14d1878 00000000 c14d1800 c094e19c
  NIP [c0021414] memset+0x60/0xc0
  LR [c03fc49c] chipsfb_pci_init+0x160/0x580
  --- interrupt: 600
  [ca021cd0] [c03fc46c] chipsfb_pci_init+0x130/0x580 (unreliable)
  [ca021d20] [c03a3a70] pci_device_probe+0xf8/0x1b8
  [ca021d50] [c043d584] really_probe.part.0+0xac/0x388
  [ca021d70] [c043d914] __driver_probe_device+0xb4/0x170
  [ca021d90] [c043da18] driver_probe_device+0x48/0x144
  [ca021dc0] [c043e318] __driver_attach+0x11c/0x1c4
  [ca021de0] [c043ad30] bus_for_each_dev+0x88/0xf0
  [ca021e10] [c043c724] bus_add_driver+0x190/0x22c
  [ca021e40] [c043ee94] driver_register+0x9c/0x170
  [ca021e60] [c0006c28] do_one_initcall+0x54/0x1ec
  [ca021ed0] [c08246e4] kernel_init_freeable+0x1c0/0x270
  [ca021f10] [c0006fdc] kernel_init+0x28/0x11c
  [ca021f30] [c0017148] ret_from_kernel_thread+0x14/0x1c
  Instruction dump:
  7d4601a4 39490777 7d4701a4 39490888 7d4801a4 39490999 7d4901a4 39290aaa
  7d2a01a4 4c00012c 4bfffe88 0fe00000 <4bfffe80> 9421fff0 38210010 48001970

This is due to 'dcbz' instruction being used on non-cached memory.
'dcbz' instruction is used by memset() to zeroize a complete
cacheline at once, and memset() is not expected to be used on non
cached memory.

When performing a 'sparse' check on fbdev driver, it also appears
that the use of memset() is unexpected:

  drivers/video/fbdev/chipsfb.c:334:17: warning: incorrect type in argument 1 (different address spaces)
  drivers/video/fbdev/chipsfb.c:334:17:    expected void *
  drivers/video/fbdev/chipsfb.c:334:17:    got char [noderef] __iomem *screen_base
  drivers/video/fbdev/chipsfb.c:334:15: warning: memset with byte count of 1048576

Use fb_memset() instead of memset(). fb_memset() is defined as
memset_io() for powerpc.

Fixes: 8c8709334cec ("[PATCH] ppc32: Remove CONFIG_PMAC_PBOOK")
Reported-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/884a54f1e5cb774c1d9b4db780209bee5d4f6718.1631712563.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/chipsfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index 998067b701fa0..393894af26f84 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -331,7 +331,7 @@ static const struct fb_var_screeninfo chipsfb_var = {
 
 static void init_chips(struct fb_info *p, unsigned long addr)
 {
-	memset(p->screen_base, 0, 0x100000);
+	fb_memset(p->screen_base, 0, 0x100000);
 
 	p->fix = chipsfb_fix;
 	p->fix.smem_start = addr;
-- 
2.33.0



