Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430541A5124
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgDKMSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgDKMSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:18:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED60F2084D;
        Sat, 11 Apr 2020 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607491;
        bh=7MBKtwa4tRHahvFw4Af19dmy1uXDFxo92bRC11xqOHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBWfZih4u/GjMK29e2xY2P6tOkfwarMuQvmu7bjh3SAdEBiZMQPo8+5dFqPx8OXkF
         WQoAcf8bD0UCcq2qUJceF1ra3Lw9H1i8tvTMUOfKPcMgn5P3C80payKojc+wNWJ/Z0
         m3PRh0mclVyNFfeKSIqoyqWmf4Dpegk0rdtrOdks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 34/41] RDMA/cma: Teach lockdep about the order of rtnl and lock
Date:   Sat, 11 Apr 2020 14:09:43 +0200
Message-Id: <20200411115506.552669509@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 32ac9e4399b12d3e54d312a0e0e30ed5cd19bd4e upstream.

This lock ordering only happens when bonding is enabled and a certain
bonding related event fires. However, since it can happen this is a global
restriction on lock ordering.

Teach lockdep about the order directly and unconditionally so bugs here
are found quickly.

See https://syzkaller.appspot.com/bug?extid=55de90ab5f44172b0c90

Link: https://lore.kernel.org/r/20200227203651.GA27185@ziepe.ca
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cma.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4719,6 +4719,19 @@ static int __init cma_init(void)
 {
 	int ret;
 
+	/*
+	 * There is a rare lock ordering dependency in cma_netdev_callback()
+	 * that only happens when bonding is enabled. Teach lockdep that rtnl
+	 * must never be nested under lock so it can find these without having
+	 * to test with bonding.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		rtnl_lock();
+		mutex_lock(&lock);
+		mutex_unlock(&lock);
+		rtnl_unlock();
+	}
+
 	cma_wq = alloc_ordered_workqueue("rdma_cm", WQ_MEM_RECLAIM);
 	if (!cma_wq)
 		return -ENOMEM;


