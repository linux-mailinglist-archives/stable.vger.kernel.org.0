Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B5B566BBC
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiGEMJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiGEMIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8865819C0E;
        Tue,  5 Jul 2022 05:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE7466185C;
        Tue,  5 Jul 2022 12:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40C4C36AF2;
        Tue,  5 Jul 2022 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022822;
        bh=p9Ok6rpgiTUosxVgNWnRJH6ar2JH1KUS+uf1ggRWfT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfomB45i1a5V7XtTi100Ka1MP5xAabSBoenUjoMb3X3p4cvRyi83h2TnA4NWodVBP
         Et9WNXJhTnTG4Vj3Qi7uvt6YK/VtUo5Y/CO8DfvvMQlEhS6lcASFFCopiOXi/xf8Bk
         BszXBlYTAzgmOAXObh98FK2gkHw95FoW222Nv0/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 22/84] RDMA/cm: Fix memory leak in ib_cm_insert_listen
Date:   Tue,  5 Jul 2022 13:57:45 +0200
Message-Id: <20220705115615.974240906@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 2990f223ffa7bb25422956b9f79f9176a5b38346 upstream.

cm_alloc_id_priv() allocates resource for the cm_id_priv. When
cm_init_listen() fails it doesn't free it, leading to memory leak.

Add the missing error unwind.

Fixes: 98f67156a80f ("RDMA/cm: Simplify establishing a listen cm_id")
Link: https://lore.kernel.org/r/20220621052546.4821-1-linmq006@gmail.com
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1280,8 +1280,10 @@ struct ib_cm_id *ib_cm_insert_listen(str
 		return ERR_CAST(cm_id_priv);
 
 	err = cm_init_listen(cm_id_priv, service_id, 0);
-	if (err)
+	if (err) {
+		ib_destroy_cm_id(&cm_id_priv->id);
 		return ERR_PTR(err);
+	}
 
 	spin_lock_irq(&cm_id_priv->lock);
 	listen_id_priv = cm_insert_listen(cm_id_priv, cm_handler);


