Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A030B65817A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiL1Q2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiL1Q22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892F61274D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27A1661578
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC1FC433EF;
        Wed, 28 Dec 2022 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244673;
        bh=KYln1IfS+PW5NEG6uTXuN86LmKJIubLx/HBmW7ITGIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIpDYUV7JhRadNqYbShR6yXqHvUvcinEjwApOYIhZ/Iy0TJmZmxM82UuX4lJFkjm0
         upJWvuW0IWEiQJGrNOuD3I3SdJOPT7D8RYnB4I4oyQ/Y7XSjBZ0ierRQ41gXDZhNbw
         HVneWyHesymRpYm7jMSrmsfVjRioMAsuFcEfeLxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chengchang Tang <tangchengchang@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0676/1146] RDMA/hns: Fix XRC caps on HIP08
Date:   Wed, 28 Dec 2022 15:36:55 +0100
Message-Id: <20221228144348.508400473@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 682c0722addae4b4a1440c9db9d8c86cb8e09ce5 ]

XRC caps has been set by default. But in fact, XRC is not supported in
HIP08.

Fixes: 32548870d438 ("RDMA/hns: Add support for XRC on HIP09")
Link: https://lore.kernel.org/r/20221126102911.2921820-7-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d21c23bcc0de..b2421883993b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2047,13 +2047,14 @@ static void set_default_caps(struct hns_roce_dev *hr_dev)
 
 	caps->flags |= HNS_ROCE_CAP_FLAG_ATOMIC | HNS_ROCE_CAP_FLAG_MW |
 		       HNS_ROCE_CAP_FLAG_SRQ | HNS_ROCE_CAP_FLAG_FRMR |
-		       HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL | HNS_ROCE_CAP_FLAG_XRC;
+		       HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL;
 
 	caps->gid_table_len[0] = HNS_ROCE_V2_GID_INDEX_NUM;
 
 	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09) {
 		caps->flags |= HNS_ROCE_CAP_FLAG_STASH |
-			       HNS_ROCE_CAP_FLAG_DIRECT_WQE;
+			       HNS_ROCE_CAP_FLAG_DIRECT_WQE |
+			       HNS_ROCE_CAP_FLAG_XRC;
 		caps->max_sq_inline = HNS_ROCE_V3_MAX_SQ_INLINE;
 	} else {
 		caps->max_sq_inline = HNS_ROCE_V2_MAX_SQ_INLINE;
-- 
2.35.1



