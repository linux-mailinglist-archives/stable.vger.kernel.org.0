Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9E44989E7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344569AbiAXS7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:59:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55094 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343556AbiAXS5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:57:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ECABB810BD;
        Mon, 24 Jan 2022 18:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A7CC340E5;
        Mon, 24 Jan 2022 18:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050619;
        bh=y+we92SPknJm552z1ppO/DVAZMNczlZ+j1Y2CQ3lDoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nimoex8BIwEfsQnunmPmLnzSOVi28qVo/5So+MpIlgQX2iPA71RlyA1ZccouNY+uy
         lpZo7EWzL41wQEQz6sZLWlewpHEw3Y0OHt3QIf3tmsy+IVD+CtZA/X2vAQmVgiFV1h
         miEIyechZ5zuVGBN6CTCrb4ylQ4MykHweoAqIpLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/157] RDMA/hns: Validate the pkey index
Date:   Mon, 24 Jan 2022 19:42:30 +0100
Message-Id: <20220124183934.685563589@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
index 764e35a54457e..852aac146ac78 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -475,6 +475,9 @@ static int hns_roce_query_gid(struct ib_device *ib_dev, u8 port_num, int index,
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



