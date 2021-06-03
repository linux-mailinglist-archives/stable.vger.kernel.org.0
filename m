Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490D039A740
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhFCRKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231968AbhFCRKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D4D6140C;
        Thu,  3 Jun 2021 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740123;
        bh=96gJs0MHtdFpp5U5h3iNdCzcmTuO23CVLlLTBMXL7KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfGG0TQ1BCoVuW0jycCPHlIzu463s6R2BmBG0GJEdyJe1m5rCj0VUb9b814nSigrt
         lghqI9zDprQGkQHUxkUoe+PlRl+uiF0cbsiyIqroUM2Tu2nidOsdv///wBWoFzwNRN
         iGuKL14Tn11W2WNwzCG1Ni5l6Tc9OyiYux/X5yjEdrupBBsrvDL6RuMuD1I7rOJeik
         jEDF4ko1goawTY8H6sLiVsNYnzFUtZToFhbJ8cPfqZsurHRuktioHGhO2+AYjaT8gB
         /Lp6wbf69ZbQ/jOyS7OyzsybzJHKFtPlvFZsnH8hDgkApy/VU/WFO5RuUU6a3OD1hf
         C0JzK6fxx612w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/39] vfio-ccw: Reset FSM state to IDLE inside FSM
Date:   Thu,  3 Jun 2021 13:08:01 -0400
Message-Id: <20210603170829.3168708-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 6c02ac4c9211edabe17bda437ac97e578756f31b ]

When an I/O request is made, the fsm_io_request() routine
moves the FSM state from IDLE to CP_PROCESSING, and then
fsm_io_helper() moves it to CP_PENDING if the START SUBCHANNEL
received a cc0. Yet, the error case to go from CP_PROCESSING
back to IDLE is done after the FSM call returns.

Let's move this up into the FSM proper, to provide some
better symmetry when unwinding in this case.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>
Message-Id: <20210511195631.3995081-3-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 1 +
 drivers/s390/cio/vfio_ccw_ops.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 23e61aa638e4..e435a9cd92da 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -318,6 +318,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	}
 
 err_out:
+	private->state = VFIO_CCW_STATE_IDLE;
 	trace_vfio_ccw_fsm_io_request(scsw->cmd.fctl, schid,
 				      io_region->ret_code, errstr);
 }
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 1ad5f7018ec2..2280f51dd679 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -276,8 +276,6 @@ static ssize_t vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
 	}
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_IO_REQ);
-	if (region->ret_code != 0)
-		private->state = VFIO_CCW_STATE_IDLE;
 	ret = (region->ret_code != 0) ? region->ret_code : count;
 
 out_unlock:
-- 
2.30.2

