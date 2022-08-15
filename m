Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0988F5939FD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242154AbiHOT3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345179AbiHOT1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C719B5C9D7;
        Mon, 15 Aug 2022 11:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B529B81082;
        Mon, 15 Aug 2022 18:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FC7C433D6;
        Mon, 15 Aug 2022 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589021;
        bh=MLtZtshAMiBLV7e0brGdDAHW+5VrH3xIHxwwvHxraHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttEQ3ZQqCxRrGSI+998vb977brIWSh02BN838Zb67cx1GMlVLKgQeU1ejJdArOj/d
         95FXXFZSnqWeRs0bKEIrTE9w9sg4V7ek7mTthGUCLNWRigJq+vtfL505lmensHo2+h
         sFvTR4LgoTV7jq4PBX7NNnOVB2j0WT1IwzPGGmbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 587/779] tty: n_gsm: fix non flow control frames during mux flow off
Date:   Mon, 15 Aug 2022 20:03:51 +0200
Message-Id: <20220815180402.417130818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit bec0224816d19abe4fe503586d16d51890540615 ]

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.4.6.3.6 states that FCoff stops the
transmission on all channels except the control channel. This is already
implemented in gsm_data_kick(). However, chapter 5.4.8.1 explains that this
shall result in the same behavior as software flow control on the ldisc in
advanced option mode. That means only flow control frames shall be sent
during flow off. The current implementation does not consider this case.

Change gsm_data_kick() to send only flow control frames if constipated to
abide the standard. gsm_read_ea_val() and gsm_is_flow_ctrl_msg() are
introduced as helper functions for this.
It is planned to use gsm_read_ea_val() in later code cleanups for other
functions, too.

Fixes: c01af4fec2c8 ("n_gsm : Flow control handling in Mux driver")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-5-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 54 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 271efa7ae793..56a3466acfc6 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -425,6 +425,27 @@ static int gsm_read_ea(unsigned int *val, u8 c)
 	return c & EA;
 }
 
+/**
+ *	gsm_read_ea_val	-	read a value until EA
+ *	@val: variable holding value
+ *	@data: buffer of data
+ *	@dlen: length of data
+ *
+ *	Processes an EA value. Updates the passed variable and
+ *	returns the processed data length.
+ */
+static unsigned int gsm_read_ea_val(unsigned int *val, const u8 *data, int dlen)
+{
+	unsigned int len = 0;
+
+	for (; dlen > 0; dlen--) {
+		len++;
+		if (gsm_read_ea(val, *data++))
+			break;
+	}
+	return len;
+}
+
 /**
  *	gsm_encode_modem	-	encode modem data bits
  *	@dlci: DLCI to encode from
@@ -746,6 +767,37 @@ static struct gsm_msg *gsm_data_alloc(struct gsm_mux *gsm, u8 addr, int len,
 	return m;
 }
 
+/**
+ *	gsm_is_flow_ctrl_msg	-	checks if flow control message
+ *	@msg: message to check
+ *
+ *	Returns true if the given message is a flow control command of the
+ *	control channel. False is returned in any other case.
+ */
+static bool gsm_is_flow_ctrl_msg(struct gsm_msg *msg)
+{
+	unsigned int cmd;
+
+	if (msg->addr > 0)
+		return false;
+
+	switch (msg->ctrl & ~PF) {
+	case UI:
+	case UIH:
+		cmd = 0;
+		if (gsm_read_ea_val(&cmd, msg->data + 2, msg->len - 2) < 1)
+			break;
+		switch (cmd & ~PF) {
+		case CMD_FCOFF:
+		case CMD_FCON:
+			return true;
+		}
+		break;
+	}
+
+	return false;
+}
+
 /**
  *	gsm_data_kick		-	poke the queue
  *	@gsm: GSM Mux
@@ -765,7 +817,7 @@ static void gsm_data_kick(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 	int len;
 
 	list_for_each_entry_safe(msg, nmsg, &gsm->tx_list, list) {
-		if (gsm->constipated && msg->addr)
+		if (gsm->constipated && !gsm_is_flow_ctrl_msg(msg))
 			continue;
 		if (gsm->encoding != 0) {
 			gsm->txframe[0] = GSM1_SOF;
-- 
2.35.1



