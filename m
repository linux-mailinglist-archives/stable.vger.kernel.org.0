Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376F92C0A1C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbgKWNQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733020AbgKWMnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB41220732;
        Mon, 23 Nov 2020 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135388;
        bh=cVpjNbz8zZDR26SVSIFRkEJ5oyDlXtq8hkyp6SIjrzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbPR2CdZUP9wKLxLpUkSBPmaSod41y58ll/oCqGqm+ZxP5sKrxWulohDOJpkeTsuN
         2SK3lHxbuGU0WfJyASVCgkXPOWIF00E6ifhY5vVgkCxHU94WGQyZo5vTZT0yWC0VS+
         Hnf/+JWJbiYZZr6H/IgP7AfssA2CrYmIK7OZIiDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 020/252] net: ethernet: ti: cpsw: fix error return code in cpsw_probe()
Date:   Mon, 23 Nov 2020 13:19:30 +0100
Message-Id: <20201123121836.571058858@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 35f735c665114840dcd3142f41148d07870f51f7 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1605250173-18438-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1640,6 +1640,7 @@ static int cpsw_probe(struct platform_de
 				       CPSW_MAX_QUEUES, CPSW_MAX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "error allocating net_device\n");
+		ret = -ENOMEM;
 		goto clean_cpts;
 	}
 


