Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE102D044B
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgLFLof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbgLFLob (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:44:31 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 28/46] cxgb3: fix error return code in t3_sge_alloc_qset()
Date:   Sun,  6 Dec 2020 12:17:36 +0100
Message-Id: <20201206111557.811653371@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit ff9924897f8bfed82e61894b373ab9d2dfea5b10 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b1fb1f280d09 ("cxgb3 - Fix dma mapping error path")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Raju Rangoju <rajur@chelsio.com>
Link: https://lore.kernel.org/r/1606902965-1646-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -3176,6 +3176,7 @@ int t3_sge_alloc_qset(struct adapter *ad
 			  GFP_KERNEL | __GFP_COMP);
 	if (!avail) {
 		CH_ALERT(adapter, "free list queue 0 initialization failed\n");
+		ret = -ENOMEM;
 		goto err;
 	}
 	if (avail < q->fl[0].size)


