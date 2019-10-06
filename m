Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548B5CD7A4
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfJFRcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfJFRck (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:32:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CB921479;
        Sun,  6 Oct 2019 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383159;
        bh=PbjHPtewCYuO2ym+Rrsh9hU7Np/igd+boOrZGN37D88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ay+MiMOHj8+rFjYdThQX0NjH2OldU650YaxtvbZhnPCQvAoyafo0lftsZLFLNAt+S
         0NJkU0a1iDTmuDRBjqqZaJrGMKW9/xlbTCT0UpZvzB89luj950oo18j9jejiBlTl9h
         MO6cToO2sU6nBrbSEvZUfiMnvKLPwQNuajMZnWno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 086/106] net: qlogic: Fix memory leak in ql_alloc_large_buffers
Date:   Sun,  6 Oct 2019 19:21:32 +0200
Message-Id: <20191006171158.942942590@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 1acb8f2a7a9f10543868ddd737e37424d5c36cf4 ]

In ql_alloc_large_buffers, a new skb is allocated via netdev_alloc_skb.
This skb should be released if pci_dma_mapping_error fails.

Fixes: 0f8ab89e825f ("qla3xxx: Check return code from pci_map_single() in ql_release_to_lrg_buf_free_list(), ql_populate_free_queue(), ql_alloc_large_buffers(), and ql3xxx_send()")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2788,6 +2788,7 @@ static int ql_alloc_large_buffers(struct
 				netdev_err(qdev->ndev,
 					   "PCI mapping failed with error: %d\n",
 					   err);
+				dev_kfree_skb_irq(skb);
 				ql_free_large_buffers(qdev);
 				return -ENOMEM;
 			}


