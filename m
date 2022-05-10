Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DC6521763
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242792AbiEJNWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243450AbiEJNVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CB84EF58;
        Tue, 10 May 2022 06:16:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EBCD61663;
        Tue, 10 May 2022 13:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF8AC385A6;
        Tue, 10 May 2022 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188566;
        bh=rrHsYt9Qs4PHF/mVTk+Pvgt2CBMycA8rpv2zIgNl2mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0IdvtVW/PJG73rDMFMm6yzY2BFe5mpsJr4cKeY5I2IAleDCaO/S+M7iOHG3U7obe
         bNHDKpA4/nlKfxWjiyg5M+rzIVVdhrZ4H2KhbTnXF7FT1sYsS9fuFo0MsFiPlBgn3f
         UbS9l5ZQrkptZqt/Zv9RTTwCz1/sdUopSi2/Vkm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 4.14 50/78] tty: n_gsm: fix wrong command retry handling
Date:   Tue, 10 May 2022 15:07:36 +0200
Message-Id: <20220510130734.019028524@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

commit d0bcdffcad5a22f202e3bf37190c0dd8c080ea92 upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.7.3 states that the valid range for the
maximum number of retransmissions (N2) is from 0 to 255 (both including).
gsm_config() fails to limit this range correctly. Furthermore,
gsm_control_retransmit() handles this number incorrectly by performing
N2 - 1 retransmission attempts. Setting N2 to zero results in more than 255
retransmission attempts.
Fix the range check in gsm_config() and the value handling in
gsm_control_send() and gsm_control_retransmit() to comply with 3GPP 27.010.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-11-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1341,7 +1341,6 @@ static void gsm_control_retransmit(unsig
 	spin_lock_irqsave(&gsm->control_lock, flags);
 	ctrl = gsm->pending_cmd;
 	if (ctrl) {
-		gsm->cretries--;
 		if (gsm->cretries == 0) {
 			gsm->pending_cmd = NULL;
 			ctrl->error = -ETIMEDOUT;
@@ -1350,6 +1349,7 @@ static void gsm_control_retransmit(unsig
 			wake_up(&gsm->event);
 			return;
 		}
+		gsm->cretries--;
 		gsm_control_transmit(gsm, ctrl);
 		mod_timer(&gsm->t2_timer, jiffies + gsm->t2 * HZ / 100);
 	}
@@ -1390,7 +1390,7 @@ retry:
 
 	/* If DLCI0 is in ADM mode skip retries, it won't respond */
 	if (gsm->dlci[0]->mode == DLCI_MODE_ADM)
-		gsm->cretries = 1;
+		gsm->cretries = 0;
 	else
 		gsm->cretries = gsm->n2;
 
@@ -2531,7 +2531,7 @@ static int gsmld_config(struct tty_struc
 	/* Check the MRU/MTU range looks sane */
 	if (c->mru > MAX_MRU || c->mtu > MAX_MTU || c->mru < 8 || c->mtu < 8)
 		return -EINVAL;
-	if (c->n2 < 3)
+	if (c->n2 > 255)
 		return -EINVAL;
 	if (c->encapsulation > 1)	/* Basic, advanced, no I */
 		return -EINVAL;


