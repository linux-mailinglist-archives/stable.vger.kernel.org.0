Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D81111DF15
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 09:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfLMIIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 03:08:06 -0500
Received: from www.linuxtv.org ([130.149.80.248]:54004 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfLMIIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 03:08:05 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iffzD-00BRQk-7T; Fri, 13 Dec 2019 08:07:43 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 13 Dec 2019 08:02:07 +0000
Subject: [git:media_tree/master] media: cec: CEC 2.0-only bcast messages were ignored
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iffzD-00BRQk-7T@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cec: CEC 2.0-only bcast messages were ignored
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Wed Dec 4 08:52:08 2019 +0100

Some messages are allowed to be a broadcast message in CEC 2.0
only, and should be ignored by CEC 1.4 devices.

Unfortunately, the check was wrong, causing such messages to be
marked as invalid under CEC 2.0.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/cec/cec-adap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 9340435a94a0..e90c30dac68b 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1085,11 +1085,11 @@ void cec_received_msg_ts(struct cec_adapter *adap,
 			valid_la = false;
 		else if (!cec_msg_is_broadcast(msg) && !(dir_fl & DIRECTED))
 			valid_la = false;
-		else if (cec_msg_is_broadcast(msg) && !(dir_fl & BCAST1_4))
+		else if (cec_msg_is_broadcast(msg) && !(dir_fl & BCAST))
 			valid_la = false;
 		else if (cec_msg_is_broadcast(msg) &&
-			 adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0 &&
-			 !(dir_fl & BCAST2_0))
+			 adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0 &&
+			 !(dir_fl & BCAST1_4))
 			valid_la = false;
 	}
 	if (valid_la && min_len) {
