Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2227C51A9CD
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357489AbiEDRTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357996AbiEDRPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671B4562CA;
        Wed,  4 May 2022 09:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 066A2B827A9;
        Wed,  4 May 2022 16:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11DBC385A4;
        Wed,  4 May 2022 16:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683552;
        bh=w2YTc2iaXndlFLz3pgZAgPT3qjdp5aB+pN1Z3fW5oY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8wBkyU9WOKwzHfDiIqO37BL56zJEc26weUGppMCHCQ+aH4oagss+DvQ01905omAa
         7td71Zeg1iSq48Lfprm2dYNTJeZ89i+yeP5iG71UJ1nyZHdl5KiwuV0JgkwuTakb9Q
         /+OdW2ZZJBY2mK1Wk8BFynsaoUEeK6Jm5NBvJpGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 206/225] tty: n_gsm: fix frame reception handling
Date:   Wed,  4 May 2022 18:47:24 +0200
Message-Id: <20220504153128.466668340@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Daniel Starke <daniel.starke@siemens.com>

commit 7a0e4b1733b635026a87c023f6d703faf0095e39 upstream.

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
---
 drivers/tty/n_gsm.c |   53 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -219,7 +219,6 @@ struct gsm_mux {
 	int encoding;
 	u8 control;
 	u8 fcs;
-	u8 received_fcs;
 	u8 *txframe;			/* TX framing buffer */
 
 	/* Method for the receiver side */
@@ -1794,18 +1793,7 @@ static void gsm_queue(struct gsm_mux *gs
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
@@ -1993,19 +1981,25 @@ static void gsm0_receive(struct gsm_mux
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
@@ -2024,11 +2018,24 @@ static void gsm0_receive(struct gsm_mux
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


