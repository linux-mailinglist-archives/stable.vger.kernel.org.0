Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FB755DF00
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbiF0Lin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiF0Lhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FB4B1CF;
        Mon, 27 Jun 2022 04:34:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFD05B81122;
        Mon, 27 Jun 2022 11:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A72C3411D;
        Mon, 27 Jun 2022 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329669;
        bh=Yyipdz0XzKZ0zgmwRFh5h1EHwsuJNqosUSfRRf+D3kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wp+OY+JJGObYvyDAlU7d2UFOjBtxKEzvtD+j0Mxt0xVklFM1omrxBhZbKIJGlnwFO
         qk4DcbdCGca+GDQ4Wg+e7PhSGiJjQEARPGAwVa3NaZxlppGLwHdoVDpf9qYIHwPufI
         tvYPrCTF1P6+7wWNfCmuOtUGxKZ8PVcPLeT9GfvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Sergey Gorenko <sergeygo@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/135] scsi: iscsi: Exclude zero from the endpoint ID range
Date:   Mon, 27 Jun 2022 13:20:45 +0200
Message-Id: <20220627111939.264369566@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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

From: Sergey Gorenko <sergeygo@nvidia.com>

[ Upstream commit f6eed15f3ea76596ccc689331e1cc850b999133b ]

The kernel returns an endpoint ID as r.ep_connect_ret.handle in the
iscsi_uevent. The iscsid validates a received endpoint ID and treats zero
as an error. The commit referenced in the fixes line changed the endpoint
ID range, and zero is always assigned to the first endpoint ID.  So, the
first attempt to create a new iSER connection always fails.

Link: https://lore.kernel.org/r/20220613123854.55073-1-sergeygo@nvidia.com
Fixes: 3c6ae371b8a1 ("scsi: iscsi: Release endpoint ID when its freed")
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Sergey Gorenko <sergeygo@nvidia.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bcdfcb25349a..5947b9d5746e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -213,7 +213,12 @@ iscsi_create_endpoint(int dd_size)
 		return NULL;
 
 	mutex_lock(&iscsi_ep_idr_mutex);
-	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+
+	/*
+	 * First endpoint id should be 1 to comply with user space
+	 * applications (iscsid).
+	 */
+	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
 	if (id < 0) {
 		mutex_unlock(&iscsi_ep_idr_mutex);
 		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
-- 
2.35.1



