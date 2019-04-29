Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CC2E6DC
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 17:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfD2Pth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 11:49:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36522 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbfD2Pth (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 11:49:37 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DF7E01A017F;
        Mon, 29 Apr 2019 17:49:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D3FBC1A0175;
        Mon, 29 Apr 2019 17:49:35 +0200 (CEST)
Received: from fsr-ub1664-009.ea.freescale.net (fsr-ub1664-009.ea.freescale.net [10.171.71.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 89A76205EE;
        Mon, 29 Apr 2019 17:49:35 +0200 (CEST)
From:   Diana Craciun <diana.craciun@nxp.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linuxppc-dev@ozlabs.org, mpe@ellerman.id.au,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH stable v4.4 2/8] powerpc/fsl: Flush branch predictor when entering KVM
Date:   Mon, 29 Apr 2019 18:49:02 +0300
Message-Id: <1556552948-24957-3-git-send-email-diana.craciun@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e7aa61f47b23afbec41031bc47ca8d6cb6516abc upstream.

Switching from the guest to host is another place
where the speculative accesses can be exploited.
Flush the branch predictor when entering KVM.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kvm/bookehv_interrupts.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kvm/bookehv_interrupts.S b/arch/powerpc/kvm/bookehv_interrupts.S
index 81bd8a07aa51..612b7f6a887f 100644
--- a/arch/powerpc/kvm/bookehv_interrupts.S
+++ b/arch/powerpc/kvm/bookehv_interrupts.S
@@ -75,6 +75,10 @@
 	PPC_LL	r1, VCPU_HOST_STACK(r4)
 	PPC_LL	r2, HOST_R2(r1)
 
+START_BTB_FLUSH_SECTION
+	BTB_FLUSH(r10)
+END_BTB_FLUSH_SECTION
+
 	mfspr	r10, SPRN_PID
 	lwz	r8, VCPU_HOST_PID(r4)
 	PPC_LL	r11, VCPU_SHARED(r4)
-- 
2.17.1

