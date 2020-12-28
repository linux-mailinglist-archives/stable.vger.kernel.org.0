Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2C2E3A33
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390640AbgL1Nd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:33:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387910AbgL1Nd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1FE12063A;
        Mon, 28 Dec 2020 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162367;
        bh=jtUitWLLgs3FggGy8jqFsSicHcVMQKTpSuregd/+HBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/PAsRvBLy96lTG0xIAIuUNqNON3Eh4wusMtoGuvpRIky2Hdj5PdSXjJD1pIzDt63
         AEf/cy5Ro99FWskcYZiq4lDz2JDbWt+cyO+5oGYnWGj84nW/vIyanK6uNg3lb2RiaW
         jQLSITon01yyUZ4VSFC8CY114UW6w/0NTnM0NIig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        Xiaoying Yan <yiyan@redhat.com>,
        Lianbo Jiang <lijiang@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.19 280/346] s390/kexec_file: fix diag308 subcode when loading crash kernel
Date:   Mon, 28 Dec 2020 13:49:59 +0100
Message-Id: <20201228124933.317068748@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

commit 613775d62ec60202f98d2c5f520e6e9ba6dd4ac4 upstream.

diag308 subcode 0 performes a clear reset which inlcudes the reset of
all registers in the system. While this is the preferred behavior when
loading a normal kernel via kexec it prevents the crash kernel to store
the register values in the dump. To prevent this use subcode 1 when
loading a crash kernel instead.

Fixes: ee337f5469fd ("s390/kexec_file: Add crash support to image loader")
Cc: <stable@vger.kernel.org> # 4.17
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Reported-by: Xiaoying Yan <yiyan@redhat.com>
Tested-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/purgatory/head.S |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/s390/purgatory/head.S
+++ b/arch/s390/purgatory/head.S
@@ -61,14 +61,15 @@
 	jh	10b
 .endm
 
-.macro START_NEXT_KERNEL base
+.macro START_NEXT_KERNEL base subcode
 	lg	%r4,kernel_entry-\base(%r13)
 	lg	%r5,load_psw_mask-\base(%r13)
 	ogr	%r4,%r5
 	stg	%r4,0(%r0)
 
 	xgr	%r0,%r0
-	diag	%r0,%r0,0x308
+	lghi	%r1,\subcode
+	diag	%r0,%r1,0x308
 .endm
 
 .text
@@ -123,7 +124,7 @@ ENTRY(purgatory_start)
 	je	.start_crash_kernel
 
 	/* start normal kernel */
-	START_NEXT_KERNEL .base_crash
+	START_NEXT_KERNEL .base_crash 0
 
 .return_old_kernel:
 	lmg	%r6,%r15,gprregs-.base_crash(%r13)
@@ -227,7 +228,7 @@ ENTRY(purgatory_start)
 	MEMCPY	%r9,%r10,%r11
 
 	/* start crash kernel */
-	START_NEXT_KERNEL .base_dst
+	START_NEXT_KERNEL .base_dst 1
 
 
 load_psw_mask:


