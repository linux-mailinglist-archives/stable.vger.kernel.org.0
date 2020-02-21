Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2CB1674D5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbgBUIRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:17:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387686AbgBUIRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:17:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E41CC24690;
        Fri, 21 Feb 2020 08:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273058;
        bh=k+XzV/W9UPSf5JZG4LsaLccqrAu0LZ7Ag9WTLrAZBPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcS6FeJBSlFALfKaRw+P8iXX2pzOHKGN/TFRstCzvAeYhZQEmaRf66mHCTXBZVMrZ
         3vw5HRqW17ASQCjOTaZFkzrDRpqxA3hQn4no4g6FSGeZAAs0Z3uHAy9lnDDKN8VIqv
         iNBhV6GmYJ6lzSEwCLj4oKzAPD9GQix4tse794fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/191] uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()
Date:   Fri, 21 Feb 2020 08:40:04 +0100
Message-Id: <20200221072254.985632417@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit b74351287d4bd90636c3f48bc188c2f53824c2d4 ]

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

kernel/irq/manage.c, 523:
	synchronize_irq in disable_irq
drivers/uio/uio_dmem_genirq.c, 140:
	disable_irq in uio_dmem_genirq_irqcontrol
drivers/uio/uio_dmem_genirq.c, 134:
	_raw_spin_lock_irqsave in uio_dmem_genirq_irqcontrol

synchronize_irq() can sleep at runtime.

To fix this bug, disable_irq() is called without holding the spinlock.

This bug is found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20191218094405.6009-1-baijiaju1990@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_dmem_genirq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index e1134a4d97f3f..a00b4aee6c799 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -135,11 +135,13 @@ static int uio_dmem_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 	if (irq_on) {
 		if (test_and_clear_bit(0, &priv->flags))
 			enable_irq(dev_info->irq);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	} else {
-		if (!test_and_set_bit(0, &priv->flags))
+		if (!test_and_set_bit(0, &priv->flags)) {
+			spin_unlock_irqrestore(&priv->lock, flags);
 			disable_irq(dev_info->irq);
+		}
 	}
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
-- 
2.20.1



