Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89386AF589
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjCGT0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbjCGTZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:25:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9D3A83AF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:11:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9DB88CE1C5D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A883C433D2;
        Tue,  7 Mar 2023 19:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216312;
        bh=9ns6KDa98YvFpirUE9vMea+DqLZg8SkYY/Unfcm9Ors=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNsOv/XwtRoMYCBm67mmCmUNmdNnjTNTjvHwbUEKFVy/pKgCqq58SHwp38kYQ+9C1
         I0bKGQFGq/V9zDpOa4j7T/yp2F5CxYSS2sf3NPo/5zClBv9Q4N2VAljiYSHd/D3Qpt
         E+P2VijBeW9bMc/wuQME0HetPcXvQE3CFfQ2Giqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 544/567] scsi: qla2xxx: Remove increment of interface err cnt
Date:   Tue,  7 Mar 2023 18:04:40 +0100
Message-Id: <20230307165929.529664271@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
@@ -3350,8 +3350,6 @@ qla2x00_status_entry(scsi_qla_host_t *vh
 				       "Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
 				       resid, scsi_bufflen(cp));
 
-				vha->interface_err_cnt++;
-
 				res = DID_ERROR << 16 | lscsi_status;
 				goto check_scsi_status;
 			}


