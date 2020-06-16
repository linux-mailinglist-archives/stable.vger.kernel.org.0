Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA91FBA1C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbgFPPpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731227AbgFPPpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:45:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9246B20E65;
        Tue, 16 Jun 2020 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322350;
        bh=SGKlEm4akjwRBtp7JgMewDQ7F6ow21dNEkrsU9VG3ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nc3MBceGENV6mGC/Gz1oLCL42dcFSew5PP7MAa+NScivKoLvThmsTmX0zplIloaof
         tkZQwrHC5pf6rP9K/DWT7q7JrWi6Tec2M5YRDO9g3jxygSqwdig3xSta1pCdjlizh+
         nr1iLTkD+zg3v5SRJW0ySMCqo79mIFhx0eEd6Pt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 098/163] firmware: imx: scu: Fix corruption of header
Date:   Tue, 16 Jun 2020 17:34:32 +0200
Message-Id: <20200616153111.522289162@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
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
index e94a5585b698..b3da2e193ad2 100644
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



