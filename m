Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5418DBA5
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfHNREM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbfHNREL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF54216F4;
        Wed, 14 Aug 2019 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802250;
        bh=QnpU/cJ7wfvq+7aR39NA6ASy2a/L9h+8OJ0opHC3RZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auPOgxJVseBHLnZDp3QvE7XGKNbOfyMSnayALrXfU4ovPGj5LOg8900G2zZi7dIGO
         3fX28RGy+LQ4FzB0aS632MGamud3VPXkxfZDjlr06erJq9WUovmoakKYpcIf98jngj
         f7aQK0ULl0WktSb2QCv+DTfqFrS+7/SLFYmtFLA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 052/144] vfio-ccw: Dont call cp_free if we are processing a channel program
Date:   Wed, 14 Aug 2019 19:00:08 +0200
Message-Id: <20190814165802.002115371@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f4c9939433bd396d0b08e803b2b880a9d02682b9 ]

There is a small window where it's possible that we could be working
on an interrupt (queued in the workqueue) and setting up a channel
program (i.e allocating memory, pinning pages, translating address).
This can lead to allocating and freeing the channel program at the
same time and can cause memory corruption.

Let's not call cp_free if we are currently processing a channel program.
The only way we know for sure that we don't have a thread setting
up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.

Fixes: d5afd5d135c8 ("vfio-ccw: add handling for async channel instructions")
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <62e87bf67b38dc8d5760586e7c96d400db854ebe.1562854091.git.alifm@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9125f7f4e64c9..8a8fbde7e1867 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
-		if (is_final)
+		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
 			cp_free(&private->cp);
 	}
 	mutex_lock(&private->io_mutex);
-- 
2.20.1



