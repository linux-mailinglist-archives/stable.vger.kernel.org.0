Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824395216A4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbiEJNQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbiEJNQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:16:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613633B28E;
        Tue, 10 May 2022 06:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2307C615C5;
        Tue, 10 May 2022 13:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AD0C385A6;
        Tue, 10 May 2022 13:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188337;
        bh=8JvN64c//PXkttIcM+5aexIhz/lgA8OH0a3ITB3MlFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKj4OoI9wGVD5e3KkDs2DwaGvdWVBanAZytdRtiDljrPlQs1DcHj2T9xG35beKgYr
         g/0FrnIoqdjdtdkEWW+aiaVT8fpQ0+NgdxRx7oiG70+2zhLkGU7Y9AfDnCu3UVBwd4
         Camb1Hgo62kbaBrmSliWdoNLnQlj5jivEL+O629Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 4.9 41/66] tty: n_gsm: fix wrong command frame length field encoding
Date:   Tue, 10 May 2022 15:07:31 +0200
Message-Id: <20220510130730.972589341@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
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

commit 398867f59f956985f4c324f173eff7b946e14bd8 upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.4.6.1 states that each command frame shall
be made up from type, length and value. Looking for example in chapter
5.4.6.3.5 at the description for the encoding of a flow control on command
it becomes obvious, that the type and length field is always present
whereas the value may be zero bytes long. The current implementation omits
the length field if the value is not present. This is wrong.
Correct this by always sending the length in gsm_control_transmit().
So far only the modem status command (MSC) has included a value and encoded
its length directly. Therefore, also change gsmtty_modem_update().

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-12-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1318,11 +1318,12 @@ static void gsm_control_response(struct
 
 static void gsm_control_transmit(struct gsm_mux *gsm, struct gsm_control *ctrl)
 {
-	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 1, gsm->ftype);
+	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 2, gsm->ftype);
 	if (msg == NULL)
 		return;
-	msg->data[0] = (ctrl->cmd << 1) | 2 | EA;	/* command */
-	memcpy(msg->data + 1, ctrl->data, ctrl->len);
+	msg->data[0] = (ctrl->cmd << 1) | CR | EA;	/* command */
+	msg->data[1] = (ctrl->len << 1) | EA;
+	memcpy(msg->data + 2, ctrl->data, ctrl->len);
 	gsm_data_queue(gsm->dlci[0], msg);
 }
 
@@ -2864,19 +2865,17 @@ static struct tty_ldisc_ops tty_ldisc_pa
 
 static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk)
 {
-	u8 modembits[5];
+	u8 modembits[3];
 	struct gsm_control *ctrl;
 	int len = 2;
 
-	if (brk)
+	modembits[0] = (dlci->addr << 2) | 2 | EA;  /* DLCI, Valid, EA */
+	modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
+	if (brk) {
+		modembits[2] = (brk << 4) | 2 | EA; /* Length, Break, EA */
 		len++;
-
-	modembits[0] = len << 1 | EA;		/* Data bytes */
-	modembits[1] = dlci->addr << 2 | 3;	/* DLCI, EA, 1 */
-	modembits[2] = gsm_encode_modem(dlci) << 1 | EA;
-	if (brk)
-		modembits[3] = brk << 4 | 2 | EA;	/* Valid, EA */
-	ctrl = gsm_control_send(dlci->gsm, CMD_MSC, modembits, len + 1);
+	}
+	ctrl = gsm_control_send(dlci->gsm, CMD_MSC, modembits, len);
 	if (ctrl == NULL)
 		return -ENOMEM;
 	return gsm_control_wait(dlci->gsm, ctrl);


