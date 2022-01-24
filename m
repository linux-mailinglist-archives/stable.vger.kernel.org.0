Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F20F498B00
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiAXTJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:09:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345296AbiAXTG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:06:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C25AC612F1;
        Mon, 24 Jan 2022 19:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86381C340E5;
        Mon, 24 Jan 2022 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051210;
        bh=NA/mU0i1Vi+X8zp/d7ZDj3kHh2fK5QZ3ovBPxx+vMWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DADAexnBAkyo1FwAdbGDi3BPNssuAt3vvzezydzDng8/CBMfnzjnkJmORgKQZtYpX
         TpkgqOntflQ7KAf2JvMRYpZTcTkXCsqL5zEVul6/gu5MNVZFUJIBCDAY7PpwNVXonM
         iLNsP4KHPFWZcQEScccq10fUxOyaikjvNuG7+lrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 072/186] RDMA/hns: Validate the pkey index
Date:   Mon, 24 Jan 2022 19:42:27 +0100
Message-Id: <20220124183939.441587144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 2a67fcfa0db6b4075515bd23497750849b88850f ]

Before query pkey, make sure that the queried index is valid.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://lore.kernel.org/r/20211117145954.123893-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index d9777b662eba9..6f64dc5262c0d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -294,6 +294,9 @@ static int hns_roce_query_gid(struct ib_device *ib_dev, u8 port_num, int index,
 static int hns_roce_query_pkey(struct ib_device *ib_dev, u8 port, u16 index,
 			       u16 *pkey)
 {
+	if (index > 0)
+		return -EINVAL;
+
 	*pkey = PKEY_ID;
 
 	return 0;
-- 
2.34.1



