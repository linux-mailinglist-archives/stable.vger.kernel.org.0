Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD749A2D4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351724AbiAXXyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845918AbiAXXNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:13:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28614C067A73;
        Mon, 24 Jan 2022 13:20:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9E18B80FA1;
        Mon, 24 Jan 2022 21:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E196C340E4;
        Mon, 24 Jan 2022 21:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059199;
        bh=2Q3z21wUM/yblriBfeXIPQJaC4MoMvTMrfXYkzT5yWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loSakum/78fAD6gV6a5u74cKJ8hUtYHrgh84o5agO2Dl+0Y1KIKboRvO2kkQPE57r
         NBHeQWNvyxpT+ZfTaSplE3T6LQNu1P4waeW8Y5mDHjShY9bYeJrOXz8NL8IBkG7S2o
         TnzfaSWESRDK2Cvc+ZvLi0q6yJjCMc0GUtwlbGFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin He <justin.he@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0536/1039] mailbox: pcc: Handle all PCC subtypes correctly in pcc_mbox_irq
Date:   Mon, 24 Jan 2022 19:38:45 +0100
Message-Id: <20220124184143.297944034@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 7215a7857e796c655ae1184b313556102fa8bc40 ]

Commit c45ded7e1135 ("mailbox: pcc: Add support for PCCT extended PCC
subspaces(type 3/4)") enabled the type3/4 of PCCT, but the change in
pcc_mbox_irq breaks the other PCC subtypes.

The kernel reports a warning on an Ampere eMag server

-->8
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.16.0-rc4 #127
 Hardware name: MiTAC RAPTOR EV-883832-X3-0001/RAPTOR, BIOS 0.14 02/22/2019
 Call trace:
  dump_backtrace+0x0/0x200
  show_stack+0x20/0x30
  dump_stack_lvl+0x68/0x84
  dump_stack+0x18/0x34
  __report_bad_irq+0x54/0x17c
  note_interrupt+0x330/0x428
  handle_irq_event_percpu+0x90/0x98
  handle_irq_event+0x4c/0x148
  handle_fasteoi_irq+0xc4/0x188
  generic_handle_domain_irq+0x44/0x68
  gic_handle_irq+0x84/0x2ec
  call_on_irq_stack+0x28/0x34
  do_interrupt_handler+0x88/0x90
  el1_interrupt+0x48/0xb0
  el1h_64_irq_handler+0x18/0x28
  el1h_64_irq+0x7c/0x80

Fixes: c45ded7e1135 ("mailbox: pcc: Add support for PCCT extended PCC subspaces(type 3/4)")
Reported-by: Justin He <justin.he@arm.com>
Tested-by: Justin He <justin.he@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index e0a1ab3861f0d..ed18936b8ce68 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -241,9 +241,11 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	if (ret)
 		return IRQ_NONE;
 
-	val &= pchan->cmd_complete.status_mask;
-	if (!val)
-		return IRQ_NONE;
+	if (val) { /* Ensure GAS exists and value is non-zero */
+		val &= pchan->cmd_complete.status_mask;
+		if (!val)
+			return IRQ_NONE;
+	}
 
 	ret = pcc_chan_reg_read(&pchan->error, &val);
 	if (ret)
-- 
2.34.1



