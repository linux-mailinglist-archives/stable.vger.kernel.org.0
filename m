Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94047133215
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgAGVHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbgAGVHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:07:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0300C208C4;
        Tue,  7 Jan 2020 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431226;
        bh=108ARGMymmmXQl2feId0lFuMKZ3iOMgH138/9+MjxAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6zXMfTP4VwGNDjnptmMzfTTiGtbTbqFzExa1GHDPhgtNGm9DTlOwPRodjWFnCFZN
         2mzeYTtf/bpXvLxPX9MZz2d2CLl1yf2d1dAAOj+wm2HidJgr9aK7aNkBwESyB5B+Ss
         YRFDDGvzgzC6rhNg8Pla3SAklNKc1kT7gDCcCrJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 050/115] media: cec: avoid decrementing transmit_queue_sz if it is 0
Date:   Tue,  7 Jan 2020 21:54:20 +0100
Message-Id: <20200107205302.473698043@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 95c29d46ab2a517e4c26d0a07300edca6768db17 upstream.

WARN if transmit_queue_sz is 0 but do not decrement it.
The CEC adapter will become unresponsive if it goes below
0 since then it thinks there are 4 billion messages in the
queue.

Obviously this should not happen, but a driver bug could
cause this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.12 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/cec/cec-adap.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -365,7 +365,8 @@ static void cec_data_cancel(struct cec_d
 	} else {
 		list_del_init(&data->list);
 		if (!(data->msg.tx_status & CEC_TX_STATUS_OK))
-			data->adap->transmit_queue_sz--;
+			if (!WARN_ON(!data->adap->transmit_queue_sz))
+				data->adap->transmit_queue_sz--;
 	}
 
 	if (data->msg.tx_status & CEC_TX_STATUS_OK) {
@@ -417,6 +418,14 @@ static void cec_flush(struct cec_adapter
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
@@ -507,7 +516,8 @@ int cec_thread_func(void *_adap)
 		data = list_first_entry(&adap->transmit_queue,
 					struct cec_data, list);
 		list_del_init(&data->list);
-		adap->transmit_queue_sz--;
+		if (!WARN_ON(!data->adap->transmit_queue_sz))
+			adap->transmit_queue_sz--;
 
 		/* Make this the current transmitting message */
 		adap->transmitting = data;


