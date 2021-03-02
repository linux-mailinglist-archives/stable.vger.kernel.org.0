Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9332AF2A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhCCAPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443538AbhCBMLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6283C64F5C;
        Tue,  2 Mar 2021 11:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686227;
        bh=JXnZzuhfjp+IoFjmftM4WsrePuwRN8h6VGXcC/RrJo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+cvuqYgyltNcPZU0ot6QiUrWqBnsEP+VTYSEkbRYisfmUMnxSEBr97GYQ+r7fnxb
         ONwh83/DluVORSrebnh+rlxJ83H+pbLwYXqN20FCeQbtcjKhHoyRHV8pq4bgSxDPbB
         pnPQkUtPA21ecB/7MUOO8SMZGtFEkvjTzcD1TiRaWfzfuWBrqW8idntfiHAhIQ8lQ4
         E5Adk0ILo0flJXSAzydEoTfQcnoA4xwVU5f6GR7EWAbGGeD6oYbrc8ahkfRLdPI7z8
         9usYp0IxLw80gkkiuMP3M7WJDievYB3zeBYJcBD99LKre20O4gpy2gnDmqlKSn/963
         SEwx80wu6aZeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 16/47] powerpc: improve handling of unrecoverable system reset
Date:   Tue,  2 Mar 2021 06:56:15 -0500
Message-Id: <20210302115646.62291-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
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
index 5006dcbe1d9f..77dffea3d537 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -509,8 +509,11 @@ out:
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

