Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CF44FD737
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354044AbiDLHiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353623AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F5C43AEB;
        Tue, 12 Apr 2022 00:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F0DB81B4E;
        Tue, 12 Apr 2022 07:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F033AC385A1;
        Tue, 12 Apr 2022 07:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746932;
        bh=r8a9lHuAGZPUTvvW+D5b/UG4FvvagGtzxKifdNP/HL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRMWdmEYJ2l7AZWNgzTVpE2F5VOh+kr4c0pq9s5VKQR3rqDUW1De/VuiSA0IekPPw
         6vR8YyCdyOkBmnpuhmAkXgQ+SsNspf5/U+9+91h9wyFSX0nmzqs3DlxWT7AwPR/fsV
         G86uvTSehQ2/1Bo4PXzvy2HJGejVo83PwPixEwvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 182/285] IB/rdmavt: add lock to call to rvt_error_qp to prevent a race condition
Date:   Tue, 12 Apr 2022 08:30:39 +0200
Message-Id: <20220412062948.918240106@linuxfoundation.org>
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



