Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2515F4F40C2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383230AbiDEMZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348102AbiDEKpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:45:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BA134673;
        Tue,  5 Apr 2022 03:26:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FFA261743;
        Tue,  5 Apr 2022 10:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F309C385A0;
        Tue,  5 Apr 2022 10:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154412;
        bh=4Om7rs0x2EQFU2v84dM08SeVJ3v5+NTV2V76upqeUas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARzr2iJjqVofm3J+vi6rewBNa3RmwssvzkGE1QeaZYXD5tFVLqtdmpSS03yZt6rPG
         a20HKQkrWf9EABpE3wA4TiZR759j4+Djz6s7NArn9ddx5BCoNC3qvGSPyYdnTZbgag
         FQ2eEpN25iLVEk4XASWmTzpAAh/yECzelLwJiOuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 531/599] scsi: qla2xxx: Use correct feature type field during RFF_ID processing
Date:   Tue,  5 Apr 2022 09:33:45 +0200
Message-Id: <20220405070314.642305752@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
@@ -676,8 +676,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha, u8
 		return (QLA_SUCCESS);
 	}
 
-	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha),
-	    FC4_TYPE_FCP_SCSI);
+	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha), type);
 }
 
 static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
@@ -727,7 +726,7 @@ static int qla_async_rffid(scsi_qla_host
 	/* Prepare CT arguments -- port_id, FC-4 feature, FC-4 type */
 	ct_req->req.rff_id.port_id = port_id_to_be_id(*d_id);
 	ct_req->req.rff_id.fc4_feature = fc4feature;
-	ct_req->req.rff_id.fc4_type = fc4type;		/* SCSI - FCP */
+	ct_req->req.rff_id.fc4_type = fc4type;		/* SCSI-FCP or FC-NVMe */
 
 	sp->u.iocb_cmd.u.ctarg.req_size = RFF_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RFF_ID_RSP_SIZE;


