Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FC24ABABF
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384046AbiBGLYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355253AbiBGLII (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:08:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B12C043188;
        Mon,  7 Feb 2022 03:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8343611AA;
        Mon,  7 Feb 2022 11:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7067C004E1;
        Mon,  7 Feb 2022 11:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232086;
        bh=llYpXRNgCDL02EcSmVcoB724PH/9gJDPbx2yGxcQE2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTcQCO+EYB8ffxtyws+NeLKx4Z7B4f1/gY4dp3GEmnG2vN5M9KmwOS9fqCeFVGZa4
         FcJ35nGRo99Rau8zIheqfG2zQMxZvdXb7Puf1pynmD40zb3NxSoHFOLkLQQsqpqsmt
         NYYxc67jGGFDwzJ6EFZQW605kinCRGc+6UZ5i594=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 04/48] scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices
Date:   Mon,  7 Feb 2022 12:05:37 +0100
Message-Id: <20220207103752.486196824@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
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

From: Steffen Maier <maier@linux.ibm.com>

commit 8c9db6679be4348b8aae108e11d4be2f83976e30 upstream.

Suppose we have an environment with a number of non-NPIV FCP devices
(virtual HBAs / FCP devices / zfcp "adapter"s) sharing the same physical
FCP channel (HBA port) and its I_T nexus. Plus a number of storage target
ports zoned to such shared channel. Now one target port logs out of the
fabric causing an RSCN. Zfcp reacts with an ADISC ELS and subsequent port
recovery depending on the ADISC result. This happens on all such FCP
devices (in different Linux images) concurrently as they all receive a copy
of this RSCN. In the following we look at one of those FCP devices.

Requests other than FSF_QTCB_FCP_CMND can be slow until they get a
response.

Depending on which requests are affected by slow responses, there are
different recovery outcomes. Here we want to fix failed recoveries on port
or adapter level by avoiding recovery requests that can be slow.

We need the cached N_Port_ID for the remote port "link" test with ADISC.
Just before sending the ADISC, we now intentionally forget the old cached
N_Port_ID. The idea is that on receiving an RSCN for a port, we have to
assume that any cached information about this port is stale.  This forces a
fresh new GID_PN [FC-GS] nameserver lookup on any subsequent recovery for
the same port. Since we typically can still communicate with the nameserver
efficiently, we now reach steady state quicker: Either the nameserver still
does not know about the port so we stop recovery, or the nameserver already
knows the port potentially with a new N_Port_ID and we can successfully and
quickly perform open port recovery.  For the one case, where ADISC returns
successfully, we re-initialize port->d_id because that case does not
involve any port recovery.

This also solves a problem if the storage WWPN quickly logs into the fabric
again but with a different N_Port_ID. Such as on virtual WWPN takeover
during target NPIV failover.
[https://www.redbooks.ibm.com/abstracts/redp5477.html] In that case the
RSCN from the storage FDISC was ignored by zfcp and we could not
successfully recover the failover. On some later failback on the storage,
we could have been lucky if the virtual WWPN got the same old N_Port_ID
from the SAN switch as we still had cached.  Then the related RSCN
triggered a successful port reopen recovery.  However, there is no
guarantee to get the same N_Port_ID on NPIV FDISC.

Even though NPIV-enabled FCP devices are not affected by this problem, this
code change optimizes recovery time for gone remote ports as a side effect.
The timely drop of cached N_Port_IDs prevents unnecessary slow open port
attempts.

While the problem might have been in code before v2.6.32 commit
799b76d09aee ("[SCSI] zfcp: Decouple gid_pn requests from erp") this fix
depends on the gid_pn_work introduced with that commit, so we mark it as
culprit to satisfy fix dependencies.

Note: Point-to-point remote port is already handled separately and gets its
N_Port_ID from the cached peer_d_id. So resetting port->d_id in general
does not affect PtP.

Link: https://lore.kernel.org/r/20220118165803.3667947-1-maier@linux.ibm.com
Fixes: 799b76d09aee ("[SCSI] zfcp: Decouple gid_pn requests from erp")
Cc: <stable@vger.kernel.org> #2.6.32+
Suggested-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/scsi/zfcp_fc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -518,6 +518,8 @@ static void zfcp_fc_adisc_handler(void *
 		goto out;
 	}
 
+	/* re-init to undo drop from zfcp_fc_adisc() */
+	port->d_id = ntoh24(adisc_resp->adisc_port_id);
 	/* port is good, unblock rport without going through erp */
 	zfcp_scsi_schedule_rport_register(port);
  out:
@@ -531,6 +533,7 @@ static int zfcp_fc_adisc(struct zfcp_por
 	struct zfcp_fc_req *fc_req;
 	struct zfcp_adapter *adapter = port->adapter;
 	struct Scsi_Host *shost = adapter->scsi_host;
+	u32 d_id;
 	int ret;
 
 	fc_req = kmem_cache_zalloc(zfcp_fc_req_cache, GFP_ATOMIC);
@@ -555,7 +558,15 @@ static int zfcp_fc_adisc(struct zfcp_por
 	fc_req->u.adisc.req.adisc_cmd = ELS_ADISC;
 	hton24(fc_req->u.adisc.req.adisc_port_id, fc_host_port_id(shost));
 
-	ret = zfcp_fsf_send_els(adapter, port->d_id, &fc_req->ct_els,
+	d_id = port->d_id; /* remember as destination for send els below */
+	/*
+	 * Force fresh GID_PN lookup on next port recovery.
+	 * Must happen after request setup and before sending request,
+	 * to prevent race with port->d_id re-init in zfcp_fc_adisc_handler().
+	 */
+	port->d_id = 0;
+
+	ret = zfcp_fsf_send_els(adapter, d_id, &fc_req->ct_els,
 				ZFCP_FC_CTELS_TMO);
 	if (ret)
 		kmem_cache_free(zfcp_fc_req_cache, fc_req);


