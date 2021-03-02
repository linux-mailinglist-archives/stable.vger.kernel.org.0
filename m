Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79D332AFEF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbhCCA3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447024AbhCBMmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:42:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB31E64F8A;
        Tue,  2 Mar 2021 11:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686284;
        bh=VBGEUfM8R1ukHmofVbcqaMFo2bRjl8dukiEr2Udl+Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MD39hstWPP/Pc6bKJDe4pHtNAT5OjYRLelrORNcwIOCGOhJ6SN1q9mor1qCfjmXPz
         6dQOE38IR5Qh2qmloHiqoteja0rzS3JCbeHoJIJ20OOvfm8ltUePgLVkO5tnuqBQUE
         UzrslcITzfaU9XvZGIVdYYl3NniW1gh72g8OAQUOTMCQKi1b6pnvl183y538ANzXgz
         99i75KMMMdo9dHLImCKQjAgASInAdRAc9cdYd3qg97DGsc/2LoYfFkK432D5Jm2Cqk
         lX5bXtFPZ5TFJSwBITceokvgnl3z3H0o/LO16xEMB7Rm2J+PbrxoIpSTF1v4VxXvT9
         RvhqJPoW/toJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 11/33] powerpc: improve handling of unrecoverable system reset
Date:   Tue,  2 Mar 2021 06:57:27 -0500
Message-Id: <20210302115749.62653-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 11cb0a25f71818ca7ab4856548ecfd83c169aa4d ]

If an unrecoverable system reset hits in process context, the system
does not have to panic. Similar to machine check, call nmi_exit()
before die().

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210130130852.2952424-26-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 206032c9b545..ecfa460f66d1 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -513,8 +513,11 @@ out:
 		die("Unrecoverable nested System Reset", regs, SIGABRT);
 #endif
 	/* Must die if the interrupt is not recoverable */
-	if (!(regs->msr & MSR_RI))
+	if (!(regs->msr & MSR_RI)) {
+		/* For the reason explained in die_mce, nmi_exit before die */
+		nmi_exit();
 		die("Unrecoverable System Reset", regs, SIGABRT);
+	}
 
 	if (saved_hsrrs) {
 		mtspr(SPRN_HSRR0, hsrr0);
-- 
2.30.1

