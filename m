Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E011D551B39
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343773AbiFTNQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245538AbiFTNO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:14:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C454201B6;
        Mon, 20 Jun 2022 06:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 783D3614B7;
        Mon, 20 Jun 2022 13:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660CDC3411B;
        Mon, 20 Jun 2022 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730350;
        bh=n0EDmbEOrkNOBvW/GijmfjermZbvRf0zE44tEbRt0PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y75goWTV1IBnDGHUR95kzRIEN8f1P2m7+RvKE9CLM5LMziY67562huJVdRwz5CLUU
         tRsl+C1moHIT/EYqFSMT+Wq6zm8wJfmkycb+6WsVG3TMFeJnKZyQBUt0X9MWqxXgla
         9SPReMbQYKCa9Yn2pjiC9q61bdejDw7f5ZtivrzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/106] scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology
Date:   Mon, 20 Jun 2022 14:50:44 +0200
Message-Id: <20220620124725.128905313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 336d63615466b4c06b9401c987813fd19bdde39b ]

After issuing a LIP, a specific target vendor does not ACC the FLOGI that
lpfc sends.  However, it does send its own FLOGI that lpfc ACCs.  The
target then establishes the port IDs by sending a PLOGI.  lpfc PLOGI_ACCs
and starts the RPI registration for DID 0x000001.  The target then sends a
LOGO to the fabric DID.  lpfc is currently treating the LOGO from the
fabric DID as a link down and cleans up all the ndlps.  The ndlp for DID
0x000001 is put back into NPR and discovery stops, leaving the port in
stuck in bypassed mode.

Change lpfc behavior such that if a LOGO is received for the fabric DID in
PT2PT topology skip the lpfc_linkdown_port() routine and just move the
fabric DID back to NPR.

Link: https://lore.kernel.org/r/20220603174329.63777-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index fdf5e777bf11..2bd35a7424c2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -810,7 +810,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_nvmet_invalidate_host(phba, ndlp);
 
 	if (ndlp->nlp_DID == Fabric_DID) {
-		if (vport->port_state <= LPFC_FDISC)
+		if (vport->port_state <= LPFC_FDISC ||
+		    vport->fc_flag & FC_PT2PT)
 			goto out;
 		lpfc_linkdown_port(vport);
 		spin_lock_irq(shost->host_lock);
-- 
2.35.1



