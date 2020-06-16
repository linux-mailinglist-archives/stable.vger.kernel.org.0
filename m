Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A131FBB08
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgFPPko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbgFPPkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:40:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A9C2082F;
        Tue, 16 Jun 2020 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322040;
        bh=mKEYBtnv5zZJdxSYEKrRd88IX5ReyrRvQNXH36wKkQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+NyoJ5OIimIWAmwlc/2DtPo5J31Bl2APpmIlV0gUnvUpNe0L1TQMNhVtHhSUAKHN
         FVTYczqhOKmR1gZyJGY3jO7G1tBB3TBcX7g1aZDm4jCYKGRikZvICdX75YyW303n6x
         mELqSXtwcn2fgDinlxkLAsauNGSFi9uQjBym7L94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/134] firmware: imx: warn on unexpected RX
Date:   Tue, 16 Jun 2020 17:34:27 +0200
Message-Id: <20200616153104.752713740@linuxfoundation.org>
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

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit cf0fd404455ce13850cc15423a3c2958933de384 ]

The imx_scu_call_rpc function returns the result inside the
same "msg" struct containing the transmitted message. This is
implemented by holding a pointer to msg (which is usually on the stack)
in sc_imx_rpc and writing to it from imx_scu_rx_callback.

This means that if the have_resp parameter is incorrect or SCU sends an
unexpected response for any reason the most likely result is kernel stack
corruption.

Fix this by only setting sc_imx_rpc.msg for the duration of the
imx_scu_call_rpc call and warning in imx_scu_rx_callback if unset.

Print the unexpected response data to help debugging.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Acked-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index 35a5f8f8eea5..6c6ac47d3c64 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -116,6 +116,12 @@ static void imx_scu_rx_callback(struct mbox_client *c, void *msg)
 	struct imx_sc_rpc_msg *hdr;
 	u32 *data = msg;
 
+	if (!sc_ipc->msg) {
+		dev_warn(sc_ipc->dev, "unexpected rx idx %d 0x%08x, ignore!\n",
+				sc_chan->idx, *data);
+		return;
+	}
+
 	if (sc_chan->idx == 0) {
 		hdr = msg;
 		sc_ipc->rx_size = hdr->size;
@@ -187,7 +193,8 @@ int imx_scu_call_rpc(struct imx_sc_ipc *sc_ipc, void *msg, bool have_resp)
 	mutex_lock(&sc_ipc->lock);
 	reinit_completion(&sc_ipc->done);
 
-	sc_ipc->msg = msg;
+	if (have_resp)
+		sc_ipc->msg = msg;
 	sc_ipc->count = 0;
 	ret = imx_scu_ipc_write(sc_ipc, msg);
 	if (ret < 0) {
@@ -209,6 +216,7 @@ int imx_scu_call_rpc(struct imx_sc_ipc *sc_ipc, void *msg, bool have_resp)
 	}
 
 out:
+	sc_ipc->msg = NULL;
 	mutex_unlock(&sc_ipc->lock);
 
 	dev_dbg(sc_ipc->dev, "RPC SVC done\n");
-- 
2.25.1



