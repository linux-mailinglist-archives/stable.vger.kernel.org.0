Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B14156A70
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBINFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:05:32 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43681 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:05:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 787D721E95;
        Sun,  9 Feb 2020 08:05:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:05:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=W+8uIL
        vPaZrMIi3EDU/RyaWTkJ1TK3KGpCBWgZBlFVE=; b=w1iZrE9h8ha0TAOUSxzXqn
        S0LTZez345eQXr1v3qyKMdl0i8y8vDu6clPp1NwMzCmZhpFU44WOvgRf4ynn2nmH
        hPALJlM3cnVSXcA3ix06dP/ZKuoB3gooYYejkhZhtSJCXq51qce8Qo95F5Rd0EbV
        UGUnTU/1XBTA61yoxu2IJ4VtKEP5GU16TTwxaoarrpczyTVCr7Ch1QnPFlbHSOtA
        qms5m0HArWu3OqzSujwXJs6lcHgfpM2OllySAkCnmVshtI5zgDSg3cZWqoQTsnjI
        BdzoWFBuQEQoTi9aguo/Lz8RzehKB9wXvwK9fNOJt/aQ5UFxWAqe3oe2Ikk+qe8g
        ==
X-ME-Sender: <xms:mwNAXgvW01GyozfxyCfWncQgM2OuAyNgyrBatgIlbNdJf4gZ-fncnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvddtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mwNAXhv6yKYNuKcs4J7P2bioVDtsC05und1WlQUp-6YOK-iZZ40hEA>
    <xmx:mwNAXmys1VDZgfmftFn6oSxp7fJvw0qtmuERwhY3wIf-22nnN5ecnA>
    <xmx:mwNAXnh7cg4GnHzVHRk-Fgby4EBly9DoX7JhInvRYdDlqafjm7kGHg>
    <xmx:mwNAXihDirc2DeqqHnv5v5COgC_H4vBmDEFrwVkZjd5LnV6493izBg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11AFD3060272;
        Sun,  9 Feb 2020 08:05:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: cec: avoid decrementing transmit_queue_sz if it is 0" failed to apply to 4.14-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:47:18 +0100
Message-ID: <158124883828185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

