Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32AC4F2C1E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347479AbiDEJ0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiDEIRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9ACB18A6;
        Tue,  5 Apr 2022 01:05:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B4BE617E9;
        Tue,  5 Apr 2022 08:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F5EC385A0;
        Tue,  5 Apr 2022 08:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145936;
        bh=L6eP2xInAx8Yc/Dtn99mdaT/6HwILm+CN2lMGkmDi9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1A9hB/MQb8BUW7GXHhsmogFUQLao9eSf2TukvrbCUtMRk4MBGA5/ZBJyrR+32IKa
         nB6puQri4DtDahG+BLGbV9epIurMiuo/r4J5p/tN9UbFPsU/3ckILHTbibLuncvsbn
         7IahrBI57dE+3CbbJqftjaSEPlodhTg4euQW4Mvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hiral Patel <hiralpat@cisco.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0582/1126] scsi: fnic: Fix a tracing statement
Date:   Tue,  5 Apr 2022 09:22:09 +0200
Message-Id: <20220405070424.715918800@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 3032ed77a28913203a4fe0ab8f05752331af79b3 ]

Report both the command flags and command state instead of only the
command state.

Link: https://lore.kernel.org/r/20220218195117.25689-22-bvanassche@acm.org
Fixes: 4d7007b49d52 ("[SCSI] fnic: Fnic Trace Utility")
Cc: Hiral Patel <hiralpat@cisco.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 40a52feb315d..65047806a541 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -604,7 +604,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc)
 
 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
 		  tag, sc, io_req, sg_count, cmd_trace,
-		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
+		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
 	/* if only we issued IO, will we have the io lock */
 	if (io_lock_acquired)
-- 
2.34.1



