Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC24F48A6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390885AbfKHLop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390859AbfKHLom (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFEFF222CF;
        Fri,  8 Nov 2019 11:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213481;
        bh=2r/7d/Sc8DThkpnLSjdpMTmBLQ8df60SDATgIW/Q+m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnwKsLti07kcCiB6ocV4pYNJxPLEzRw6Zq7TuCTPTM6eNoJRuxKNnl7zkjC6Qnmam
         QgaZnqeMAeVWhVvffGsXyssU2ndSwFvk78vq6nBa63Rl5Mdw+6k20B+qYUi371uLRO
         FS/K8oFoDRXj0+id4edgFJqrt0+dkavNfGV8afNw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 063/103] IB/hfi1: Missing return value in error path for user sdma
Date:   Fri,  8 Nov 2019 06:42:28 -0500
Message-Id: <20191108114310.14363-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael J. Ruhl" <michael.j.ruhl@intel.com>

[ Upstream commit 2bf4b33f83dfe521c4c7c407b6b150aeec04d69c ]

If the set_txreq_header_agh() function returns an error, the exit path
is chosen.

In this path, the code fails to set the return value.  This will cause
the caller to not realize an error has occurred.

Set the return value correctly in the error path.

Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 75275f9e363de..4854a4a453b5f 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -856,8 +856,10 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 
 				changes = set_txreq_header_ahg(req, tx,
 							       datalen);
-				if (changes < 0)
+				if (changes < 0) {
+					ret = changes;
 					goto free_tx;
+				}
 			}
 		} else {
 			ret = sdma_txinit(&tx->txreq, 0, sizeof(req->hdr) +
-- 
2.20.1

