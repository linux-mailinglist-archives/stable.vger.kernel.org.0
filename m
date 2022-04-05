Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B61C4F37BD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359486AbiDELT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349165AbiDEJtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEFB64CC;
        Tue,  5 Apr 2022 02:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD357CE1C99;
        Tue,  5 Apr 2022 09:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E36C385A2;
        Tue,  5 Apr 2022 09:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151714;
        bh=68lRu9Iwrr+Nxnuvq2RnpXFUx1MpHDRgecROVpoboCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGKP+lB5w5n7cmz1ZKYelxqhXLre0bPjv3onlIanLfBeMZc/wkCulMZX4W5/KLN7s
         9sXqRZM49osGctuSYIXvrDqLTQPsFVoOe5yk9orKOG6o6CB+1ppjFDydFFHPpyhv6/
         DGQSNaChgEdVkCyMJMDelHx/ntfjckuaPGnsdCXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 515/913] IB/hfi1: Allow larger MTU without AIP
Date:   Tue,  5 Apr 2022 09:26:17 +0200
Message-Id: <20220405070355.290973807@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

[ Upstream commit b135e324d7a2e7fa0a7ef925076136e799b79f44 ]

The AIP code signals the phys_mtu in the following query_port()
fragment:

	props->phys_mtu = HFI1_CAP_IS_KSET(AIP) ? hfi1_max_mtu :
				ib_mtu_enum_to_int(props->max_mtu);

Using the largest MTU possible should not depend on AIP.

Fix by unconditionally using the hfi1_max_mtu value.

Fixes: 6d72344cf6c4 ("IB/ipoib: Increase ipoib Datagram mode MTU's upper limit")
Link: https://lore.kernel.org/r/1644348309-174874-1-git-send-email-mike.marciniszyn@cornelisnetworks.com
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/verbs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 26bea51869bf..ef8e0bdacb51 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1397,8 +1397,7 @@ static int query_port(struct rvt_dev_info *rdi, u32 port_num,
 				      4096 : hfi1_max_mtu), IB_MTU_4096);
 	props->active_mtu = !valid_ib_mtu(ppd->ibmtu) ? props->max_mtu :
 		mtu_to_enum(ppd->ibmtu, IB_MTU_4096);
-	props->phys_mtu = HFI1_CAP_IS_KSET(AIP) ? hfi1_max_mtu :
-				ib_mtu_enum_to_int(props->max_mtu);
+	props->phys_mtu = hfi1_max_mtu;
 
 	return 0;
 }
-- 
2.34.1



