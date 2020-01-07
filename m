Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1BD133417
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgAGVXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:23:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgAGVBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E3224656;
        Tue,  7 Jan 2020 21:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430867;
        bh=I5bT0UnOd1vvZOD2Zxl7tad9MKt1oDNX/jejXGiWtr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFIGlIExJm01kGZv9gcjaH2b5c/Dts/GH1prcdK1n/84c1Kq+vZrNde7TsWLzWfj9
         NmU80nnpq6keK+AwIMNElKNdUgwDVu6zWyj7QJxPbj5BJjsSejRFJf9CvaN77g6IXn
         5YCtpC5eI3Kz7Kndm9GvLntkcsea314pTCwQAIHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 082/191] media: cec: check transmit_in_progress, not transmitting
Date:   Tue,  7 Jan 2020 21:53:22 +0100
Message-Id: <20200107205337.370595839@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit ac479b51f3f4aaa852b5d3f00ecfb9290230cf64 upstream.

Currently wait_event_interruptible_timeout is called in cec_thread_func()
when adap->transmitting is set. But if the adapter is unconfigured
while transmitting, then adap->transmitting is set to NULL. But the
hardware is still actually transmitting the message, and that's
indicated by adap->transmit_in_progress and we should wait until that
is finished or times out before transmitting new messages.

As the original commit says: adap->transmitting is the userspace view,
adap->transmit_in_progress reflects the hardware state.

However, if adap->transmitting is NULL and adap->transmit_in_progress
is true, then wait_event_interruptible is called (no timeout), which
can get stuck indefinitely if the CEC driver is flaky and never marks
the transmit-in-progress as 'done'.

So test against transmit_in_progress when deciding whether to use
the timeout variant or not, instead of testing against adap->transmitting.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 32804fcb612b ("media: cec: keep track of outstanding transmits")
Cc: <stable@vger.kernel.org>      # for v4.19 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/cec/cec-adap.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -463,7 +463,7 @@ int cec_thread_func(void *_adap)
 		bool timeout = false;
 		u8 attempts;
 
-		if (adap->transmitting) {
+		if (adap->transmit_in_progress) {
 			int err;
 
 			/*
@@ -498,7 +498,7 @@ int cec_thread_func(void *_adap)
 			goto unlock;
 		}
 
-		if (adap->transmitting && timeout) {
+		if (adap->transmit_in_progress && timeout) {
 			/*
 			 * If we timeout, then log that. Normally this does
 			 * not happen and it is an indication of a faulty CEC
@@ -507,14 +507,18 @@ int cec_thread_func(void *_adap)
 			 * so much traffic on the bus that the adapter was
 			 * unable to transmit for CEC_XFER_TIMEOUT_MS (2.1s).
 			 */
-			pr_warn("cec-%s: message %*ph timed out\n", adap->name,
-				adap->transmitting->msg.len,
-				adap->transmitting->msg.msg);
+			if (adap->transmitting) {
+				pr_warn("cec-%s: message %*ph timed out\n", adap->name,
+					adap->transmitting->msg.len,
+					adap->transmitting->msg.msg);
+				/* Just give up on this. */
+				cec_data_cancel(adap->transmitting,
+						CEC_TX_STATUS_TIMEOUT);
+			} else {
+				pr_warn("cec-%s: transmit timed out\n", adap->name);
+			}
 			adap->transmit_in_progress = false;
 			adap->tx_timeouts++;
-			/* Just give up on this. */
-			cec_data_cancel(adap->transmitting,
-					CEC_TX_STATUS_TIMEOUT);
 			goto unlock;
 		}
 


