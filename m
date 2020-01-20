Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DB21428E3
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 12:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgATLJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 06:09:57 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52193 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgATLJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 06:09:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 906BB50F;
        Mon, 20 Jan 2020 06:09:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 Jan 2020 06:09:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Aqnwxd
        dNpOm/qHAxoSEfcdbtvJkZ7YO1te8RHcHR014=; b=N+uRy0PwC3ClquISwGx8AI
        qabUJNZij3JlCOWPWLtTqzr7Kl5sV4XViXhKwKiCZ0Buoz1B+MDI8j+UAFCovuUf
        70FbYNloe8BD/WABEOGfCZLvCqwsPPLi/BjRLhkY5NZqRxMWbXynQy2AvfKre360
        zoC/IsW3Ug+JSge9Wgnqxw2YORor86Y1VoVD2RxXIIY4gZe/PikNN6Ny9vnIfSZP
        FcPwXLXxbTz1a+x7jSYZrt9QLGcEzNHA0jMNuiMkDjHsygy4VpI2g5YCRHu9Lm4e
        bhLYaaHXu3HpckxABNXKZW+BwmhN7CknNg3Pr+LBNHL68tIWv+jdVCCLQXf4kryg
        ==
X-ME-Sender: <xms:hIolXra3x0lV8jCTaiQ1Vw0rBx9bhqYeJwGOZNNLh-0hbwhzIMlz_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhephhgvrggurdhssgenucfkphepkeelrddvtdehrdduvdelrdduvd
    efnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hIolXtQ5BdiA0SdraS-1jzObFymYvVWyUb9H0okhVgxLBGLcQNUzRA>
    <xmx:hIolXm9Kx1fRUiNRpceLp0HT5EXR1NawNYjbYsltXmoWdGxvXq-imw>
    <xmx:hIolXhJ6fepr5iUcd-JPCOrP5Wh1vWVW74RyRd8KBc_D0kU45IAIrQ>
    <xmx:hIolXo9bDQkTFlCfl6meMQiWLboMuQL5BjM66FMa7sTRG2nW9X9hSQ>
Received: from localhost (unknown [89.205.129.123])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64272306099F;
        Mon, 20 Jan 2020 06:09:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] riscv: make sure the cores stay looping in .Lsecondary_park" failed to apply to 5.4-stable tree
To:     greentime.hu@sifive.com, anup.patel@sifive.com,
        paul.walmsley@sifive.com, schwab@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jan 2020 12:09:52 +0100
Message-ID: <157951859214051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20d2292754e72e445abe62b7ac453eb945fc626c Mon Sep 17 00:00:00 2001
From: Greentime Hu <greentime.hu@sifive.com>
Date: Wed, 15 Jan 2020 14:54:36 +0800
Subject: [PATCH] riscv: make sure the cores stay looping in .Lsecondary_park

The code in secondary_park is currently placed in the .init section. The
kernel reclaims and clears this code when it finishes booting. That
causes the cores parked in it to go to somewhere unpredictable, so we
move this function out of init to make sure the cores stay looping there.

The instruction bgeu a0, t0, .Lsecondary_park may have "a relocation
truncated to fit" issue during linking time. It is because that sections
are too far to jump. Let's use tail to jump to the .Lsecondary_park.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Anup Patel <anup.patel@sifive.com>
Cc: Andreas Schwab <schwab@suse.de>
Cc: stable@vger.kernel.org
Fixes: 76d2a0493a17d ("RISC-V: Init and Halt Code")
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 2227db63f895..a4242be66966 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -80,7 +80,9 @@ _start_kernel:
 
 #ifdef CONFIG_SMP
 	li t0, CONFIG_NR_CPUS
-	bgeu a0, t0, .Lsecondary_park
+	blt a0, t0, .Lgood_cores
+	tail .Lsecondary_park
+.Lgood_cores:
 #endif
 
 	/* Pick one hart to run the main boot sequence */
@@ -209,11 +211,6 @@ relocate:
 	tail smp_callin
 #endif
 
-.align 2
-.Lsecondary_park:
-	/* We lack SMP support or have too many harts, so park this hart */
-	wfi
-	j .Lsecondary_park
 END(_start)
 
 #ifdef CONFIG_RISCV_M_MODE
@@ -295,6 +292,13 @@ ENTRY(reset_regs)
 END(reset_regs)
 #endif /* CONFIG_RISCV_M_MODE */
 
+.section ".text", "ax",@progbits
+.align 2
+.Lsecondary_park:
+	/* We lack SMP support or have too many harts, so park this hart */
+	wfi
+	j .Lsecondary_park
+
 __PAGE_ALIGNED_BSS
 	/* Empty zero page */
 	.balign PAGE_SIZE

