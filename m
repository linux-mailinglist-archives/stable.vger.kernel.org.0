Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37251FB6E9
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgFPPlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbgFPPln (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:41:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB85521531;
        Tue, 16 Jun 2020 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322103;
        bh=ruNSsfJCTPonu4mLKTusIRA8aOSqZO700jsa+VZrv2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOgKUBKyx/WDAJCWFBly40E8pNjOjwmDpYLgF2mYxBD6t0jMa8/B3/RXeFsajDyAi
         bmC3L1OTSQh0Qk7fWAKPQCUBeLDRdQPzX742GyJcpwG0so6EYvqgfSZe4bGctNtUGf
         FFnkROh10ayfN1s9w17KzpMReD4kX4HDiV1Jnhuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 111/134] scsi: lpfc: Fix negation of else clause in lpfc_prep_node_fc4type
Date:   Tue, 16 Jun 2020 17:34:55 +0200
Message-Id: <20200616153106.103157170@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dick Kennedy <dick.kennedy@broadcom.com>

commit f809da6db68a8be49e317f0ccfbced1af9258839 upstream.

Implementation of a previous patch added a condition to an if check that
always end up with the if test being true. Execution of the else clause was
inadvertently negated.  The additional condition check was incorrect and
unnecessary after the other modifications had been done in that patch.

Remove the check from the if series.

Link: https://lore.kernel.org/r/20200501214310.91713-5-jsmart2021@gmail.com
Fixes: b95b21193c85 ("scsi: lpfc: Fix loss of remote port after devloss due to lack of RPIs")
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_ct.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -462,7 +462,6 @@ lpfc_prep_node_fc4type(struct lpfc_vport
 	struct lpfc_nodelist *ndlp;
 
 	if ((vport->port_type != LPFC_NPIV_PORT) ||
-	    (fc4_type == FC_TYPE_FCP) ||
 	    !(vport->ct_flags & FC_CT_RFF_ID) || !vport->cfg_restrict_login) {
 
 		ndlp = lpfc_setup_disc_node(vport, Did);


