Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590116CC31F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjC1Ova (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbjC1OvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271F3C142
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:50:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A8D061804
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F769C4339C;
        Tue, 28 Mar 2023 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015048;
        bh=kJGtXW913NxR9ujPQ1lLDOeN/nx0QlYnPK/7s7dsaZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zophJkfegAGVKgAaaqhoIdCQiEkKBVojYD6WkijpXH1fhK2XHllDxcazaOtX+0mnF
         JBFxMsHU8srPpAaZKhq8FSm1jM4B7Q0FErbMl32aH7uBTVW45GQqFwl+P6lrPs8f8F
         qaYs52r6ZTNlvU+DZL/qP8xmoSMBhALgUfqG+M/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 148/240] scsi: mpi3mr: Driver unload crashes host when enhanced logging is enabled
Date:   Tue, 28 Mar 2023 16:41:51 +0200
Message-Id: <20230328142625.887498532@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 5b06a7169c59ce0c77ef8b9c82aa07c478f82aac ]

Prevent driver from trying to dereference a NULL pointer in a debug print
while removing a device during driver unload.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 50263ba4f8428..90f61a0a8f4ef 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1549,7 +1549,8 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 
 	list_for_each_entry_safe(mr_sas_phy, next_phy,
 	    &mr_sas_port->phy_list, port_siblings) {
-		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+		if ((!mrioc->stop_drv_processing) &&
+		    (mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
 			dev_info(&mr_sas_port->port->dev,
 			    "remove: sas_address(0x%016llx), phy(%d)\n",
 			    (unsigned long long)
-- 
2.39.2



