Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59545939A7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiHOT2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344978AbiHOT1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39EE5B7B4;
        Mon, 15 Aug 2022 11:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04DA61029;
        Mon, 15 Aug 2022 18:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BB3C433D6;
        Mon, 15 Aug 2022 18:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589002;
        bh=AhmeuQUzMoaGbxiUtk8bPJmXxcVzqBhuEkgrIDVu3A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJrzIRNzRXO4PkKaQoSBejKgIh1jdXT1SxBNMbmM7b7i1jnEA45t3JTrTU4407V/7
         X8iiKRpnA2aKcS/R5TNQVVJVfJvhH4D+XFeygyzk5y6IZsWrzEI+FdCFH1GtD1/JpF
         tYbVyu1DRZGdYxPSscBy+xX1FX0xMOKNFSFbz1D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 582/779] tty: n_gsm: Delete gsmtty open SABM frame when config requester
Date:   Mon, 15 Aug 2022 20:03:46 +0200
Message-Id: <20220815180402.212451203@linuxfoundation.org>
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

From: Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>

[ Upstream commit cbff2b32516881bef30bbebf413d1b49495bab1d ]

When n_gsm config "initiator=0",as requester ,it doesn't need to
send SABM frame data during gsmtty open.

Example,when gsmtty open,it will send SABM frame.for initiator,it
maybe not want to receive the frame.

[   88.410426] c1 gsmld_output: 00000000: f9 07 3f 01 de f9
[   88.420839] c1 --> 1) R: SABM(F)

Signed-off-by: Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>
Link: https://lore.kernel.org/r/1629461872-26965-6-git-send-email-zhenguo6858@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 4946a241e323..f86c5ebfcf91 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -3214,6 +3214,7 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	struct tty_port *port = &dlci->port;
+	struct gsm_mux *gsm = dlci->gsm;
 
 	port->count++;
 	tty_port_tty_set(port, tty);
@@ -3223,7 +3224,8 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 	   a DM straight back. This is ok as that will have caused a hangup */
 	tty_port_set_initialized(port, 1);
 	/* Start sending off SABM messages */
-	gsm_dlci_begin_open(dlci);
+	if (gsm->initiator)
+		gsm_dlci_begin_open(dlci);
 	/* And wait for virtual carrier */
 	return tty_port_block_til_ready(port, tty, filp);
 }
-- 
2.35.1



