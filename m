Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20CE517A97
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiEBXVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiEBXVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:21:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0D730F7A
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8758B81A9D
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577B9C385A4;
        Mon,  2 May 2022 23:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651533447;
        bh=OTp1KC8S8E9dFg0pstKzBEDdj5bU3p/35m3UXQ3wLWU=;
        h=Subject:To:Cc:From:Date:From;
        b=nQD0nMlaI3qrztXx9hg89QCzyLm57taXN48rsb9dABjkxJPTt7+37JbSa06sJrUwB
         Dgx134N6tEcizCRHfWbdFCU5qAYtZeRIx5gVWxQgE3aDe6Z2siFokhsB6nhNabkChR
         jDPg/sEb9wcZYDbqA6cDsH4YSq7MUqKYFKNZm2gE=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix frame reception handling" failed to apply to 4.19-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 01:17:24 +0200
Message-ID: <1651533444171214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a0e4b1733b635026a87c023f6d703faf0095e39 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:11 -0700
Subject: [PATCH] tty: n_gsm: fix frame reception handling

The frame checksum (FCS) is currently handled in gsm_queue() after
reception of a frame. However, this breaks layering. A workaround with
'received_fcs' was implemented so far.
Furthermore, frames are handled as such even if no end flag was received.
Move FCS calculation from gsm_queue() to gsm0_receive() and gsm1_receive().
Also delay gsm_queue() call there until a full frame was received to fix
both points.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-6-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 3ba2505908e3..4ce18b42c37a 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -219,7 +219,6 @@ struct gsm_mux {
 	int encoding;
 	u8 control;
 	u8 fcs;
-	u8 received_fcs;
 	u8 *txframe;			/* TX framing buffer */
 
 	/* Method for the receiver side */
@@ -1794,18 +1793,7 @@ static void gsm_queue(struct gsm_mux *gsm)
 	u8 cr;
 	int address;
 	int i, j, k, address_tmp;
-	/* We have to sneak a look at the packet body to do the FCS.
-	   A somewhat layering violation in the spec */
 
-	if ((gsm->control & ~PF) == UI)
-		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
-	if (gsm->encoding == 0) {
-		/* WARNING: gsm->received_fcs is used for
-		gsm->encoding = 0 only.
-		In this case it contain the last piece of data
-		required to generate final CRC */
-		gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
-	}
 	if (gsm->fcs != GOOD_FCS) {
 		gsm->bad_fcs++;
 		if (debug & 4)
@@ -1993,19 +1981,25 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 		break;
 	case GSM_DATA:		/* Data */
 		gsm->buf[gsm->count++] = c;
-		if (gsm->count == gsm->len)
+		if (gsm->count == gsm->len) {
+			/* Calculate final FCS for UI frames over all data */
+			if ((gsm->control & ~PF) != UIH) {
+				gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf,
+							     gsm->count);
+			}
 			gsm->state = GSM_FCS;
+		}
 		break;
 	case GSM_FCS:		/* FCS follows the packet */
-		gsm->received_fcs = c;
-		gsm_queue(gsm);
+		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		gsm->state = GSM_SSOF;
 		break;
 	case GSM_SSOF:
-		if (c == GSM0_SOF) {
-			gsm->state = GSM_SEARCH;
-			break;
-		}
+		gsm->state = GSM_SEARCH;
+		if (c == GSM0_SOF)
+			gsm_queue(gsm);
+		else
+			gsm->bad_size++;
 		break;
 	default:
 		pr_debug("%s: unhandled state: %d\n", __func__, gsm->state);
@@ -2024,11 +2018,24 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 static void gsm1_receive(struct gsm_mux *gsm, unsigned char c)
 {
 	if (c == GSM1_SOF) {
-		/* EOF is only valid in frame if we have got to the data state
-		   and received at least one byte (the FCS) */
-		if (gsm->state == GSM_DATA && gsm->count) {
-			/* Extract the FCS */
+		/* EOF is only valid in frame if we have got to the data state */
+		if (gsm->state == GSM_DATA) {
+			if (gsm->count < 1) {
+				/* Missing FSC */
+				gsm->malformed++;
+				gsm->state = GSM_START;
+				return;
+			}
+			/* Remove the FCS from data */
 			gsm->count--;
+			if ((gsm->control & ~PF) != UIH) {
+				/* Calculate final FCS for UI frames over all
+				 * data but FCS
+				 */
+				gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf,
+							     gsm->count);
+			}
+			/* Add the FCS itself to test against GOOD_FCS */
 			gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->buf[gsm->count]);
 			gsm->len = gsm->count;
 			gsm_queue(gsm);

