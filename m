Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A039A6D9
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhFCRJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhFCRJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80AF3613FA;
        Thu,  3 Jun 2021 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740072;
        bh=2lVh5NkMWKcDdgRJf5gWZI/lLSeNE7nfG/pCe+/EixQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbkEF20BIPr6Ryd9qJghZ0f3Dec18ifwob5g4iFAFmF9eH0Tl9Wc5HW9bg54p1vzT
         qmfas3RDURlqEA0MW4Oul0aLggqK4I1tNbOpRPuVVlXcm02TiH67rEeBm7uqo9P4a6
         HE/8ZrCEp0uZ6JukfVYBG8LdSjQwHHTPjDz+FRFp0YDTfuAKqvAWBznsuFgU6RFzDg
         b6wlHWts4dEYFI+MZcDjJNSHvyM4jmyz07yx4FaE5N9i+fJOnknQCB6IGVBNNjAz/j
         wJ8cgB00AfjlzU50p4t4670XXLLsNeGHjQw2L7VGqzGx1CI91ZPMxZhRjo4ZGriRby
         P4Thr4QIG/LbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 14/43] vfio-ccw: Serialize FSM IDLE state with I/O completion
Date:   Thu,  3 Jun 2021 13:07:04 -0400
Message-Id: <20210603170734.3168284-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 2af7a834a435460d546f0cf0a8b8e4d259f1d910 ]

Today, the stacked call to vfio_ccw_sch_io_todo() does three things:

  1) Update a solicited IRB with CP information, and release the CP
     if the interrupt was the end of a START operation.
  2) Copy the IRB data into the io_region, under the protection of
     the io_mutex
  3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
     vfio-ccw can accept more work.

The trouble is that step 3 is (A) invoked for both solicited and
unsolicited interrupts, and (B) sitting after the mutex for step 2.
This second piece becomes a problem if it processes an interrupt
for a CLEAR SUBCHANNEL while another thread initiates a START,
thus allowing the CP and FSM states to get out of sync. That is:

    CPU 1                           CPU 2
    fsm_do_clear()
    fsm_irq()
                                    fsm_io_request()
    vfio_ccw_sch_io_todo()
                                    fsm_io_helper()

Since the FSM state and CP should be kept in sync, let's make a
note when the CP is released, and rely on that as an indication
that the FSM should also be reset at the end of this routine and
open up the device for more work.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20210511195631.3995081-4-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 8c625b530035..9b61e9b131ad 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -86,6 +86,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	struct vfio_ccw_private *private;
 	struct irb *irb;
 	bool is_final;
+	bool cp_is_finished = false;
 
 	private = container_of(work, struct vfio_ccw_private, io_work);
 	irb = &private->irb;
@@ -94,14 +95,21 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
-		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
+		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
 			cp_free(&private->cp);
+			cp_is_finished = true;
+		}
 	}
 	mutex_lock(&private->io_mutex);
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
 	mutex_unlock(&private->io_mutex);
 
-	if (private->mdev && is_final)
+	/*
+	 * Reset to IDLE only if processing of a channel program
+	 * has finished. Do not overwrite a possible processing
+	 * state if the final interrupt was for HSCH or CSCH.
+	 */
+	if (private->mdev && cp_is_finished)
 		private->state = VFIO_CCW_STATE_IDLE;
 
 	if (private->io_trigger)
-- 
2.30.2

