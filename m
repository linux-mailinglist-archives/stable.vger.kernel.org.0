Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5132AF9E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbhCCA12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350696AbhCBMXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:23:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC8BC64FBB;
        Tue,  2 Mar 2021 11:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686349;
        bh=OKD14DHhRPGSXdDZLxNIcrpuwT1WbTQgy31IxhDu1Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESm4FUiJf9fjpiriL0HRoF6ZFE/M16FavPOQLa326tlIQMAQwEJMZBv3fg9Oxpc4O
         BeVg+QEBQ1l562nnycTrE7HqqFYe7tuFpgdSQeQ+u6sLzlTHulNDZ9uPkGyBf30LDs
         O6Fld80/xLQ7EyGnij1IFWsoFWO9xLW9QDLCPMBNYiQDeIGqokDikyFFRiPPY2HFvg
         eYs9wKU5PsWf3AW9N6Jq8CCuNXNPDPhvvleb/FzKf+97DdLwscr76FB5vtMGBEqM1f
         IdKyeOB3wAtKEEqIKL5k4SZO8cDB3utetiNcGfaps4wJ+kchYjK5uGpoTi5yXm2tco
         EAK/khqpcU4eQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 04/13] powerpc: improve handling of unrecoverable system reset
Date:   Tue,  2 Mar 2021 06:58:54 -0500
Message-Id: <20210302115903.63458-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115903.63458-1-sashal@kernel.org>
References: <20210302115903.63458-1-sashal@kernel.org>
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
index 0f1a888c04a8..05c1aabad01c 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -360,8 +360,11 @@ out:
 		die("Unrecoverable nested System Reset", regs, SIGABRT);
 #endif
 	/* Must die if the interrupt is not recoverable */
-	if (!(regs->msr & MSR_RI))
+	if (!(regs->msr & MSR_RI)) {
+		/* For the reason explained in die_mce, nmi_exit before die */
+		nmi_exit();
 		die("Unrecoverable System Reset", regs, SIGABRT);
+	}
 
 	if (!nested)
 		nmi_exit();
-- 
2.30.1

