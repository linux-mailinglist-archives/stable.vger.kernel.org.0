Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCD44C770A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiB1SLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241509AbiB1SKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:10:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2364B65FB;
        Mon, 28 Feb 2022 09:50:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73BCB608D5;
        Mon, 28 Feb 2022 17:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C608C36AF8;
        Mon, 28 Feb 2022 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070603;
        bh=ZQSl1PHtTbpi0tBEr5HZNu19R3TkoKzvDwABG6xiSFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4I31MxtyIY5/tDMTzgEGy3eRwjHt/0aI8weeVd5Ppx7EqYFFvkvHz7P6UTRbP9zD
         IYbQkUyYXJ2+rtszRVdt3LpJtu3FWnEzqW6IldA7H3W7YngPa7GwN29e4GLMn0if3a
         Jw1lTp43X3GaTgU9E01tbMBvlwomhIe1rKXbto4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.16 149/164] IB/qib: Fix duplicate sysfs directory name
Date:   Mon, 28 Feb 2022 18:25:11 +0100
Message-Id: <20220228172413.335064838@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 32f57cb1b2c8d6f20aefec7052b1bfeb7e3b69d4 upstream.

The qib driver load has been failing with the following message:

  sysfs: cannot create duplicate filename '/devices/pci0000:80/0000:80:02.0/0000:81:00.0/infiniband/qib0/ports/1/linkcontrol'

The patch below has two "linkcontrol" names causing the duplication.

Fix by using the correct "diag_counters" name on the second instance.

Fixes: 4a7aaf88c89f ("RDMA/qib: Use attributes for the port sysfs")
Link: https://lore.kernel.org/r/1645106372-23004-1-git-send-email-mike.marciniszyn@cornelisnetworks.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -541,7 +541,7 @@ static struct attribute *port_diagc_attr
 };
 
 static const struct attribute_group port_diagc_group = {
-	.name = "linkcontrol",
+	.name = "diag_counters",
 	.attrs = port_diagc_attributes,
 };
 


