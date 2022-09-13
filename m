Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278DF5B7061
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiIMOZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiIMOX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AE066118;
        Tue, 13 Sep 2022 07:15:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 247D8CE1277;
        Tue, 13 Sep 2022 14:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D38C433C1;
        Tue, 13 Sep 2022 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078438;
        bh=YwyCy934OPQqHZ4UCWk+IgjuY/Cytd2eRVYocFrcypg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfurDzdZCOB7kuTb+pylAVAYfVxM0jWAnjIljC8l3N+YbEw+MYYTnXyFci8h0zlwp
         PFeyzdbgW4zS6YUl8aZ/3Ffa6vPB0ES3U5VBwnV0yNc03dDICqjHm99HO46pIsSM2Q
         53D3oUsBNNU759pvysLTkLZ60SaRZtUYdHprZX6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu-Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 140/192] RDMA/irdma: Report the correct max cqes from query device
Date:   Tue, 13 Sep 2022 16:04:06 +0200
Message-Id: <20220913140416.993301600@linuxfoundation.org>
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

[ Upstream commit 12faad5e5cf2372af2d51f348b697b5edf838daf ]

Report the correct max cqes available to an application taking
into account a reserved entry to detect overflow.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Sindhu-Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20220906223244.1119-2-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 227a799385d1d..4835702871677 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -39,7 +39,7 @@ static int irdma_query_device(struct ib_device *ibdev,
 	props->max_send_sge = hw_attrs->uk_attrs.max_hw_wq_frags;
 	props->max_recv_sge = hw_attrs->uk_attrs.max_hw_wq_frags;
 	props->max_cq = rf->max_cq - rf->used_cqs;
-	props->max_cqe = rf->max_cqe;
+	props->max_cqe = rf->max_cqe - 1;
 	props->max_mr = rf->max_mr - rf->used_mrs;
 	props->max_mw = props->max_mr;
 	props->max_pd = rf->max_pd - rf->used_pds;
-- 
2.35.1



