Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B134498EF5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357268AbiAXTtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349667AbiAXThT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:37:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB4EC03400B;
        Mon, 24 Jan 2022 11:17:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C0AB8121A;
        Mon, 24 Jan 2022 19:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D898C340E5;
        Mon, 24 Jan 2022 19:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051838;
        bh=Qv3iaepdUWUPB8G3RKHiXJh6nOrf8T5JCWPTQVoXFDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsb1bnPW53q9csd4VzVtWuff//depYjG/LkiqmV7AtMFAm56cZ5yj9zLr7ZlZVwAW
         +I0e3t/8G4peXWl9XPKVpyAmrN7dQQAWJ6D9JBKivbPBTNRN8JtJivhOhC56ocQzpo
         BsUT6lRurOVONtwU+VwdOAUmvinkD/di2eB73A+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/239] RDMA/hns: Validate the pkey index
Date:   Mon, 24 Jan 2022 19:42:20 +0100
Message-Id: <20220124183946.346995735@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index c5cae9a38c044..5e60a2596d2bf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -295,6 +295,9 @@ static enum rdma_link_layer hns_roce_get_link_layer(struct ib_device *device,
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



