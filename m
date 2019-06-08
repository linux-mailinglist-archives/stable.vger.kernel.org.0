Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8000A39EA2
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfFHLsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbfFHLsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:48:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA0F216C4;
        Sat,  8 Jun 2019 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994520;
        bh=IXbct3bspONpxewjZzg7hXQB9AgWCFTmqbOriZCheX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hskZwvPROLHZm61AFBaXEwZzHqpK5Dr++/BImLkbWkp/w2ByplitTGB327/r/t0Ir
         /7m3qlAK463WbqtPVHAj4wnW/+h1arUR0YVlMhPtbFWFllLpfFNdYPwhZnokLikUEl
         7gADSZtEinDM7fIzK8NnTUH3R1mNEI+WUBitVexY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/20] scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()
Date:   Sat,  8 Jun 2019 07:47:53 -0400
Message-Id: <20190608114756.9742-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114756.9742-1-sashal@kernel.org>
References: <20190608114756.9742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit cc555759117e8349088e0c5d19f2f2a500bafdbd ]

ip_dev_find() can return NULL so add a check for NULL pointer.

Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/cxgbi/libcxgbi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 2ffe029ff2b6..e974106f2bb5 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -637,6 +637,10 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 
 	if (ndev->flags & IFF_LOOPBACK) {
 		ndev = ip_dev_find(&init_net, daddr->sin_addr.s_addr);
+		if (!ndev) {
+			err = -ENETUNREACH;
+			goto rel_neigh;
+		}
 		mtu = ndev->mtu;
 		pr_info("rt dev %s, loopback -> %s, mtu %u.\n",
 			n->dev->name, ndev->name, mtu);
-- 
2.20.1

