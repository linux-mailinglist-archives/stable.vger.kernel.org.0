Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2994FDA09
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377257AbiDLHtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358235AbiDLHlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CB742A36;
        Tue, 12 Apr 2022 00:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B8CF616E7;
        Tue, 12 Apr 2022 07:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83AC385A1;
        Tue, 12 Apr 2022 07:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747857;
        bh=r8a9lHuAGZPUTvvW+D5b/UG4FvvagGtzxKifdNP/HL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWygdz0vvz1npoX1TJeYV4XXQBjxIt0zelLZDfGBzO0bSFztYMtG3cLZN3Pv7S2pI
         aiuOQ1kjSfX0P1zdW4Kusb76ZpXKm84YAFYWPiwqCa3srrp31bULerxTIMC5jIaYzd
         VdUPyPhKk/MeiXdM9Bw9oemCyMxX3SZt0gu/JpwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 230/343] IB/rdmavt: add lock to call to rvt_error_qp to prevent a race condition
Date:   Tue, 12 Apr 2022 08:30:48 +0200
Message-Id: <20220412062957.976208346@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 4d809f69695d4e7d1378b3a072fa9aef23123018 ]

The documentation of the function rvt_error_qp says both r_lock and s_lock
need to be held when calling that function.  It also asserts using lockdep
that both of those locks are held.  However, the commit I referenced in
Fixes accidentally makes the call to rvt_error_qp in rvt_ruc_loopback no
longer covered by r_lock.  This results in the lockdep assertion failing
and also possibly in a race condition.

Fixes: d757c60eca9b ("IB/rdmavt: Fix concurrency panics in QP post_send and modify to error")
Link: https://lore.kernel.org/r/20220228165330.41546-1-dossche.niels@gmail.com
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index ae50b56e8913..8ef112f883a7 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -3190,7 +3190,11 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	rvt_send_complete(sqp, wqe, send_status);
 	if (sqp->ibqp.qp_type == IB_QPT_RC) {
-		int lastwqe = rvt_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
+		int lastwqe;
+
+		spin_lock(&sqp->r_lock);
+		lastwqe = rvt_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
+		spin_unlock(&sqp->r_lock);
 
 		sqp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock_irqrestore(&sqp->s_lock, flags);
-- 
2.35.1



