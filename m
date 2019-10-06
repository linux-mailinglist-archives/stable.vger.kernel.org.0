Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C670BCD69A
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfJFRtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731310AbfJFRmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:42:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA4F20700;
        Sun,  6 Oct 2019 17:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383735;
        bh=jY3qVanxeRquDLEImQZu/x/re51v+SLrET3Sx0RMqiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7Q+RTVoDcXQ/5681YbGaAWsjYgklmtmQ9XYxkvJQa755xnVmU3UdRckAFIVaEoe6
         Wr1Z2Lgdw9H21+W0EOlS9UuKTv2FeqecZdkReEShqI7uWH7JfYx1dOhEtS+ddZK+mY
         /+IN9bAgmIgyzN0levKONw3qKDFOzcY8ANlFHZxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 075/166] powerpc: dump kernel log before carrying out fadump or kdump
Date:   Sun,  6 Oct 2019 19:20:41 +0200
Message-Id: <20191006171219.755665726@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 11caa0291254e..82f43535e6867 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -472,6 +472,7 @@ void system_reset_exception(struct pt_regs *regs)
 	if (debugger(regs))
 		goto out;
 
+	kmsg_dump(KMSG_DUMP_OOPS);
 	/*
 	 * A system reset is a request to dump, so we always send
 	 * it through the crashdump code (if fadump or kdump are
-- 
2.20.1



