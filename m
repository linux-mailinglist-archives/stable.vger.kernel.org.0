Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F45C6B4170
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCJNxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjCJNxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:53:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6896F11567F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 157ADB822B9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628CAC433EF;
        Fri, 10 Mar 2023 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456363;
        bh=wPygZ0stChoHkYaN0o2T1JGxTm8kLDi/b7vH2HvlPLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3rRQ+bmO9rOi6NzE28oKJejFgOesT93vej8fxqXqE3H3kjPqHj4Col1SW3nk5WvA
         Er9J9BY3YxbZUcvMuVJOyMSnYRSMDs0uFeTpa5BvvU5hU+8chNZcwrIV0vEtseSEcR
         5SBpS/RuZo4wAP/wpZHUfPFrwh/HpxVlA139FCQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 140/193] scsi: qla2xxx: Fix erroneous link down
Date:   Fri, 10 Mar 2023 14:38:42 +0100
Message-Id: <20230310133715.887404100@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
@@ -5887,9 +5887,12 @@ qla2x00_do_dpc(void *data)
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
 


