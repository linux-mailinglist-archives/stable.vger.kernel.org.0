Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361A6658090
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbiL1QSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiL1QRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0395B12A8E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6467B81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C33EC433EF;
        Wed, 28 Dec 2022 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244181;
        bh=sBVBxC3idSlA6Fa2PoZPiNDNc5jGQgjGW2Vq+uhcgFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKENE7vrdvjrNGvITBy5NfQqzB5csTjKvG0Id4EEyiPM6O8d6JtZqcmD1Myy/0iCw
         +EDzb2O/Bidos1SftG9ivjSa4S79/BVu2quuQ6gm4gA+amUSW2sHh6fi0bNpXsC5QN
         1k7MFB2o0YMokiMKJonVkdWceuw9Dwe7m+k3MJqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0625/1146] RDMA/irdma: Initialize net_type before checking it
Date:   Wed, 28 Dec 2022 15:36:04 +0100
Message-Id: <20221228144347.144626676@linuxfoundation.org>
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 9907526d25c4ad8a6e3006487a544140776ba005 ]

The av->net_type is not initialized before it is checked in
irdma_modify_qp_roce. This leads to an incorrect update to the ARP cache
and QP context. RoCEv2 connections might fail as result.

Set the net_type using rdma_gid_attr_network_type.

Fixes: 80005c43d4c8 ("RDMA/irdma: Use net_type to check network type")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20221122004410.1471-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index dc3f5f3fee90..f6973ea55eda 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1213,6 +1213,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		av->attrs = attr->ah_attr;
 		rdma_gid2ip((struct sockaddr *)&av->sgid_addr, &sgid_attr->gid);
 		rdma_gid2ip((struct sockaddr *)&av->dgid_addr, &attr->ah_attr.grh.dgid);
+		av->net_type = rdma_gid_attr_network_type(sgid_attr);
 		if (av->net_type == RDMA_NETWORK_IPV6) {
 			__be32 *daddr =
 				av->dgid_addr.saddr_in6.sin6_addr.in6_u.u6_addr32;
-- 
2.35.1



