Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE504D728
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfFTSQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfFTSQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9678A2082C;
        Thu, 20 Jun 2019 18:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054609;
        bh=1WumT4QNTrBGXyIr87jAvTLP3RZS4pMvvwTqIzB615I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpF8X8N9bZG6QESixh11rpSk2k3E4OT/LQnGTJb+JwGRlcqLV6i6ur1MwJVy3R9Oz
         CE/meGXGVP6nWg9Wvtd1e4BquDUqR3uiPVGK14lLA+CLXl1x/sjXzoxqgUtgjoRupZ
         r15gRuPmx01PpKpKZDv6Wd78Ad1LY/LJvgQKpEQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 88/98] scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()
Date:   Thu, 20 Jun 2019 19:57:55 +0200
Message-Id: <20190620174353.779238128@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cc555759117e8349088e0c5d19f2f2a500bafdbd ]

ip_dev_find() can return NULL so add a check for NULL pointer.

Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/cxgbi/libcxgbi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 006372b3fba2..a50734f3c486 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -641,6 +641,10 @@ cxgbi_check_route(struct sockaddr *dst_addr, int ifindex)
 
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



