Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A23847FE64
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbhL0P2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33752 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237504AbhL0P2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B7EFB810BF;
        Mon, 27 Dec 2021 15:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B482CC36AEA;
        Mon, 27 Dec 2021 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618903;
        bh=ix8imNCcD1Wunb0dhYB2I7HHFk4LgeZ2sejso5qcCoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Up5Q+pKsMJwlvc7E5WzRBSSLVYL7zRK0lEHxKy1Ug/YuE4TNoQnTQ+XzoPADHnlu5
         YfG6Yi/1RA2CND6XD3n8RV9Wxy7kSGsTR6DkaPyKwRvI1PTObKHZT0kS0riCHDkhTG
         WXud/8+/IaC/SkbHd0Siz6yjia6Xy3QSbES6jLBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/19] IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()
Date:   Mon, 27 Dec 2021 16:27:06 +0100
Message-Id: <20211227151316.699119964@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
References: <20211227151316.558965545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit bee90911e0138c76ee67458ac0d58b38a3190f65 ]

The wrong goto label was used for the error case and missed cleanup of the
pkt allocation.

Fixes: d39bf40e55e6 ("IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields")
Link: https://lore.kernel.org/r/20211208175238.29983-1-jose.exposito89@gmail.com
Addresses-Coverity-ID: 1493352 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Acked-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 0dc15f95e7626..2d0b992579d6f 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -946,7 +946,7 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 					       &addrlimit) ||
 			    addrlimit > type_max(typeof(pkt->addrlimit))) {
 				ret = -EINVAL;
-				goto free_pbc;
+				goto free_pkt;
 			}
 			pkt->addrlimit = addrlimit;
 
-- 
2.34.1



