Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4A51FBB28
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgFPQRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730928AbgFPPj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D759C20B1F;
        Tue, 16 Jun 2020 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321967;
        bh=tGu9iAfYSAIXV7Z+xfgVDc5pMnkYJe7lF1Y+08DJt5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwG5SGDUhN7Lpl4PEV0JfpQVEh0FF9Q+ovPxxv6xsSXUv6tpeSRd/JDb3jU3jQZQF
         m2KX069dbfNk+y3RbD+S6+Si4e9CQU1OF2V1+H1T9XYEb2I2fyP3nMlJmKlwfsv7Lm
         znlcp6/ZAUQd9v9kLjPyzN/T1tyE4YnrWz5GHtac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/134] firmware: imx: scu: Fix corruption of header
Date:   Tue, 16 Jun 2020 17:34:29 +0200
Message-Id: <20200616153104.851059822@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Franck LENORMAND <franck.lenormand@nxp.com>

[ Upstream commit f5f27b79eab80de0287c243a22169e4876b08d5e ]

The header of the message to send can be changed if the
response is longer than the request:
 - 1st word, the header is sent
 - the remaining words of the message are sent
 - the response is received asynchronously during the
   execution of the loop, changing the size field in
   the header
 - the for loop test the termination condition using
   the corrupted header

It is the case for the API build_info which has just a
header as request but 3 words in response.

This issue is fixed storing the header locally instead of
using a pointer on it.

Fixes: edbee095fafb (firmware: imx: add SCU firmware driver support)

Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index a92adb9fdad6..e48d971ffb61 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -158,7 +158,7 @@ static void imx_scu_rx_callback(struct mbox_client *c, void *msg)
 
 static int imx_scu_ipc_write(struct imx_sc_ipc *sc_ipc, void *msg)
 {
-	struct imx_sc_rpc_msg *hdr = msg;
+	struct imx_sc_rpc_msg hdr = *(struct imx_sc_rpc_msg *)msg;
 	struct imx_sc_chan *sc_chan;
 	u32 *data = msg;
 	int ret;
@@ -166,13 +166,13 @@ static int imx_scu_ipc_write(struct imx_sc_ipc *sc_ipc, void *msg)
 	int i;
 
 	/* Check size */
-	if (hdr->size > IMX_SC_RPC_MAX_MSG)
+	if (hdr.size > IMX_SC_RPC_MAX_MSG)
 		return -EINVAL;
 
-	dev_dbg(sc_ipc->dev, "RPC SVC %u FUNC %u SIZE %u\n", hdr->svc,
-		hdr->func, hdr->size);
+	dev_dbg(sc_ipc->dev, "RPC SVC %u FUNC %u SIZE %u\n", hdr.svc,
+		hdr.func, hdr.size);
 
-	size = sc_ipc->fast_ipc ? 1 : hdr->size;
+	size = sc_ipc->fast_ipc ? 1 : hdr.size;
 	for (i = 0; i < size; i++) {
 		sc_chan = &sc_ipc->chans[i % 4];
 
-- 
2.25.1



