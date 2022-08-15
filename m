Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814735944A7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244564AbiHOWT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350763AbiHOWS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A0E12421D;
        Mon, 15 Aug 2022 12:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80D49B80EA8;
        Mon, 15 Aug 2022 19:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BEEC433C1;
        Mon, 15 Aug 2022 19:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592482;
        bh=kSUwktPd62XEnkvaJwjmf6uWtQLy1ghU5YPPCWn76H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=si6EhaPtt6GEtb7MLpDFSysLS62DiF/LwK1nn3Y+8spqj6kjNRmM2/ltalxN6JLtv
         sU8b6PKKUkEA01NJI+IjJnB6AYA+M80uxuSUha3RrUdnBK9H6PuWtPB/UQVPvq61mH
         TMK2Fdx1HB13QHWqZZ1xqe5h7EP0sw2+ddjvisLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Sobczak <bartosz.sobczak@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0764/1095] RDMA/irdma: Fix a window for use-after-free
Date:   Mon, 15 Aug 2022 20:02:43 +0200
Message-Id: <20220815180500.874753119@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 8ecef7890b3aea78c8bbb501a4b5b8134367b821 ]

During a destroy CQ an interrupt may cause processing of a CQE after CQ
resources are freed by irdma_cq_free_rsrc(). Fix this by moving the call
to irdma_cq_free_rsrc() after the irdma_sc_cleanup_ceqes(), which is
called under the cq_lock.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://lore.kernel.org/r/20220705230815.265-6-shiraz.saleem@intel.com
Signed-off-by: Bartosz Sobczak <bartosz.sobczak@intel.com>
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 6daa149dcbda..b29631f6659a 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1760,11 +1760,11 @@ static int irdma_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	spin_unlock_irqrestore(&iwcq->lock, flags);
 
 	irdma_cq_wq_destroy(iwdev->rf, cq);
-	irdma_cq_free_rsrc(iwdev->rf, iwcq);
 
 	spin_lock_irqsave(&iwceq->ce_lock, flags);
 	irdma_sc_cleanup_ceqes(cq, ceq);
 	spin_unlock_irqrestore(&iwceq->ce_lock, flags);
+	irdma_cq_free_rsrc(iwdev->rf, iwcq);
 
 	return 0;
 }
-- 
2.35.1



