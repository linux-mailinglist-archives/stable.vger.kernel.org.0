Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85E54A658
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354320AbiFNCY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354564AbiFNCXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EED4091E;
        Mon, 13 Jun 2022 19:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 897ED61024;
        Tue, 14 Jun 2022 02:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090A8C3411B;
        Tue, 14 Jun 2022 02:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172632;
        bh=Ot3Q6uO03UhYryp1ilXcGYzTa38wFdlGT/ePez9+IT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2rsHzFpM/6jbET61oC8iviRvL+oisR0hoUa/UGLtTJxT8mRmCyigN8bbfc3loH6F
         pna+yHDNy1onRnml5YZr6o8eOnVyle724+9mu23VG2rbcQWkwcDzENa4sAsssLaq6G
         rd2MNGJeSyDrbKzfAc0kgtZ8xeKmh3E4uPGpXpA39X+e7vJuIevDRCaPNTqO8lV6r1
         CEXOt7eh/nMPp/Idq4qCCvNBVvAU99a4ytmz5SB0qM6JsIV5BGfHtaxzhXPzC4Oj7h
         Ka2kVei6ARIFCg66cnLIELQ9l4ULtaIC7ffUTJkx+haw/kWHsWyOgfSnx2hklENMLL
         Gasp0m3RuKDgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/14] scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology
Date:   Mon, 13 Jun 2022 22:10:13 -0400
Message-Id: <20220614021019.1100929-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021019.1100929-1-sashal@kernel.org>
References: <20220614021019.1100929-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index da6685700b04..70733d751bb8 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -662,7 +662,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 	if (ndlp->nlp_DID == Fabric_DID) {
-		if (vport->port_state <= LPFC_FDISC)
+		if (vport->port_state <= LPFC_FDISC ||
+		    vport->fc_flag & FC_PT2PT)
 			goto out;
 		lpfc_linkdown_port(vport);
 		spin_lock_irq(shost->host_lock);
-- 
2.35.1

