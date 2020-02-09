Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD0E156A6C
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgBINFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:05:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36949 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:05:04 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E8493215B2;
        Sun,  9 Feb 2020 08:05:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sodmvU
        l3K4q+dishWv/dhdz5zq0sTdBajZVix9FP6Yk=; b=yhYSoaaz5yVlsgVXN4Maco
        TrN/FPDy0rQZMgn0WI5qmiAV7ti+UlbEq8oWhT3ZB/uQbTfggE3E2FcICzyX4Pk1
        oJ7YkIwaplgA23Isu5k3OOEAM4botVE95EYkCgyFIl+72uq69WOovSdcN3hOOMSb
        s4xA8/kI4lcjD+86m82/HVU8j8sBkhDgR2ZpILlO5Uin5TOgz4m5TJzJ7OkbnA6b
        ftRof842m53n34cznK/NrTNev46XAZ23esGF26tJBMvG7C3Km4hDYCN9rnNPZK0X
        7IehUKFZzPLtvm4z38BcJhNBTwEG0/6ss9osM/8LA2EI/usMlIYFWUnRDt6sUU9g
        ==
X-ME-Sender: <xms:fgNAXnbfN9MSpaV-JatxrUjwYjzZgWnAz7NuPnMvDDlQ97cq6DiTng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudejne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fgNAXllEIUZHSIVX-CtuUR8-jjHAYcRUWt5Kzvd08DSP2uRtudhZHA>
    <xmx:fgNAXsp6z6wwj37G36c6p-D5H6b7KZhRx0VWuIqAz1THbguwZVM8uw>
    <xmx:fgNAXnD9MSMt0LPlpz9i5-RseFW_bhtLKN0KF6R1Al5GYDEKv3S_VA>
    <xmx:fgNAXgMmyJ-jqKZJabkicsxiiyksLAvipPzx-ZBQ0Q7w9dQBl9E3KA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id B930F3060272;
        Sun,  9 Feb 2020 08:05:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: cec: avoid decrementing transmit_queue_sz if it is 0" failed to apply to 5.4-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:47:15 +0100
Message-ID: <158124883516138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4be77174c3fafc450527a0c383bb2034d2db6a2d Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date: Sat, 7 Dec 2019 23:48:09 +0100
Subject: [PATCH] media: cec: avoid decrementing transmit_queue_sz if it is 0

WARN if transmit_queue_sz is 0 but do not decrement it.
The CEC adapter will become unresponsive if it goes below
0 since then it thinks there are 4 billion messages in the
queue.

Obviously this should not happen, but a driver bug could
cause this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.12 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index e90c30dac68b..1060e633b623 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -380,7 +380,8 @@ static void cec_data_cancel(struct cec_data *data, u8 tx_status)
 	} else {
 		list_del_init(&data->list);
 		if (!(data->msg.tx_status & CEC_TX_STATUS_OK))
-			data->adap->transmit_queue_sz--;
+			if (!WARN_ON(!data->adap->transmit_queue_sz))
+				data->adap->transmit_queue_sz--;
 	}
 
 	if (data->msg.tx_status & CEC_TX_STATUS_OK) {
@@ -432,6 +433,14 @@ static void cec_flush(struct cec_adapter *adap)
 		 * need to do anything special in that case.
 		 */
 	}
+	/*
+	 * If something went wrong and this counter isn't what it should
+	 * be, then this will reset it back to 0. Warn if it is not 0,
+	 * since it indicates a bug, either in this framework or in a
+	 * CEC driver.
+	 */
+	if (WARN_ON(adap->transmit_queue_sz))
+		adap->transmit_queue_sz = 0;
 }
 
 /*
@@ -522,7 +531,8 @@ int cec_thread_func(void *_adap)
 		data = list_first_entry(&adap->transmit_queue,
 					struct cec_data, list);
 		list_del_init(&data->list);
-		adap->transmit_queue_sz--;
+		if (!WARN_ON(!data->adap->transmit_queue_sz))
+			adap->transmit_queue_sz--;
 
 		/* Make this the current transmitting message */
 		adap->transmitting = data;

