Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE24617FC35
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbgCJNTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731144AbgCJNIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:08:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6B62468D;
        Tue, 10 Mar 2020 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845723;
        bh=6AqqsHXYGqAUE4BJHdnz8k5K7Vjs2f2FFAtP7X9UB6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj+G5tmPa3JWvjECCTudmzm+Tm1kbFLH/+nGtyAntZ/gMnFiYM85IycY5HtaVGPjI
         qWEeGBDU7ik1yr+SrNq8MFA6eRctXXOFiC3jM4LINlqXdQzL7BKGFlq4vvk782KAjq
         YPwWDF907fiYQPEYE+D5V84ZcCFVSD0L0W9EWcKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/126] usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags
Date:   Tue, 10 Mar 2020 13:41:38 +0100
Message-Id: <20200310124208.872383450@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 43d565727a3a6fd24e37c7c2116475106af71806 ]

ffs_aio_cancel() can be called from both interrupt and thread context. Make
sure that the current IRQ state is saved and restored by using
spin_{un,}lock_irq{save,restore}().

Otherwise undefined behavior might occur.

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index cdffbe999500d..282396e8eec63 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1078,18 +1078,19 @@ static int ffs_aio_cancel(struct kiocb *kiocb)
 {
 	struct ffs_io_data *io_data = kiocb->private;
 	struct ffs_epfile *epfile = kiocb->ki_filp->private_data;
+	unsigned long flags;
 	int value;
 
 	ENTER();
 
-	spin_lock_irq(&epfile->ffs->eps_lock);
+	spin_lock_irqsave(&epfile->ffs->eps_lock, flags);
 
 	if (likely(io_data && io_data->ep && io_data->req))
 		value = usb_ep_dequeue(io_data->ep, io_data->req);
 	else
 		value = -EINVAL;
 
-	spin_unlock_irq(&epfile->ffs->eps_lock);
+	spin_unlock_irqrestore(&epfile->ffs->eps_lock, flags);
 
 	return value;
 }
-- 
2.20.1



