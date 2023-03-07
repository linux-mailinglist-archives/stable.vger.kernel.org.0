Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085396AF59E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjCGT1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbjCGT1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6488AB2549
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D187861559
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8505C433D2;
        Tue,  7 Mar 2023 19:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216409;
        bh=7onBwOInKWTbGi+VkKtgTsOgT1NqZKnOqIWmN1io9so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUfGUM3qVwK7wIxMMGKgfRj12XT6E71a5S4AXWL/veuXow2BbiAVOrDbN+7Ajr0Sa
         +dllM3i9hjRD5C0QyC5ifbvdJPqvIHn6Rx0oLWPBPJiD2ZZVEBIeuf7zPyzARBkOCW
         f2VJlQ7KE949tpqux8J7am4MbBUa3DISPvTSBc30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 543/567] scsi: qla2xxx: Fix erroneous link down
Date:   Tue,  7 Mar 2023 18:04:39 +0100
Message-Id: <20230307165929.484891398@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 3fbc74feb642deb688cc97f76d40b7287ddd4cb1 upstream.

If after an adapter reset the appearance of link is not recovered, the
devices are not rediscovered.  This is result of a race condition between
adapter reset (abort_isp) and the topology scan.  During adapter reset, the
ABORT_ISP_ACTIVE flag is set.  Topology scan usually occurred after adapter
reset.  In this case, the topology scan came earlier than usual where it
ran into problem due to ABORT_ISP_ACTIVE flag was still set.

kernel: qla2xxx [0000:13:00.0]-1005:1: Cmd 0x6a aborted with timeout since ISP Abort is pending
kernel: qla2xxx [0000:13:00.0]-28a0:1: MBX_GET_PORT_NAME failed, No FL Port.
kernel: qla2xxx [0000:13:00.0]-286b:1: qla2x00_configure_loop: exiting normally. local port wwpn 51402ec0123d9a80 id 012300)
kernel: qla2xxx [0000:13:00.0]-8017:1: ADAPTER RESET SUCCEEDED nexus=1:0:15.

Allow adapter reset to complete before any scan can start.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7069,9 +7069,12 @@ qla2x00_do_dpc(void *data)
 			}
 		}
 loop_resync_check:
-		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
+		if (!qla2x00_reset_active(base_vha) &&
+		    test_and_clear_bit(LOOP_RESYNC_NEEDED,
 		    &base_vha->dpc_flags)) {
-
+			/*
+			 * Allow abort_isp to complete before moving on to scanning.
+			 */
 			ql_dbg(ql_dbg_dpc, base_vha, 0x400f,
 			    "Loop resync scheduled.\n");
 


