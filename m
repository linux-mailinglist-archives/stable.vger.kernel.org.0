Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 079CF442DA
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389900AbfFMQ0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730962AbfFMIgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:36:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D267E2146F;
        Thu, 13 Jun 2019 08:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414975;
        bh=kE+uGtDQKW1Jj3Yciy+XjTzpwYjBRNkMuTsYOVYmenw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJF8EQjxvxnY+pm7Z5kkmz5OGnbSDaCGb+/QCmpgo+DmSUFrmILasfw4Ku8U5Obfw
         ddGp295kVnLiz9fK6c5jkthrZ1BbrnLp13jHgVeFUjHnUgDDoblo0zmoKHCLxeM4UI
         u/8764xMoLQPKchf2MDIJeO8dL8dheWNZYw0lxVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Binbin Wu <binbin.wu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/81] mfd: intel-lpss: Set the device in reset state when init
Date:   Thu, 13 Jun 2019 10:33:00 +0200
Message-Id: <20190613075650.334771159@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dad06532292d77f37fbe831a02948a593500f682 ]

In virtualized setup, when system reboots due to warm
reset interrupt storm is seen.

Call Trace:
<IRQ>
dump_stack+0x70/0xa5
__report_bad_irq+0x2e/0xc0
note_interrupt+0x248/0x290
? add_interrupt_randomness+0x30/0x220
handle_irq_event_percpu+0x54/0x80
handle_irq_event+0x39/0x60
handle_fasteoi_irq+0x91/0x150
handle_irq+0x108/0x180
do_IRQ+0x52/0xf0
common_interrupt+0xf/0xf
</IRQ>
RIP: 0033:0x76fc2cfabc1d
Code: 24 28 bf 03 00 00 00 31 c0 48 8d 35 63 77 0e 00 48 8d 15 2e
94 0e 00 4c 89 f9 49 89 d9 4c 89 d3 e8 b8 e2 01 00 48 8b 54 24 18
<48> 89 ef 48 89 de 4c 89 e1 e8 d5 97 01 00 84 c0 74 2d 48 8b 04
24
RSP: 002b:00007ffd247c1fc0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffffda
RAX: 0000000000000000 RBX: 00007ffd247c1ff0 RCX: 000000000003d3ce
RDX: 0000000000000000 RSI: 00007ffd247c1ff0 RDI: 000076fc2cbb6010
RBP: 000076fc2cded010 R08: 00007ffd247c2210 R09: 00007ffd247c22a0
R10: 000076fc29465470 R11: 0000000000000000 R12: 00007ffd247c1fc0
R13: 000076fc2ce8e470 R14: 000076fc27ec9960 R15: 0000000000000414
handlers:
[<000000000d3fa913>] idma64_irq
Disabling IRQ #27

To avoid interrupt storm, set the device in reset state
before bringing out the device from reset state.

Changelog v2:
- correct the subject line by adding "mfd: "

Signed-off-by: Binbin Wu <binbin.wu@intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/intel-lpss.c b/drivers/mfd/intel-lpss.c
index 40e8d9b59d07..b5c4f8f974aa 100644
--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -273,6 +273,9 @@ static void intel_lpss_init_dev(const struct intel_lpss *lpss)
 {
 	u32 value = LPSS_PRIV_SSP_REG_DIS_DMA_FIN;
 
+	/* Set the device in reset state */
+	writel(0, lpss->priv + LPSS_PRIV_RESETS);
+
 	intel_lpss_deassert_reset(lpss);
 
 	intel_lpss_set_remap_addr(lpss);
-- 
2.20.1



