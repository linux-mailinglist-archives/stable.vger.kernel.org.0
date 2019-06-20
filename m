Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79214D7AE
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfFTSJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbfFTSJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:09:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E59E2070B;
        Thu, 20 Jun 2019 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054147;
        bh=3D4Kpx+QNbthar338sCX16nHAl5MKv+8BJWRznGhCFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+8xyHnRN6atXPpueQU4glNue9vsIS7QzShu5WPYhCxWzkPETT8zHPV4NIuUDAIl4
         wvlPW8xqNSoXWsrqa49E4/GsoaHONvdMd9F0WPb0NtFlKQumoA5dEnTylQ5agU/wJw
         7bK4DWQrarzamKHkJNRyty7EwogjyQrNkCwyZ/EE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/45] scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()
Date:   Thu, 20 Jun 2019 19:57:37 +0200
Message-Id: <20190620174339.732810922@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
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
index 512c8f1ea5b0..902f5e03ec94 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -640,6 +640,10 @@ cxgbi_check_route(struct sockaddr *dst_addr, int ifindex)
 
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



