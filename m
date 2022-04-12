Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CAE4FDA86
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240860AbiDLHiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353621AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4F326AC9;
        Tue, 12 Apr 2022 00:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E6560B2B;
        Tue, 12 Apr 2022 07:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486FEC385A1;
        Tue, 12 Apr 2022 07:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746929;
        bh=aYjbmozvRP0Y6GF6WshL6ZK6wocwCPdx4W6SMiYjpFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vefh3T0eCsi4DFO2EzqKiuguWO0wUnFoigSs2kuR9nHpx9HHqSFJCJtEZNAx05EBd
         HReVOND0b+6grqVDax+NEayXSf75ipik14g/ki5WtgW5MSXrF/BT7eR46Fz2X8ZCfP
         +Rb2ISTy3B5ZHhR9GhugP9lFm5FeLYBTRuCV7VOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 181/285] IB/cm: Cancel mad on the DREQ event when the state is MRA_REP_RCVD
Date:   Tue, 12 Apr 2022 08:30:38 +0200
Message-Id: <20220412062948.889424741@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 107dd7beba403a363adfeb3ffe3734fe38a05cce ]

On the passive side when the disconnectReq event comes, if the current
state is MRA_REP_RCVD, it needs to cancel the MAD before entering the
DREQ_RCVD and TIMEWAIT states, otherwise the destroy_id may block until
this mad will reach timeout.

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/75261c00c1d82128b1d981af9ff46e994186e621.1649062436.git.leonro@nvidia.com
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 35f0d5e7533d..1c107d6d03b9 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2824,6 +2824,7 @@ static int cm_dreq_handler(struct cm_work *work)
 	switch (cm_id_priv->id.state) {
 	case IB_CM_REP_SENT:
 	case IB_CM_DREQ_SENT:
+	case IB_CM_MRA_REP_RCVD:
 		ib_cancel_mad(cm_id_priv->msg);
 		break;
 	case IB_CM_ESTABLISHED:
@@ -2831,8 +2832,6 @@ static int cm_dreq_handler(struct cm_work *work)
 		    cm_id_priv->id.lap_state == IB_CM_MRA_LAP_RCVD)
 			ib_cancel_mad(cm_id_priv->msg);
 		break;
-	case IB_CM_MRA_REP_RCVD:
-		break;
 	case IB_CM_TIMEWAIT:
 		atomic_long_inc(&work->port->counters[CM_RECV_DUPLICATES]
 						     [CM_DREQ_COUNTER]);
-- 
2.35.1



