Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA0BCF61
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406289AbfIXQzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410746AbfIXQuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:50:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C45AB21D82;
        Tue, 24 Sep 2019 16:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343822;
        bh=XjRzfQOC8cj7/J/AH0SqkxazC1NYpjmNDLJsQklIF1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cx6M+Ir5Fs4dr2fL+qKog3DE569wmBzL+V0SitjSbH7dXuv4Fr3HUwL+LnFZ87I6D
         aLXifwM5/sCMswl2i1oUok2ZMtQsL+8HUfC98ORyNyn2r3UsCxHoTA/SB7O0Bq2q4n
         8BaSIeF6HOwb48eS4TCTjAvVE5TEZ4iH04cDxLfE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 45/50] powerpc: dump kernel log before carrying out fadump or kdump
Date:   Tue, 24 Sep 2019 12:48:42 -0400
Message-Id: <20190924164847.27780-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

[ Upstream commit e7ca44ed3ba77fc26cf32650bb71584896662474 ]

Since commit 4388c9b3a6ee ("powerpc: Do not send system reset request
through the oops path"), pstore dmesg file is not updated when dump is
triggered from HMC. This commit modified system reset (sreset) handler
to invoke fadump or kdump (if configured), without pushing dmesg to
pstore. This leaves pstore to have old dmesg data which won't be much
of a help if kdump fails to capture the dump. This patch fixes that by
calling kmsg_dump() before heading to fadump ot kdump.

Fixes: 4388c9b3a6ee ("powerpc: Do not send system reset request through the oops path")
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190904075949.15607-1-ganeshgr@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 02fe6d0201741..d5f351f02c153 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -399,6 +399,7 @@ void system_reset_exception(struct pt_regs *regs)
 	if (debugger(regs))
 		goto out;
 
+	kmsg_dump(KMSG_DUMP_OOPS);
 	/*
 	 * A system reset is a request to dump, so we always send
 	 * it through the crashdump code (if fadump or kdump are
-- 
2.20.1

