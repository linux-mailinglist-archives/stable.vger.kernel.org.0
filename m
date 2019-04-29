Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4630FE6DB
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 17:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfD2Ptd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 11:49:33 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53662 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbfD2Ptd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 11:49:33 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4199C200263;
        Mon, 29 Apr 2019 17:49:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 34C83200251;
        Mon, 29 Apr 2019 17:49:32 +0200 (CEST)
Received: from fsr-ub1664-009.ea.freescale.net (fsr-ub1664-009.ea.freescale.net [10.171.71.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DF902205EE;
        Mon, 29 Apr 2019 17:49:31 +0200 (CEST)
From:   Diana Craciun <diana.craciun@nxp.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linuxppc-dev@ozlabs.org, mpe@ellerman.id.au,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH stable v4.4 1/8] powerpc/fsl: Enable runtime patching if nospectre_v2 boot arg is used
Date:   Mon, 29 Apr 2019 18:49:01 +0300
Message-Id: <1556552948-24957-2-git-send-email-diana.craciun@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3bc8ea8603ae4c1e09aca8de229ad38b8091fcb3 upstream.

If the user choses not to use the mitigations, replace
the code sequence with nops.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kernel/setup_32.c | 1 +
 arch/powerpc/kernel/setup_64.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 5a9f035bcd6b..cb37f27bb928 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -323,6 +323,7 @@ void __init setup_arch(char **cmdline_p)
 	if ( ppc_md.progress ) ppc_md.progress("arch: exit", 0x3eab);
 
 	setup_barrier_nospec();
+	setup_spectre_v2();
 
 	paging_init();
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 6bb731ababc6..11590f6cb2f9 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -737,6 +737,7 @@ void __init setup_arch(char **cmdline_p)
 		ppc_md.setup_arch();
 
 	setup_barrier_nospec();
+	setup_spectre_v2();
 
 	paging_init();
 
-- 
2.17.1

