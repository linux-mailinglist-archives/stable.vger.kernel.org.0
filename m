Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3B3F49FF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbfKHMGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732640AbfKHLlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93E6C21D82;
        Fri,  8 Nov 2019 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213266;
        bh=ck4CGIvRI4Ex6oKJ5MyM06UeyLateRM5qeCi7pibI/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjsPKMjB5UEtlrRohHcuLAFvqwpPHKzBrlRBzV2x7dPebhtwysGfHr6IN+jHsDH1O
         Rzp2KzRQQmQumosUVd1ti3N6Kg4IP5M2fnYNey1e2EL+zl1Vp3psusQZS981IE1sKB
         zfF7vZwLsj9H33gE8GT3ZpX1QN3Kjvxnaf+xbX58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 130/205] IB/hfi1: Missing return value in error path for user sdma
Date:   Fri,  8 Nov 2019 06:36:37 -0500
Message-Id: <20191108113752.12502-130-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
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
index cbff746d9e9de..684a298e15037 100644
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

