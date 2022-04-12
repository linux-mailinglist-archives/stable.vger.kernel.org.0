Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23F14FD16B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351491AbiDLG6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351909AbiDLGyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C052E686;
        Mon, 11 Apr 2022 23:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BAB860B7D;
        Tue, 12 Apr 2022 06:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F67EC385A6;
        Tue, 12 Apr 2022 06:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745877;
        bh=1y//JtFRzpxMUEVsT+8JnZW1cd3CXAaU1Adhi2OqQVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=td5amKi60XdJZGfSEuJu2AC60VMpTrUQwlIwEcDU5wK1VKfKxy3OUU1BnwGZrmEVe
         TLHyDf7kVgytcVUwzbFy9whH3jVpw86dXTKbyHi6+fpOAgNGaXeipBNpaF4v3ZV/8D
         bZCarhyIbYmHLbYTR6PxC9cFcUz8Hg5b03O60dSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/277] scsi: mpi3mr: Fix reporting of actual data transfer size
Date:   Tue, 12 Apr 2022 08:27:36 +0200
Message-Id: <20220412062943.585849070@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 9992246127246a27cc7184f05cce6f62ac48f84e ]

The driver is missing to set the residual size while completing an
I/O. Ensure proper data transfer size is reported to the kernel on I/O
completion based on the transfer length reported by the firmware.

Link: https://lore.kernel.org/r/20220210095817.22828-7-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3cae8803383b..b2c650542bac 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2204,6 +2204,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		scmd->result = DID_OK << 16;
 		goto out_success;
 	}
+
+	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_count);
 	if (ioc_status == MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN &&
 	    xfer_count == 0 && (scsi_status == MPI3_SCSI_STATUS_BUSY ||
 	    scsi_status == MPI3_SCSI_STATUS_RESERVATION_CONFLICT ||
-- 
2.35.1



