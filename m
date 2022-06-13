Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17982549284
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354264AbiFMLcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354308AbiFML3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A63EF16;
        Mon, 13 Jun 2022 03:43:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEE8D60F9A;
        Mon, 13 Jun 2022 10:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5CBC34114;
        Mon, 13 Jun 2022 10:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116995;
        bh=rxf+5mUCLVk1ZPGMwJN0/U1Zl7xVwG3EKf9U5j4w30s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZrB/CA3LBeRKQfYF0irUlJv4e1L++cKEoknE0j4z3jGwcWnAleNGYrgDs1B/w3zD
         TUixXk67Zz7Q49KxR+reXUeEx/n4ozQ4mzCrQqj+tKFYgmGpjYYkPgmBtTQV3M2xgv
         LxlRM8T4NrE0n1X0nZcVHOmRDJGh5kmXH208qj2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 249/411] RDMA/hfi1: Fix potential integer multiplication overflow errors
Date:   Mon, 13 Jun 2022 12:08:42 +0200
Message-Id: <20220613094936.238950151@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
@@ -543,7 +543,7 @@ void set_link_ipg(struct hfi1_pportdata
 	u16 shift, mult;
 	u64 src;
 	u32 current_egress_rate; /* Mbits /sec */
-	u32 max_pkt_time;
+	u64 max_pkt_time;
 	/*
 	 * max_pkt_time is the maximum packet egress time in units
 	 * of the fabric clock period 1/(805 MHz).


