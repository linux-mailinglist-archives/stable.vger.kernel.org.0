Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707C6FEDAD
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfKPPqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:46:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfKPPqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:06 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A8020862;
        Sat, 16 Nov 2019 15:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919165;
        bh=O+KNYKwrYXlnpwO1GIlUFnzRl1BQrKkUD6M9YTg3B08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Er3rUtXv+Y1+XVmsvMFWTRe8OvQAb1eVO1C/ofNlm6zPc57NcnCahrIT2VnKjkW1t
         MpANyNsjwesOQFZBMNWrTFn0CnNJHtZjax7qrsFcWXaImyattNF/IND4OuDiCSNw3t
         yKG97VIioXgxWN2nVz970L3JbLmRh3kYIi3s6o/s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        KY Srinivasan <kys@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 174/237] irq/matrix: Fix memory overallocation
Date:   Sat, 16 Nov 2019 10:40:09 -0500
Message-Id: <20191116154113.7417-174-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 57f01796f14fecf00d330fe39c8d2477ced9cd79 ]

IRQ_MATRIX_SIZE is the number of longs needed for a bitmap, multiplied by
the size of a long, yielding a byte count. But it is used to size an array
of longs, which is way more memory than is needed.

Change IRQ_MATRIX_SIZE so it is just the number of longs needed and the
arrays come out the correct size.

Fixes: 2f75d9e1c905 ("genirq: Implement bitmap matrix allocator")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: KY Srinivasan <kys@microsoft.com>
Link: https://lkml.kernel.org/r/1541032428-10392-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/matrix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/matrix.c b/kernel/irq/matrix.c
index 92337703ca9fd..30cc217b86318 100644
--- a/kernel/irq/matrix.c
+++ b/kernel/irq/matrix.c
@@ -8,7 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/irq.h>
 
-#define IRQ_MATRIX_SIZE	(BITS_TO_LONGS(IRQ_MATRIX_BITS) * sizeof(unsigned long))
+#define IRQ_MATRIX_SIZE	(BITS_TO_LONGS(IRQ_MATRIX_BITS))
 
 struct cpumap {
 	unsigned int		available;
-- 
2.20.1

