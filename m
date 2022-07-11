Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEC356FD20
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiGKJvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiGKJuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9584323BF8;
        Mon, 11 Jul 2022 02:24:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58619B80E7A;
        Mon, 11 Jul 2022 09:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DECC34115;
        Mon, 11 Jul 2022 09:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531480;
        bh=U0whqmfMtKkmTNWHFkRmR4u61sCo8ezj3001BZTs4fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhdnLMmPkGIRd93HCPSlKIWPnUiqVg54w5NH1smcHz+5Oa6oRnYJ5NA+gCwG7qYWe
         vgg7SlWjpCZwKqkM8CFofTYsXRspAUt9qVn1gX0LUIP/b3nJPPRV7Fcpb6imvkbxsy
         pRiLOan2xRki0UPAdt6vE3tkHw/mZI7PiZ1HQAIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/230] tty: n_gsm: Save dlci address open status when config requester
Date:   Mon, 11 Jul 2022 11:06:15 +0200
Message-Id: <20220711090607.441445257@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>

[ Upstream commit 0b91b5332368f2fb0c3e5cfebc6aff9e167acd8b ]

When n_gsm config "initiator=0",as requester ,receive SABM frame,n_gsm
register gsmtty dev,and save dlci open address status,if receive DLC0
DISC or CLD frame,it can unregister the gsmtty dev by saving dlci address.

Signed-off-by: Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>
Link: https://lore.kernel.org/r/1629461872-26965-8-git-send-email-zhenguo6858@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 57 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 91ce8e6e889a..3038e5631be5 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -274,6 +274,10 @@ static DEFINE_SPINLOCK(gsm_mux_lock);
 
 static struct tty_driver *gsm_tty_driver;
 
+/* Save dlci open address */
+static int addr_open[256] = { 0 };
+/* Save dlci open count */
+static int addr_cnt;
 /*
  *	This section of the driver logic implements the GSM encodings
  *	both the basic and the 'advanced'. Reliable transport is not
@@ -1191,6 +1195,7 @@ static void gsm_control_rls(struct gsm_mux *gsm, const u8 *data, int clen)
 }
 
 static void gsm_dlci_begin_close(struct gsm_dlci *dlci);
+static void gsm_dlci_close(struct gsm_dlci *dlci);
 
 /**
  *	gsm_control_message	-	DLCI 0 control processing
@@ -1209,15 +1214,28 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 {
 	u8 buf[1];
 	unsigned long flags;
+	struct gsm_dlci *dlci;
+	int i;
+	int address;
 
 	switch (command) {
 	case CMD_CLD: {
-		struct gsm_dlci *dlci = gsm->dlci[0];
+		if (addr_cnt > 0) {
+			for (i = 0; i < addr_cnt; i++) {
+				address = addr_open[i];
+				dlci = gsm->dlci[address];
+				gsm_dlci_close(dlci);
+				addr_open[i] = 0;
+			}
+		}
 		/* Modem wishes to close down */
+		dlci = gsm->dlci[0];
 		if (dlci) {
 			dlci->dead = true;
 			gsm->dead = true;
-			gsm_dlci_begin_close(dlci);
+			gsm_dlci_close(dlci);
+			addr_cnt = 0;
+			gsm_response(gsm, 0, UA|PF);
 		}
 		}
 		break;
@@ -1780,6 +1798,7 @@ static void gsm_queue(struct gsm_mux *gsm)
 	struct gsm_dlci *dlci;
 	u8 cr;
 	int address;
+	int i, j, k, address_tmp;
 	/* We have to sneak a look at the packet body to do the FCS.
 	   A somewhat layering violation in the spec */
 
@@ -1822,6 +1841,11 @@ static void gsm_queue(struct gsm_mux *gsm)
 		else {
 			gsm_response(gsm, address, UA|PF);
 			gsm_dlci_open(dlci);
+			/* Save dlci open address */
+			if (address) {
+				addr_open[addr_cnt] = address;
+				addr_cnt++;
+			}
 		}
 		break;
 	case DISC|PF:
@@ -1832,8 +1856,33 @@ static void gsm_queue(struct gsm_mux *gsm)
 			return;
 		}
 		/* Real close complete */
-		gsm_response(gsm, address, UA|PF);
-		gsm_dlci_close(dlci);
+		if (!address) {
+			if (addr_cnt > 0) {
+				for (i = 0; i < addr_cnt; i++) {
+					address = addr_open[i];
+					dlci = gsm->dlci[address];
+					gsm_dlci_close(dlci);
+					addr_open[i] = 0;
+				}
+			}
+			dlci = gsm->dlci[0];
+			gsm_dlci_close(dlci);
+			addr_cnt = 0;
+			gsm_response(gsm, 0, UA|PF);
+		} else {
+			gsm_response(gsm, address, UA|PF);
+			gsm_dlci_close(dlci);
+			/* clear dlci address */
+			for (j = 0; j < addr_cnt; j++) {
+				address_tmp = addr_open[j];
+				if (address_tmp == address) {
+					for (k = j; k < addr_cnt; k++)
+						addr_open[k] = addr_open[k+1];
+				addr_cnt--;
+				break;
+				}
+			}
+		}
 		break;
 	case UA|PF:
 		if (cr == 0 || dlci == NULL)
-- 
2.35.1



