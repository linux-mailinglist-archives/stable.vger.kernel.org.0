Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A4A46B985
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 11:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhLGKyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:54:43 -0500
Received: from www.linuxtv.org ([130.149.80.248]:48612 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhLGKyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 05:54:43 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1muXkN-00AS8N-W9; Tue, 07 Dec 2021 10:30:55 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 10 Nov 2021 11:39:08 +0000
Subject: [git:media_tree/master] media: cec: copy sequence field for the reply
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1muXkN-00AS8N-W9@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cec: copy sequence field for the reply
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Tue Nov 2 12:24:26 2021 +0000

When the reply for a non-blocking transmit arrives, the sequence
field for that reply was never filled in, so userspace would have no
way of associating the reply to the original transmit.

Copy the sequence field to ensure that this is now possible.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0dbacebede1e ([media] cec: move the CEC framework out of staging and to media)
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/cec/core/cec-adap.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 79fa36de8a04..cd9cb354dc2c 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1199,6 +1199,7 @@ void cec_received_msg_ts(struct cec_adapter *adap,
 			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
 			msg->flags = dst->flags;
+			msg->sequence = dst->sequence;
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);
 
