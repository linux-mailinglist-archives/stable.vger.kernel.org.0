Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447C04997FB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376945AbiAXVR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38556 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449430AbiAXVPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:15:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B57A61425;
        Mon, 24 Jan 2022 21:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620D0C340E4;
        Mon, 24 Jan 2022 21:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058933;
        bh=LQqVUSu1kkMBojTaP0fomJ/poZ8XZ9pus7ucI9OB5X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zi39S5m2cQmLfiRRHAxn3iAVwFaiJIXnRxHWwF3Lm9e/7qo+ukzNm1ExSGKt7DidL
         wqet9t1JQutt6osp3f9rw7biwthZa7MzlSUkxtKKPnGGhJwIhJR7I0K2roFjffIHzQ
         mr40cHgqg8UP7k6184Fu5CzywMGc3aRCz6Av0qCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0450/1039] RDMA/hns: Validate the pkey index
Date:   Mon, 24 Jan 2022 19:37:19 +0100
Message-Id: <20220124184140.421187760@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 4194b626f3c65..8233bec053ee3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -270,6 +270,9 @@ static enum rdma_link_layer hns_roce_get_link_layer(struct ib_device *device,
 static int hns_roce_query_pkey(struct ib_device *ib_dev, u32 port, u16 index,
 			       u16 *pkey)
 {
+	if (index > 0)
+		return -EINVAL;
+
 	*pkey = PKEY_ID;
 
 	return 0;
-- 
2.34.1



