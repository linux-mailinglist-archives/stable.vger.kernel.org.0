Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8611DF13
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 09:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbfLMIIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 03:08:05 -0500
Received: from www.linuxtv.org ([130.149.80.248]:53998 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfLMIIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 03:08:05 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iffzD-00BRQK-33; Fri, 13 Dec 2019 08:07:43 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 13 Dec 2019 08:02:39 +0000
Subject: [git:media_tree/master] media: cec: avoid decrementing transmit_queue_sz if it is 0
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iffzD-00BRQK-33@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cec: avoid decrementing transmit_queue_sz if it is 0
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Sat Dec 7 23:48:09 2019 +0100

WARN if transmit_queue_sz is 0 but do not decrement it.
The CEC adapter will become unresponsive if it goes below
0 since then it thinks there are 4 billion messages in the
queue.

Obviously this should not happen, but a driver bug could
cause this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.12 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/cec/cec-adap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

---

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
