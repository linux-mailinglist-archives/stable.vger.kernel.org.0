Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C318917FDE3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgCJNa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgCJMuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:50:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689D02468D;
        Tue, 10 Mar 2020 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844620;
        bh=qbf21E2IavgVSLI2y2C0+80T2s+pZGUkJ98c2nWXwj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6NSao1tRWylG7d5+vQfG5NLoX/yNwwnV8sAZJ1ffRQMc7XApikaUXpP6bU9Mo0Gu
         BI/CfFvSt/xTPGinDrqQF2Xh17IZ8WTGQy3W6ArFoIo2E+NZo2ltAx2mfNj1wxGQCg
         wr0YwTsDjmpYrV3NaQaXjxbRq/PPNvPXIRNkcVoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        ": Oleksij Rempel" <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 057/168] firmware: imx: scu: Ensure sequential TX
Date:   Tue, 10 Mar 2020 13:38:23 +0100
Message-Id: <20200310123641.102643598@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

commit 26d0fba29c96241de8a9d16f045b1de49875884c upstream.

SCU requires that all messages words are written sequentially but linux MU
driver implements multiple independent channels for each register so ordering
between different channels must be ensured by SCU API interface.

Wait for tx_done before every send to ensure that no queueing happens at the
mailbox channel level.

Fixes: edbee095fafb ("firmware: imx: add SCU firmware driver support")
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by:: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/imx/imx-scu.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -29,6 +29,7 @@ struct imx_sc_chan {
 	struct mbox_client cl;
 	struct mbox_chan *ch;
 	int idx;
+	struct completion tx_done;
 };
 
 struct imx_sc_ipc {
@@ -100,6 +101,14 @@ int imx_scu_get_handle(struct imx_sc_ipc
 }
 EXPORT_SYMBOL(imx_scu_get_handle);
 
+/* Callback called when the word of a message is ack-ed, eg read by SCU */
+static void imx_scu_tx_done(struct mbox_client *cl, void *mssg, int r)
+{
+	struct imx_sc_chan *sc_chan = container_of(cl, struct imx_sc_chan, cl);
+
+	complete(&sc_chan->tx_done);
+}
+
 static void imx_scu_rx_callback(struct mbox_client *c, void *msg)
 {
 	struct imx_sc_chan *sc_chan = container_of(c, struct imx_sc_chan, cl);
@@ -143,6 +152,19 @@ static int imx_scu_ipc_write(struct imx_
 
 	for (i = 0; i < hdr->size; i++) {
 		sc_chan = &sc_ipc->chans[i % 4];
+
+		/*
+		 * SCU requires that all messages words are written
+		 * sequentially but linux MU driver implements multiple
+		 * independent channels for each register so ordering between
+		 * different channels must be ensured by SCU API interface.
+		 *
+		 * Wait for tx_done before every send to ensure that no
+		 * queueing happens at the mailbox channel level.
+		 */
+		wait_for_completion(&sc_chan->tx_done);
+		reinit_completion(&sc_chan->tx_done);
+
 		ret = mbox_send_message(sc_chan->ch, &data[i]);
 		if (ret < 0)
 			return ret;
@@ -225,6 +247,11 @@ static int imx_scu_probe(struct platform
 		cl->knows_txdone = true;
 		cl->rx_callback = imx_scu_rx_callback;
 
+		/* Initial tx_done completion as "done" */
+		cl->tx_done = imx_scu_tx_done;
+		init_completion(&sc_chan->tx_done);
+		complete(&sc_chan->tx_done);
+
 		sc_chan->sc_ipc = sc_ipc;
 		sc_chan->idx = i % 4;
 		sc_chan->ch = mbox_request_channel_byname(cl, chan_name);


