Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F2541695
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376971AbiFGUxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378486AbiFGUwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E369F1D92E2;
        Tue,  7 Jun 2022 11:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CECD615CE;
        Tue,  7 Jun 2022 18:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F880C385A2;
        Tue,  7 Jun 2022 18:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627339;
        bh=h3I5A+wDlDqLSRwTv8fsj9hr+2X2VVhVi4iPFBVDOFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eecRoPiRXJtIGgInFu3hJM1UkmAkS/wA17lERC/5KhE2y4DRRNfD3ddQxScHSaMq7
         9ikcUE05Lqh8pRD8YxVIWSbe+o5doccsRxuiLQGdlPbvKuqD6CNk4M0Ro1PoJkaaXs
         tN3Nd43N9l5E6c5+5G7pA6guawcnwpYnHdfV4wdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.17 705/772] RDMA/hfi1: Fix potential integer multiplication overflow errors
Date:   Tue,  7 Jun 2022 19:04:57 +0200
Message-Id: <20220607165009.823534740@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>

commit f93e91a0372c922c20d5bee260b0f43b4b8a1bee upstream.

When multiplying of different types, an overflow is possible even when
storing the result in a larger type. This is because the conversion is
done after the multiplication. So arithmetic overflow and thus in
incorrect value is possible.

Correct an instance of this in the inter packet delay calculation.  Fix by
ensuring one of the operands is u64 which will promote the other to u64 as
well ensuring no overflow.

Cc: stable@vger.kernel.org
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20220520183712.48973.29855.stgit@awfm-01.cornelisnetworks.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -489,7 +489,7 @@ void set_link_ipg(struct hfi1_pportdata
 	u16 shift, mult;
 	u64 src;
 	u32 current_egress_rate; /* Mbits /sec */
-	u32 max_pkt_time;
+	u64 max_pkt_time;
 	/*
 	 * max_pkt_time is the maximum packet egress time in units
 	 * of the fabric clock period 1/(805 MHz).


