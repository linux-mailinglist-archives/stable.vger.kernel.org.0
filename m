Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD64A638C
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbiBASSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:18:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51354 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242051AbiBASSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:18:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4E11BCE1A62;
        Tue,  1 Feb 2022 18:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC0DC340ED;
        Tue,  1 Feb 2022 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739477;
        bh=llYpXRNgCDL02EcSmVcoB724PH/9gJDPbx2yGxcQE2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlGBQIPwXgvh+Ih0dFacZELm7M9r4aqM9aT66NmJs8wTTS0lsF2vQSPlyfFXxZtTU
         h01ta51n3G8CJ9Y/RkWVfzP0safy8lNnSFd74ZBsDhpMFnmMTqfJMKxsvp63xO0eNS
         x2F5daftYTghdZOgpp4omxDiA3CgfeE7YplSUbgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 04/25] scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices
Date:   Tue,  1 Feb 2022 19:16:28 +0100
Message-Id: <20220201180822.300315007@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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


