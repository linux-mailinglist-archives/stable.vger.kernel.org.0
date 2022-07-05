Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62660566D5A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbiGEMWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiGEMTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D031DA5C;
        Tue,  5 Jul 2022 05:16:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21784B817CC;
        Tue,  5 Jul 2022 12:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0E6C341C8;
        Tue,  5 Jul 2022 12:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023368;
        bh=N4W8MqS03GqdSCzZcs5qa007DfigsM15g5FYh63Tv8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2uwU+UgUW08DbgRPMwfkd58j9ElZxl8rbzW2oGIBtqp4M3CGpmLYIKJm2XKBpUNH
         R4eLD6hGCzWV7Pdsqxxyr+E26cQL2SjXRXNBBzc3RzxniPg82OIbw4fBLAnNWHKU+7
         wYr+ukAlWbLFC6FAWFJ/Har7py6v9oJRlMCniQiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.18 034/102] RDMA/cm: Fix memory leak in ib_cm_insert_listen
Date:   Tue,  5 Jul 2022 13:58:00 +0200
Message-Id: <20220705115619.382298693@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
@@ -1252,8 +1252,10 @@ struct ib_cm_id *ib_cm_insert_listen(str
 		return ERR_CAST(cm_id_priv);
 
 	err = cm_init_listen(cm_id_priv, service_id, 0);
-	if (err)
+	if (err) {
+		ib_destroy_cm_id(&cm_id_priv->id);
 		return ERR_PTR(err);
+	}
 
 	spin_lock_irq(&cm_id_priv->lock);
 	listen_id_priv = cm_insert_listen(cm_id_priv, cm_handler);


