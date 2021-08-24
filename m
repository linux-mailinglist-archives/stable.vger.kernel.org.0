Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436F53F63E0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbhHXQ6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234757AbhHXQ55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB0B61465;
        Tue, 24 Aug 2021 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824222;
        bh=pfpt5pINwBubUuYsLHG4/nz5ZSTF5rZDrtrmJ8wmaE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg65MJGb8C3yqK4kvKWhSaOMM7nHQhGnrL3KBYt1YkIUjZig/glawsGa73UEJssWU
         n7FJqQvJIYBgELfSiQenloCUba8G4q/xkmDSWbOpBgKb5n53r9l3KyRIsU7BuFdw5K
         MsTnx2n2p/bbMhvu3du9pU9Sje3UzgSyof7w8Q9b8bgU68WDzWLfBMMu8M9U+CLApf
         YiWBOkeALJGTBgZivimSJnzKFc84WlKftQoKPoqCFSWdisLMwbHmNblnDaLg2q3N0Q
         dxkjZDH8FwOy2ZOBU/hFJMXc+e6Xe3dhU2TW/F7HA2vzCuJZMA53XnGEafeh2VdDvS
         Iw3wfFylA8+xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 055/127] soc: fsl: qe: fix static checker warning
Date:   Tue, 24 Aug 2021 12:54:55 -0400
Message-Id: <20210824165607.709387-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit c1e64c0aec8cb0499e61af7ea086b59abba97945 ]

The patch be7ecbd240b2: "soc: fsl: qe: convert QE interrupt
controller to platform_device" from Aug 3, 2021, leads to the
following static checker warning:

	drivers/soc/fsl/qe/qe_ic.c:438 qe_ic_init()
	warn: unsigned 'qe_ic->virq_low' is never less than zero.

In old variant irq_of_parse_and_map() returns zero if failed so
unsigned int for virq_high/virq_low was ok.
In new variant platform_get_irq() returns negative error codes
if failed so we need to use int for virq_high/virq_low.

Also simplify high_handler checking and remove the curly braces
to make checkpatch happy.

Fixes: be7ecbd240b2 ("soc: fsl: qe: convert QE interrupt controller to platform_device")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qe_ic.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/soc/fsl/qe/qe_ic.c b/drivers/soc/fsl/qe/qe_ic.c
index e710d554425d..bbae3d39c7be 100644
--- a/drivers/soc/fsl/qe/qe_ic.c
+++ b/drivers/soc/fsl/qe/qe_ic.c
@@ -54,8 +54,8 @@ struct qe_ic {
 	struct irq_chip hc_irq;
 
 	/* VIRQ numbers of QE high/low irqs */
-	unsigned int virq_high;
-	unsigned int virq_low;
+	int virq_high;
+	int virq_low;
 };
 
 /*
@@ -435,11 +435,10 @@ static int qe_ic_init(struct platform_device *pdev)
 	qe_ic->virq_high = platform_get_irq(pdev, 0);
 	qe_ic->virq_low = platform_get_irq(pdev, 1);
 
-	if (qe_ic->virq_low < 0) {
+	if (qe_ic->virq_low <= 0)
 		return -ENODEV;
-	}
 
-	if (qe_ic->virq_high != qe_ic->virq_low) {
+	if (qe_ic->virq_high > 0 && qe_ic->virq_high != qe_ic->virq_low) {
 		low_handler = qe_ic_cascade_low;
 		high_handler = qe_ic_cascade_high;
 	} else {
@@ -459,7 +458,7 @@ static int qe_ic_init(struct platform_device *pdev)
 	irq_set_handler_data(qe_ic->virq_low, qe_ic);
 	irq_set_chained_handler(qe_ic->virq_low, low_handler);
 
-	if (qe_ic->virq_high && qe_ic->virq_high != qe_ic->virq_low) {
+	if (high_handler) {
 		irq_set_handler_data(qe_ic->virq_high, qe_ic);
 		irq_set_chained_handler(qe_ic->virq_high, high_handler);
 	}
-- 
2.30.2

