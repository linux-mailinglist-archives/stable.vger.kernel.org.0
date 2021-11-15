Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F6445126B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347350AbhKOTjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245007AbhKOTSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4951C63435;
        Mon, 15 Nov 2021 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000812;
        bh=yhwfpwdu/KnbovWSFDg1gKZqmTndNAL9H7hSu/+Bnf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xr1FGG3rVMW+Jt2YSY9rnDToBtimyiX9po2VvRhWPXVFvYvuzKFLyLfNxMZvYlP+Z
         W4bfOny3bO16ZR9W8P8SagrSNhWN9Tkjp1Kj0fPHfaYtF7/rvFViylohgt3mipyuiY
         5490Uqp3bXVVMKLTk0kv9h4Q3khI2evJHW0N8SYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.14 801/849] dmaengine: ti: k3-udma: Set r/tchan or rflow to NULL if request fail
Date:   Mon, 15 Nov 2021 18:04:44 +0100
Message-Id: <20211115165447.329138823@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit eb91224e47ec33a0a32c9be0ec0fcb3433e555fd upstream.

udma_get_*() checks if rchan/tchan/rflow is already allocated by checking
if it has a NON NULL value. For the error cases, rchan/tchan/rflow will
have error value and udma_get_*() considers this as already allocated
(PASS) since the error values are NON NULL. This results in NULL pointer
dereference error while de-referencing rchan/tchan/rflow.

Reset the value of rchan/tchan/rflow to NULL if a channel request fails.

CC: stable@vger.kernel.org
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20211031032411.27235-3-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -1380,6 +1380,7 @@ static int bcdma_get_bchan(struct udma_c
 static int udma_get_tchan(struct udma_chan *uc)
 {
 	struct udma_dev *ud = uc->ud;
+	int ret;
 
 	if (uc->tchan) {
 		dev_dbg(ud->dev, "chan%d: already have tchan%d allocated\n",
@@ -1394,8 +1395,11 @@ static int udma_get_tchan(struct udma_ch
 	 */
 	uc->tchan = __udma_reserve_tchan(ud, uc->config.channel_tpl,
 					 uc->config.mapped_channel_id);
-	if (IS_ERR(uc->tchan))
-		return PTR_ERR(uc->tchan);
+	if (IS_ERR(uc->tchan)) {
+		ret = PTR_ERR(uc->tchan);
+		uc->tchan = NULL;
+		return ret;
+	}
 
 	if (ud->tflow_cnt) {
 		int tflow_id;
@@ -1425,6 +1429,7 @@ static int udma_get_tchan(struct udma_ch
 static int udma_get_rchan(struct udma_chan *uc)
 {
 	struct udma_dev *ud = uc->ud;
+	int ret;
 
 	if (uc->rchan) {
 		dev_dbg(ud->dev, "chan%d: already have rchan%d allocated\n",
@@ -1439,8 +1444,13 @@ static int udma_get_rchan(struct udma_ch
 	 */
 	uc->rchan = __udma_reserve_rchan(ud, uc->config.channel_tpl,
 					 uc->config.mapped_channel_id);
+	if (IS_ERR(uc->rchan)) {
+		ret = PTR_ERR(uc->rchan);
+		uc->rchan = NULL;
+		return ret;
+	}
 
-	return PTR_ERR_OR_ZERO(uc->rchan);
+	return 0;
 }
 
 static int udma_get_chan_pair(struct udma_chan *uc)
@@ -1494,6 +1504,7 @@ static int udma_get_chan_pair(struct udm
 static int udma_get_rflow(struct udma_chan *uc, int flow_id)
 {
 	struct udma_dev *ud = uc->ud;
+	int ret;
 
 	if (!uc->rchan) {
 		dev_err(ud->dev, "chan%d: does not have rchan??\n", uc->id);
@@ -1507,8 +1518,13 @@ static int udma_get_rflow(struct udma_ch
 	}
 
 	uc->rflow = __udma_get_rflow(ud, flow_id);
+	if (IS_ERR(uc->rflow)) {
+		ret = PTR_ERR(uc->rflow);
+		uc->rflow = NULL;
+		return ret;
+	}
 
-	return PTR_ERR_OR_ZERO(uc->rflow);
+	return 0;
 }
 
 static void bcdma_put_bchan(struct udma_chan *uc)


