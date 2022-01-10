Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED856489271
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242632AbiAJHmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242305AbiAJHkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:40:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B611C033274;
        Sun,  9 Jan 2022 23:34:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 083A3B81161;
        Mon, 10 Jan 2022 07:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37372C36AE9;
        Mon, 10 Jan 2022 07:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800077;
        bh=/DDFgr2LIbKb0XYJ9YLVEgZM878o3QU3heZunPDRM+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/nuHRMaEDhvaNjDJES3TwLhz4FkyMngd9BI9GJQ6AEAU8L0s8hie4wysdolWjWk+
         EPKQTdwfOzhSyIHsDuBEVxo6sD+980ZlaAexTOzFsHqb4RZqd49+dY9IJ1IOqgwIn6
         hTTMP9t/K75ngDHZU1Nj0XpCfkQeJE3rEdTea69A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 39/72] i2c: mpc: Avoid out of bounds memory access
Date:   Mon, 10 Jan 2022 08:23:16 +0100
Message-Id: <20220110071822.876278145@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit 72a4a87da8f7bcf868b338615a814b6542f277f3 upstream.

When performing an I2C transfer where the last message was a write KASAN
would complain:

  BUG: KASAN: slab-out-of-bounds in mpc_i2c_do_action+0x154/0x630
  Read of size 2 at addr c814e310 by task swapper/2/0

  CPU: 2 PID: 0 Comm: swapper/2 Tainted: G    B             5.16.0-rc8 #1
  Call Trace:
  [e5ee9d50] [c08418e8] dump_stack_lvl+0x4c/0x6c (unreliable)
  [e5ee9d70] [c02f8a14] print_address_description.constprop.13+0x64/0x3b0
  [e5ee9da0] [c02f9030] kasan_report+0x1f0/0x204
  [e5ee9de0] [c0c76ee4] mpc_i2c_do_action+0x154/0x630
  [e5ee9e30] [c0c782c4] mpc_i2c_isr+0x164/0x240
  [e5ee9e60] [c00f3a04] __handle_irq_event_percpu+0xf4/0x3b0
  [e5ee9ec0] [c00f3d40] handle_irq_event_percpu+0x80/0x110
  [e5ee9f40] [c00f3e48] handle_irq_event+0x78/0xd0
  [e5ee9f60] [c00fcfec] handle_fasteoi_irq+0x19c/0x370
  [e5ee9fa0] [c00f1d84] generic_handle_irq+0x54/0x80
  [e5ee9fc0] [c0006b54] __do_irq+0x64/0x200
  [e5ee9ff0] [c0007958] __do_IRQ+0xe8/0x1c0
  [c812dd50] [e3eaab20] 0xe3eaab20
  [c812dd90] [c0007a4c] do_IRQ+0x1c/0x30
  [c812dda0] [c0000c04] ExternalInput+0x144/0x160
  --- interrupt: 500 at arch_cpu_idle+0x34/0x60
  NIP:  c000b684 LR: c000b684 CTR: c0019688
  REGS: c812ddb0 TRAP: 0500   Tainted: G    B              (5.16.0-rc8)
  MSR:  00029002 <CE,EE,ME>  CR: 22000488  XER: 20000000

  GPR00: c10ef7fc c812de90 c80ff200 c2394718 00000001 00000001 c10e3f90 00000003
  GPR08: 00000000 c0019688 c2394718 fc7d625b 22000484 00000000 21e17000 c208228c
  GPR16: e3e99284 00000000 ffffffff c2390000 c001bac0 c2082288 c812df60 c001ba60
  GPR24: c23949c0 00000018 00080000 00000004 c80ff200 00000002 c2348ee4 c2394718
  NIP [c000b684] arch_cpu_idle+0x34/0x60
  LR [c000b684] arch_cpu_idle+0x34/0x60
  --- interrupt: 500
  [c812de90] [c10e3f90] rcu_eqs_enter.isra.60+0xc0/0x110 (unreliable)
  [c812deb0] [c10ef7fc] default_idle_call+0xbc/0x230
  [c812dee0] [c00af0e8] do_idle+0x1c8/0x200
  [c812df10] [c00af3c0] cpu_startup_entry+0x20/0x30
  [c812df20] [c001e010] start_secondary+0x5d0/0xba0
  [c812dff0] [c00028a0] __secondary_start+0x90/0xdc

This happened because we would overrun the i2c->msgs array on the final
interrupt for the I2C STOP. This didn't happen if the last message was a
read because there is no interrupt in that case. Ensure that we only
access the current message if we are not processing a I2C STOP
condition.

Fixes: 1538d82f4647 ("i2c: mpc: Interrupt driven transfer")
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mpc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -492,7 +492,7 @@ static void mpc_i2c_finish(struct mpc_i2
 
 static void mpc_i2c_do_action(struct mpc_i2c *i2c)
 {
-	struct i2c_msg *msg = &i2c->msgs[i2c->curr_msg];
+	struct i2c_msg *msg = NULL;
 	int dir = 0;
 	int recv_len = 0;
 	u8 byte;
@@ -501,10 +501,13 @@ static void mpc_i2c_do_action(struct mpc
 
 	i2c->cntl_bits &= ~(CCR_RSTA | CCR_MTX | CCR_TXAK);
 
-	if (msg->flags & I2C_M_RD)
-		dir = 1;
-	if (msg->flags & I2C_M_RECV_LEN)
-		recv_len = 1;
+	if (i2c->action != MPC_I2C_ACTION_STOP) {
+		msg = &i2c->msgs[i2c->curr_msg];
+		if (msg->flags & I2C_M_RD)
+			dir = 1;
+		if (msg->flags & I2C_M_RECV_LEN)
+			recv_len = 1;
+	}
 
 	switch (i2c->action) {
 	case MPC_I2C_ACTION_RESTART:
@@ -581,7 +584,7 @@ static void mpc_i2c_do_action(struct mpc
 		break;
 	}
 
-	if (msg->len == i2c->byte_posn) {
+	if (msg && msg->len == i2c->byte_posn) {
 		i2c->curr_msg++;
 		i2c->byte_posn = 0;
 


