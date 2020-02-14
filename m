Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A409D15EC6A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390893AbgBNQIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390887AbgBNQIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F712067D;
        Fri, 14 Feb 2020 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696494;
        bh=tRYepbfaD7Zd5Bn6ptVzfWced5IDJEWaxH48PkLZIew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2fKV6h4UNlT6IYgssJGz697jNmxKJwmlw4Znuv1paPsm4VIVEHAl1FiZntqkp8pp
         /3Df1+kjz2iWpx8WbjlCi0pQ3x1o0lv5PYB0NxR22cGUrBQLSw3Coo7g2AQfEr45r5
         wVMcUg2fFoKoRHmnGkJzMpQPoDSDlnK8vdUQDeQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 299/459] misc: xilinx_sdfec: fix xsdfec_poll()'s return type
Date:   Fri, 14 Feb 2020 10:59:09 -0500
Message-Id: <20200214160149.11681-299-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

[ Upstream commit fa4e7fc1386078edcfddd8848cb0374f4af74fe7 ]

xsdfec_poll() is defined as returning 'unsigned int' but the
.poll method is declared as returning '__poll_t', a bitwise type.

Fix this by using the proper return type and using the EPOLL
constants instead of the POLL ones, as required for __poll_t.

CC: Derek Kiernan <derek.kiernan@xilinx.com>
CC: Dragan Cvetic <dragan.cvetic@xilinx.com>
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Acked-by: Dragan Cvetic <dragan.cvetic@xilinx.com>
Link: https://lore.kernel.org/r/20191209213655.57985-1-luc.vanoostenryck@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/xilinx_sdfec.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/xilinx_sdfec.c b/drivers/misc/xilinx_sdfec.c
index 11835969e9828..48ba7e02bed72 100644
--- a/drivers/misc/xilinx_sdfec.c
+++ b/drivers/misc/xilinx_sdfec.c
@@ -1025,25 +1025,25 @@ static long xsdfec_dev_compat_ioctl(struct file *file, unsigned int cmd,
 }
 #endif
 
-static unsigned int xsdfec_poll(struct file *file, poll_table *wait)
+static __poll_t xsdfec_poll(struct file *file, poll_table *wait)
 {
-	unsigned int mask = 0;
+	__poll_t mask = 0;
 	struct xsdfec_dev *xsdfec;
 
 	xsdfec = container_of(file->private_data, struct xsdfec_dev, miscdev);
 
 	if (!xsdfec)
-		return POLLNVAL | POLLHUP;
+		return EPOLLNVAL | EPOLLHUP;
 
 	poll_wait(file, &xsdfec->waitq, wait);
 
 	/* XSDFEC ISR detected an error */
 	spin_lock_irqsave(&xsdfec->error_data_lock, xsdfec->flags);
 	if (xsdfec->state_updated)
-		mask |= POLLIN | POLLPRI;
+		mask |= EPOLLIN | EPOLLPRI;
 
 	if (xsdfec->stats_updated)
-		mask |= POLLIN | POLLRDNORM;
+		mask |= EPOLLIN | EPOLLRDNORM;
 	spin_unlock_irqrestore(&xsdfec->error_data_lock, xsdfec->flags);
 
 	return mask;
-- 
2.20.1

