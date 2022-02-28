Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAC34C75ED
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbiB1R5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiB1RzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:55:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE51553B57;
        Mon, 28 Feb 2022 09:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9373B815A2;
        Mon, 28 Feb 2022 17:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3FC340F0;
        Mon, 28 Feb 2022 17:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070275;
        bh=TmwptS0LPX8K1+wjHqfFZhxtwLD7yiQW5Pozv3nnNUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIlmsn1Z3UeqJShBONXswOmD2N4h4bmzJL1RoTqm5vaXbXD61FWU5z3apJp/s9avo
         qyItd0DOk93OW/g9T1Mfb4xcTl4tFys8eKslBQv80Ri4Aad8UCbBWADGSQtIyNx9Pc
         3iZhxcYFNXyzPGs5mQd7ZM49A+MwWoTq/UWeOCv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikas Gupta <vikas.gupta@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 048/164] bnxt_en: Restore the resets_reliable flag in bnxt_open()
Date:   Mon, 28 Feb 2022 18:23:30 +0100
Message-Id: <20220228172404.579894554@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

commit 0e0e3c5358470cbad10bd7ca29f84a44d179d286 upstream.

During ifdown, we call bnxt_inv_fw_health_reg() which will clear
both the status_reliable and resets_reliable flags if these
registers are mapped.  This is correct because a FW reset during
ifdown will clear these register mappings.  If we detect that FW
has gone through reset during the next ifup, we will remap these
registers.

But during normal ifup with no FW reset, we need to restore the
resets_reliable flag otherwise we will not show the reset counter
during devlink diagnose.

Fixes: 8cc95ceb7087 ("bnxt_en: improve fw diagnose devlink health messages")
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7776,6 +7776,19 @@ static int bnxt_map_fw_health_regs(struc
 	return 0;
 }
 
+static void bnxt_remap_fw_health_regs(struct bnxt *bp)
+{
+	if (!bp->fw_health)
+		return;
+
+	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY) {
+		bp->fw_health->status_reliable = true;
+		bp->fw_health->resets_reliable = true;
+	} else {
+		bnxt_try_map_fw_health_reg(bp);
+	}
+}
+
 static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
@@ -9836,8 +9849,8 @@ static int bnxt_hwrm_if_change(struct bn
 		resc_reinit = true;
 	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE)
 		fw_reset = true;
-	else if (bp->fw_health && !bp->fw_health->status_reliable)
-		bnxt_try_map_fw_health_reg(bp);
+	else
+		bnxt_remap_fw_health_regs(bp);
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) && !fw_reset) {
 		netdev_err(bp->dev, "RESET_DONE not set during FW reset.\n");


