Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA8829A115
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409452AbgJ0AcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409696AbgJZXwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A091221F7;
        Mon, 26 Oct 2020 23:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756339;
        bh=I7ND9zZbIMJSh/zsLnYBt0JTHrjjwCwqQGDRU/sWW9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlDQf5sO2K+V2K8AYHwsrbQ8ArnWhQE01nbv+HCeeKM9AxstpFbLmlmKT7rWeWOQr
         qqzN0nX3YCbkwPkxhWLpwIUxFaNrGfCHIxoOowXdDxBjnm2a0/Oq8m/W6rAtlAqiVz
         08dlv2rdxzATA+7o9PhDEw2SKk8kWdFLIFBZamG8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 012/132] s390/startup: avoid save_area_sync overflow
Date:   Mon, 26 Oct 2020 19:50:04 -0400
Message-Id: <20201026235205.1023962-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 2835c2ea95d50625108e47a459e1a47f6be836ce ]

Currently we overflow save_area_sync and write over
save_area_async. Although this is not a real problem make
startup_pgm_check_handler consistent with late pgm check handler and
store [%r0,%r7] directly into gpregs_save_area.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/head.S | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/s390/boot/head.S b/arch/s390/boot/head.S
index dae10961d0724..1a2c2b1ed9649 100644
--- a/arch/s390/boot/head.S
+++ b/arch/s390/boot/head.S
@@ -360,22 +360,23 @@ ENTRY(startup_kdump)
 # the save area and does disabled wait with a faulty address.
 #
 ENTRY(startup_pgm_check_handler)
-	stmg	%r0,%r15,__LC_SAVE_AREA_SYNC
-	la	%r1,4095
-	stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-4095(%r1)
-	mvc	__LC_GPREGS_SAVE_AREA-4095(128,%r1),__LC_SAVE_AREA_SYNC
-	mvc	__LC_PSW_SAVE_AREA-4095(16,%r1),__LC_PGM_OLD_PSW
+	stmg	%r8,%r15,__LC_SAVE_AREA_SYNC
+	la	%r8,4095
+	stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-4095(%r8)
+	stmg	%r0,%r7,__LC_GPREGS_SAVE_AREA-4095(%r8)
+	mvc	__LC_GPREGS_SAVE_AREA-4095+64(64,%r8),__LC_SAVE_AREA_SYNC
+	mvc	__LC_PSW_SAVE_AREA-4095(16,%r8),__LC_PGM_OLD_PSW
 	mvc	__LC_RETURN_PSW(16),__LC_PGM_OLD_PSW
 	ni	__LC_RETURN_PSW,0xfc	# remove IO and EX bits
 	ni	__LC_RETURN_PSW+1,0xfb	# remove MCHK bit
 	oi	__LC_RETURN_PSW+1,0x2	# set wait state bit
-	larl	%r2,.Lold_psw_disabled_wait
-	stg	%r2,__LC_PGM_NEW_PSW+8
-	l	%r15,.Ldump_info_stack-.Lold_psw_disabled_wait(%r2)
+	larl	%r9,.Lold_psw_disabled_wait
+	stg	%r9,__LC_PGM_NEW_PSW+8
+	l	%r15,.Ldump_info_stack-.Lold_psw_disabled_wait(%r9)
 	brasl	%r14,print_pgm_check_info
 .Lold_psw_disabled_wait:
-	la	%r1,4095
-	lmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-4095(%r1)
+	la	%r8,4095
+	lmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-4095(%r8)
 	lpswe	__LC_RETURN_PSW		# disabled wait
 .Ldump_info_stack:
 	.long	0x5000 + PAGE_SIZE - STACK_FRAME_OVERHEAD
-- 
2.25.1

