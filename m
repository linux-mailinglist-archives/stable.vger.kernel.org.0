Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7776AED84
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCGSFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjCGSEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:04:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85A7A42EF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:57:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDFA6B819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D8AC433D2;
        Tue,  7 Mar 2023 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211841;
        bh=zbHdM+cbzGQiOmIbpd0CNF9byRk2JC9BkULvN/xnVw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLqzACQJjDTxRlvpmkAA0Uz8xuFIMxS8Irg1OyYIUvVenpWwI4frEGCb6L0dexpee
         J384v+9pcKQlgq3IPEkzE9uDL2dIlecm5V2VsQxU8YIj9D8dLjIEv0DKJLssUZNJ+X
         XfMTjsHj9suvSeHi7WxTiQQeiyRZ5hY8uwWRxpQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.2 0963/1001] scsi: qla2xxx: Remove increment of interface err cnt
Date:   Tue,  7 Mar 2023 18:02:15 +0100
Message-Id: <20230307170103.987595416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

commit d676a9e3d9efb7e93df460bcf4c445496c16314f upstream.

Residual underrun is not an interface error, hence no need to increment
that count.

Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port")
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3363,8 +3363,6 @@ qla2x00_status_entry(scsi_qla_host_t *vh
 				       "Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
 				       resid, scsi_bufflen(cp));
 
-				vha->interface_err_cnt++;
-
 				res = DID_ERROR << 16 | lscsi_status;
 				goto check_scsi_status;
 			}


