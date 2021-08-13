Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E713EB862
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242026AbhHMPNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241794AbhHMPMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7696610E9;
        Fri, 13 Aug 2021 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867516;
        bh=qK0EErnEjFtDJdXnL77QB1fl3iC0fYrgPfhRCOqU3GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOVJaItbLy8gXeSwAqSK1lhWE8imu9ZzbiOrH6c12eZk6KSGQm4sIuovkMrrFctqn
         YXWFW/90A4ZigAof9GbhbciIzyui2l/WORzDAtLwWst4hEXc2vR7nwXgdiIfEi3Kf0
         0zUaHMdX7CnlKki1cepc1Jz1q3+2efSR8BN7zQBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Pavel Machek (CIP)" <pavel@denx.de>
Subject: [PATCH 4.14 42/42] net: xilinx_emaclite: Do not print real IOMEM pointer
Date:   Fri, 13 Aug 2021 17:07:08 +0200
Message-Id: <20210813150526.500941002@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit d0d62baa7f505bd4c59cd169692ff07ec49dde37 upstream.

Printing kernel pointers is discouraged because they might leak kernel
memory layout.  This fixes smatch warning:

drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191 xemaclite_of_probe() warn:
 argument 4 to %08lX specifier is cast from pointer

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1165,9 +1165,8 @@ static int xemaclite_of_probe(struct pla
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=%d\n",
-		 (unsigned int __force)ndev->mem_start,
-		 (unsigned int __force)lp->base_addr, ndev->irq);
+		 "Xilinx EmacLite at 0x%08X mapped to 0x%p, irq=%d\n",
+		 (unsigned int __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
 error:


