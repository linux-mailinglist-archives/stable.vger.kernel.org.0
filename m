Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DC611DF14
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 09:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbfLMIIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 03:08:05 -0500
Received: from www.linuxtv.org ([130.149.80.248]:53994 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfLMIIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 03:08:05 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iffzC-00BRPs-UI; Fri, 13 Dec 2019 08:07:42 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 13 Dec 2019 08:05:04 +0000
Subject: [git:media_tree/master] media: cec: check 'transmit_in_progress', not 'transmitting'
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iffzC-00BRPs-UI@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cec: check 'transmit_in_progress', not 'transmitting'
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Wed Dec 11 12:47:57 2019 +0100

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

 drivers/media/cec/cec-adap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

---

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 1060e633b623..6c95dc471d4c 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -465,7 +465,7 @@ int cec_thread_func(void *_adap)
 		bool timeout = false;
 		u8 attempts;
 
-		if (adap->transmitting) {
+		if (adap->transmit_in_progress) {
 			int err;
 
 			/*
@@ -500,7 +500,7 @@ int cec_thread_func(void *_adap)
 			goto unlock;
 		}
 
-		if (adap->transmitting && timeout) {
+		if (adap->transmit_in_progress && timeout) {
 			/*
 			 * If we timeout, then log that. Normally this does
 			 * not happen and it is an indication of a faulty CEC
@@ -509,14 +509,18 @@ int cec_thread_func(void *_adap)
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
 
