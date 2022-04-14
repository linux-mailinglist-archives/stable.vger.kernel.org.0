Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85816501450
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344500AbiDNOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345798AbiDNNyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:54:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C4CAFAF1;
        Thu, 14 Apr 2022 06:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A604B82968;
        Thu, 14 Apr 2022 13:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F08BC385A5;
        Thu, 14 Apr 2022 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943914;
        bh=yQ4T9TIoITXS7/LEve1Xs+3fb0ycUVou+pMeg19nm/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkebCFLNMscSqh5SEAP9XNYelRjzVu5ldIYL0RuqbewayQeUSQ4BxVrU8FFAmubsq
         qEAWUWQiDurCBYmqJ5RZ3fmjt2KEwCmmOIcwX2AYjUKOe47Fm0iGx2+SrRJrVj1c0c
         fh0ec+Nbwty8i8LRKrWfZFRli0u89WPV68/WGl6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 327/475] scsi: qla2xxx: Use correct feature type field during RFF_ID processing
Date:   Thu, 14 Apr 2022 15:11:52 +0200
Message-Id: <20220414110904.238965036@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Manish Rangankar <mrangankar@marvell.com>

commit a7e05f7a1bcbe4ee055479242de46c5c16ab03b1 upstream.

During SNS Register FC-4 Features (RFF_ID) the initiator driver was sending
incorrect type field for NVMe supported device. Use correct feature type
field.

Link: https://lore.kernel.org/r/20220310092604.22950-12-njavali@marvell.com
Fixes: e374f9f59281 ("scsi: qla2xxx: Migrate switch registration commands away from mailbox interface")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -675,8 +675,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha, u8
 		return (QLA_SUCCESS);
 	}
 
-	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha),
-	    FC4_TYPE_FCP_SCSI);
+	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha), type);
 }
 
 static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
@@ -726,7 +725,7 @@ static int qla_async_rffid(scsi_qla_host
 	/* Prepare CT arguments -- port_id, FC-4 feature, FC-4 type */
 	ct_req->req.rff_id.port_id = port_id_to_be_id(*d_id);
 	ct_req->req.rff_id.fc4_feature = fc4feature;
-	ct_req->req.rff_id.fc4_type = fc4type;		/* SCSI - FCP */
+	ct_req->req.rff_id.fc4_type = fc4type;		/* SCSI-FCP or FC-NVMe */
 
 	sp->u.iocb_cmd.u.ctarg.req_size = RFF_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RFF_ID_RSP_SIZE;


