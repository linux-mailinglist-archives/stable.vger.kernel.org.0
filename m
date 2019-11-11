Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47069F7F68
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfKKSbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbfKKSbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:31:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B1B2173B;
        Mon, 11 Nov 2019 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497076;
        bh=+hk06tjiMr95qY1OfTMCF0HksVGRgn4xCrIhJmgsw+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CzmQMzAjTtHat376Tug0X/z7y/9FQMo/7FheNIMwQriv+awe+tsRwjCukxrUI77s
         hVHTKmKbUKKsgux5UemaVzGh4Y6owFJpiirl27hpx+aP9+x/d7SJ3BSRrb3q6L6OiW
         L7wJTu8o7bNJRGLbNDgu4REjZ/HmgFA6ArraONiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 36/43] scsi: qla2xxx: stop timer in shutdown path
Date:   Mon, 11 Nov 2019 19:28:50 +0100
Message-Id: <20191111181326.087588727@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit d3566abb1a1e7772116e4d50fb6a58d19c9802e5 ]

In shutdown/reboot paths, the timer is not stopped:

  qla2x00_shutdown
  pci_device_shutdown
  device_shutdown
  kernel_restart_prepare
  kernel_restart
  sys_reboot

This causes lockups (on powerpc) when firmware config space access calls
are interrupted by smp_send_stop later in reboot.

Fixes: e30d1756480dc ("[SCSI] qla2xxx: Addition of shutdown callback handler.")
Link: https://lore.kernel.org/r/20191024063804.14538-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ff5df33fc7405..611a127f08d82 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2962,6 +2962,10 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	/* Stop currently executing firmware. */
 	qla2x00_try_to_stop_firmware(vha);
 
+	/* Disable timer */
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
+
 	/* Turn adapter off line */
 	vha->flags.online = 0;
 
-- 
2.20.1



