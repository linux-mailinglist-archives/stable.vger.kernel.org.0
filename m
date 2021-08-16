Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6BB3ED511
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbhHPNHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237080AbhHPNGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC23660E78;
        Mon, 16 Aug 2021 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119159;
        bh=ZZE+JhIRF95IGfF6gSywIH6p3aLm9Qh8DaaV98Yq+zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kq07E2ZU/ya4eem1tDqUVMlVEvS8Gxg0NEXTQDgUEuX/n7X1CIOfrLV2F1HMIKWpt
         PvkPUSHU5G0Un91by+Fi8wISrsORAzEKiz/WIXjpC+MneLnXhHBWJq4tvkESDR6Yg9
         zAumO4ZIiS1zwMEKMunTJXbQ9cgvCqlyyNNheGBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.10 15/96] ARC: fp: set FPU_STATUS.FWE to enable FPU_STATUS update on context switch
Date:   Mon, 16 Aug 2021 15:01:25 +0200
Message-Id: <20210816125435.432870223@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit 3a715e80400f452b247caa55344f4f60250ffbcf upstream.

FPU_STATUS register contains FP exception flags bits which are updated
by core as side-effect of FP instructions but can also be manually
wiggled such as by glibc C99 functions fe{raise,clear,test}except() etc.
To effect the update, the programming model requires OR'ing FWE
bit (31). This bit is write-only and RAZ, meaning it is effectively
auto-cleared after write and thus needs to be set everytime: which
is how glibc implements this.

However there's another usecase of FPU_STATUS update, at the time of
Linux task switch when incoming task value needs to be programmed into
the register. This was added as part of f45ba2bd6da0dc ("ARCv2:
fpu: preserve userspace fpu state") which missed OR'ing FWE bit,
meaning the new value is effectively not being written at all.
This patch remedies that.

Interestingly, this snafu was not caught in interm glibc testing as the
race window which relies on a specific exception bit to be set/clear is
really small specially when it nvolves context switch.
Fortunately this was caught by glibc's math/test-fenv-tls test which
repeatedly set/clear exception flags in a big loop, concurrently in main
program and also in a thread.

Fixes: https://github.com/foss-for-synopsys-dwc-arc-processors/linux/issues/54
Fixes: f45ba2bd6da0dc ("ARCv2: fpu: preserve userspace fpu state")
Cc: stable@vger.kernel.org	#5.6+
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/kernel/fpu.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arc/kernel/fpu.c
+++ b/arch/arc/kernel/fpu.c
@@ -57,23 +57,26 @@ void fpu_save_restore(struct task_struct
 
 void fpu_init_task(struct pt_regs *regs)
 {
+	const unsigned int fwe = 0x80000000;
+
 	/* default rounding mode */
 	write_aux_reg(ARC_REG_FPU_CTRL, 0x100);
 
-	/* set "Write enable" to allow explicit write to exception flags */
-	write_aux_reg(ARC_REG_FPU_STATUS, 0x80000000);
+	/* Initialize to zero: setting requires FWE be set */
+	write_aux_reg(ARC_REG_FPU_STATUS, fwe);
 }
 
 void fpu_save_restore(struct task_struct *prev, struct task_struct *next)
 {
 	struct arc_fpu *save = &prev->thread.fpu;
 	struct arc_fpu *restore = &next->thread.fpu;
+	const unsigned int fwe = 0x80000000;
 
 	save->ctrl = read_aux_reg(ARC_REG_FPU_CTRL);
 	save->status = read_aux_reg(ARC_REG_FPU_STATUS);
 
 	write_aux_reg(ARC_REG_FPU_CTRL, restore->ctrl);
-	write_aux_reg(ARC_REG_FPU_STATUS, restore->status);
+	write_aux_reg(ARC_REG_FPU_STATUS, (fwe | restore->status));
 }
 
 #endif


