Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8995E4C7593
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiB1Rzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240292AbiB1RyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834EE939E1;
        Mon, 28 Feb 2022 09:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E29D1CE17C4;
        Mon, 28 Feb 2022 17:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F8EC340E7;
        Mon, 28 Feb 2022 17:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070105;
        bh=ZQSl1PHtTbpi0tBEr5HZNu19R3TkoKzvDwABG6xiSFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TI1BwdPCLTc8NUuEDNTO4Ti+hGxs/PDBDoBdOn/jxxGCH7FbpDQsuZea4IV5ZKiqt
         jxw8eB4pQvJIUMGhxTkRgp0fe/XtE3C389tid+0OLzk4tZs3GrAqunR9/WMO2swfI5
         TueknyUNK3AiowMqOyoMftkNKXTzGSzULcUzyvjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 125/139] IB/qib: Fix duplicate sysfs directory name
Date:   Mon, 28 Feb 2022 18:24:59 +0100
Message-Id: <20220228172400.804290699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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
 


