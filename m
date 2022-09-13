Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3115B7054
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiIMOZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiIMOYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E2766A57;
        Tue, 13 Sep 2022 07:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8357F614AD;
        Tue, 13 Sep 2022 14:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E79FC433C1;
        Tue, 13 Sep 2022 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078445;
        bh=oMdR6fleoTcB3lRFIFbPjsKB3wUScb4uJrTinMkw7Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrrdJDQVFGgi0HsxoAEbyn6KbwlaAFsYApn7YIOdMAHk+7GgWaZgj0t88l0Kml1CO
         0QZnrgz0x0CoxQ5D2k76hwHecBAK34L3UT3XqPFmb644KC4NZHB06Q/MfK7pOspuVR
         TCVmvb1iGHT/V66q0aXQWBYB5owDP/JbfpD0+wZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu-Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 143/192] RDMA/irdma: Report RNR NAK generation in device caps
Date:   Tue, 13 Sep 2022 16:04:09 +0200
Message-Id: <20220913140417.144794875@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sindhu-Devale <sindhu.devale@intel.com>

[ Upstream commit a261786fdc0a5bed2e5f994dcc0ffeeeb0d662c7 ]

Report RNR NAK generation when device capabilities are queried

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Sindhu-Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20220906223244.1119-6-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index e7120d7a5b4c6..ab73d1715f991 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -46,8 +46,11 @@ static int irdma_query_device(struct ib_device *ibdev,
 	props->max_sge_rd = hw_attrs->uk_attrs.max_hw_read_sges;
 	props->max_qp_rd_atom = hw_attrs->max_hw_ird;
 	props->max_qp_init_rd_atom = hw_attrs->max_hw_ord;
-	if (rdma_protocol_roce(ibdev, 1))
+	if (rdma_protocol_roce(ibdev, 1)) {
+		props->device_cap_flags |= IB_DEVICE_RC_RNR_NAK_GEN;
 		props->max_pkeys = IRDMA_PKEY_TBL_SZ;
+	}
+
 	props->max_ah = rf->max_ah;
 	props->max_mcast_grp = rf->max_mcg;
 	props->max_mcast_qp_attach = IRDMA_MAX_MGS_PER_CTX;
-- 
2.35.1



