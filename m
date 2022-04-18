Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9BD505403
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbiDRNCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242621AbiDRNAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD4831500;
        Mon, 18 Apr 2022 05:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2556E60FB6;
        Mon, 18 Apr 2022 12:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B82FC385A1;
        Mon, 18 Apr 2022 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285704;
        bh=TpOrTXLV4U5pm4BdcV8eLd+g6FUlDQpHQ/skxzlTGSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SciOf3ZQHI86ipRsT9Dmz73eCcPWxKuOG/YOypWx0kvyA/TZ5BPdBKQcCAe8dQ58/
         lZmnEpjgshuu5plSslJY8tVfFaiH4x0alxK4QEynW3o9oFOvlq2sF+ando17tEr/EO
         KciiJHGilruRc+EF064hOOC47VNiSiprABX9+8pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 096/105] scsi: iscsi: Fix endpoint reuse regression
Date:   Mon, 18 Apr 2022 14:13:38 +0200
Message-Id: <20220418121149.362048140@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

commit 0aadafb5c34403a7cced1a8d61877048dc059f70 upstream.

This patch fixes a bug where when using iSCSI offload we can free an
endpoint while userspace still thinks it's active. That then causes the
endpoint ID to be reused for a new connection's endpoint while userspace
still thinks the ID is for the original connection. Userspace will then end
up disconnecting a running connection's endpoint or trying to bind to
another connection's endpoint.

This bug is a regression added in:

Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")

where we added a in kernel ep_disconnect call to fix a bug in:

Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")

where we would call stop_conn without having done ep_disconnect. This early
ep_disconnect call will then free the endpoint and it's ID while userspace
still thinks the ID is valid.

Fix the early release of the ID by having the in kernel recovery code keep
a reference to the endpoint until userspace has called into the kernel to
finish cleaning up the endpoint/connection. It requires the previous commit
"scsi: iscsi: Release endpoint ID when its freed" which moved the freeing
of the ID until when the endpoint is released.

Link: https://lore.kernel.org/r/20220408001314.5014-5-michael.christie@oracle.com
Fixes: 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_transport_iscsi.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2273,7 +2273,11 @@ static void iscsi_if_disconnect_bound_ep
 		mutex_unlock(&conn->ep_mutex);
 
 		flush_work(&conn->cleanup_work);
-
+		/*
+		 * Userspace is now done with the EP so we can release the ref
+		 * iscsi_cleanup_conn_work_fn took.
+		 */
+		iscsi_put_endpoint(ep);
 		mutex_lock(&conn->ep_mutex);
 	}
 }
@@ -2355,6 +2359,12 @@ static void iscsi_cleanup_conn_work_fn(s
 		return;
 	}
 
+	/*
+	 * Get a ref to the ep, so we don't release its ID until after
+	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
+	 */
+	if (conn->ep)
+		get_device(&conn->ep->dev);
 	iscsi_ep_disconnect(conn, false);
 
 	if (system_state != SYSTEM_RUNNING) {


