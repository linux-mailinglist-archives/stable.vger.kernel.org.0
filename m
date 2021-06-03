Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF39739A6D8
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhFCRJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhFCRJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3608B61400;
        Thu,  3 Jun 2021 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740071;
        bh=QRI0tQal31vkFBDp4MDbyoZ3gzanK2Fc25tdpxFBd/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Migi0yU0FGFE9TEkm7fkapDpQ66aLsmqdknPoL5Xpi6HowEucsUgnPhdoW0KvB6Q7
         MzC3g02ENm8v37Z2CMAVvvxOjZJl9VYMV1TLe/IgpVpk0RXr2MzFCeCyzHt4SaWl2r
         X8HT4hHqMZb7W+LzJeb2xBaBg9bu9E3fPmItmFgQ5DnM62radaol5j5cbdhevadXE1
         9vP86YiuwhH4VuoTOYErXKVtXYUhtEIxpNzIrwkCqavewz2MFRKhckW7s2fBXtJqXi
         JwyISoz1whDZPL3igGPZ8Y//j3PgEC157jwjjrVLTBUmgXGvj6i5uWlOrzjB+/YFfR
         ZHEAm86HJWf9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 13/43] vfio-ccw: Reset FSM state to IDLE inside FSM
Date:   Thu,  3 Jun 2021 13:07:03 -0400
Message-Id: <20210603170734.3168284-13-sashal@kernel.org>
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
index 767ac41686fe..5971641964c6 100644
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

