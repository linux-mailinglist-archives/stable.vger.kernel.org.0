Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F4514B980
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgA1OZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733098AbgA1OZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D18420716;
        Tue, 28 Jan 2020 14:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221555;
        bh=+87kAnNydczXb7BW97pURPntkWjZgoBlJtHDxJHMwDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0U63r2YWqhsOv9jdm1g8d0I/jQEsCN7Z/Wlh7FXFa96/lOVgV94N/1kGBFjOMeHrr
         gD68W8c61YEu5q7ZJuqqwQXNT8TTFb/1CMbgCVXYTNtmdobXfPv4QWMAS86OcoLiNv
         ZC/CnufwU6RVRUMs/JCFsdr4D4DWZXPdDKVgbYuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 235/271] firestream: fix memory leaks
Date:   Tue, 28 Jan 2020 15:06:24 +0100
Message-Id: <20200128135910.049750526@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit fa865ba183d61c1ec8cbcab8573159c3b72b89a4 ]

In fs_open(), 'vcc' is allocated through kmalloc() and assigned to
'atm_vcc->dev_data.' In the following execution, if an error occurs, e.g.,
there is no more free channel, an error code EBUSY or ENOMEM will be
returned. However, 'vcc' is not deallocated, leading to memory leaks. Note
that, in normal cases where fs_open() returns 0, 'vcc' will be deallocated
in fs_close(). But, if fs_open() fails, there is no guarantee that
fs_close() will be invoked.

To fix this issue, deallocate 'vcc' before the error code is returned.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/firestream.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -927,6 +927,7 @@ static int fs_open(struct atm_vcc *atm_v
 			}
 			if (!to) {
 				printk ("No more free channels for FS50..\n");
+				kfree(vcc);
 				return -EBUSY;
 			}
 			vcc->channo = dev->channo;
@@ -937,6 +938,7 @@ static int fs_open(struct atm_vcc *atm_v
 			if (((DO_DIRECTION(rxtp) && dev->atm_vccs[vcc->channo])) ||
 			    ( DO_DIRECTION(txtp) && test_bit (vcc->channo, dev->tx_inuse))) {
 				printk ("Channel is in use for FS155.\n");
+				kfree(vcc);
 				return -EBUSY;
 			}
 		}
@@ -950,6 +952,7 @@ static int fs_open(struct atm_vcc *atm_v
 			    tc, sizeof (struct fs_transmit_config));
 		if (!tc) {
 			fs_dprintk (FS_DEBUG_OPEN, "fs: can't alloc transmit_config.\n");
+			kfree(vcc);
 			return -ENOMEM;
 		}
 


