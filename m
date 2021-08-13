Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7D73EB822
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241237AbhHMPLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241525AbhHMPKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A97296113C;
        Fri, 13 Aug 2021 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867420;
        bh=W0/MYBaEexdC/3wudle8jYPltHR7NjtUMaUCvF7h3s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQKnszxvfwNPpm1po/jcWRlt7mTz7Wk2eEdZxkdoA2Pp33GAr6iVCJm1/LtdYgD2o
         Atnmq7MGu/i7b/nB8R//VL7NeW6ZMhuMALjNQopDHfyBRyExBy2SS2RFiFi6dA2wan
         JmosrG56169KFSasu67NSovCRVhq/r357wLaxQSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Pavel Machek (CIP)" <pavel@denx.de>
Subject: [PATCH 4.9 29/30] net: xilinx_emaclite: Do not print real IOMEM pointer
Date:   Fri, 13 Aug 2021 17:06:57 +0200
Message-Id: <20210813150523.386748331@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
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
@@ -1179,9 +1179,8 @@ static int xemaclite_of_probe(struct pla
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=%d\n",
-		 (unsigned int __force)ndev->mem_start,
-		 (unsigned int __force)lp->base_addr, ndev->irq);
+		 "Xilinx EmacLite at 0x%08X mapped to 0x%p, irq=%d\n",
+		 (unsigned int __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
 error:


