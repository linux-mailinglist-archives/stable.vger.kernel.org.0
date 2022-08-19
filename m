Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79EA559A234
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353096AbiHSQdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353495AbiHSQbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47D466A68;
        Fri, 19 Aug 2022 09:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11056177D;
        Fri, 19 Aug 2022 16:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1795C433C1;
        Fri, 19 Aug 2022 16:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925128;
        bh=lYj+03FoQAUy9tB3RaLxYF1iOT8ybR+2ua3LKkOFXpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5oBTDfS6ee64g06XgjyxmwCA1tc6oIRWbEfoCJw4VReoO3ZBeX6PxJp+heTpp1ES
         2Vrff8/KhrYWCl3apfiJiCItE1oKNrkrH0S/apoJOm+sEkuwCRwkpDig1fzKbidYWl
         4+6HaLNmHzeTcCMiswxro3tYxpu1YaYc0jKSiX2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 393/545] vfio/ccw: Do not change FSM state in subchannel event
Date:   Fri, 19 Aug 2022 17:42:43 +0200
Message-Id: <20220819153847.004043859@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit cffcc109fd682075dee79bade3d60a07152a8fd1 ]

The routine vfio_ccw_sch_event() is tasked with handling subchannel events,
specifically machine checks, on behalf of vfio-ccw. It correctly calls
cio_update_schib(), and if that fails (meaning the subchannel is gone)
it makes an FSM event call to mark the subchannel Not Operational.

If that worked, however, then it decides that if the FSM state was already
Not Operational (implying the subchannel just came back), then it should
simply change the FSM to partially- or fully-open.

Remove this trickery, since a subchannel returning will require more
probing than simply "oh all is well again" to ensure it works correctly.

Fixes: bbe37e4cb8970 ("vfio: ccw: introduce a finite state machine")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20220707135737.720765-4-farman@linux.ibm.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9b61e9b131ad..e3c1060b6056 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -288,19 +288,11 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	if (work_pending(&sch->todo_work))
 		goto out_unlock;
 
-	if (cio_update_schib(sch)) {
-		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
-		rc = 0;
-		goto out_unlock;
-	}
-
-	private = dev_get_drvdata(&sch->dev);
-	if (private->state == VFIO_CCW_STATE_NOT_OPER) {
-		private->state = private->mdev ? VFIO_CCW_STATE_IDLE :
-				 VFIO_CCW_STATE_STANDBY;
-	}
 	rc = 0;
 
+	if (cio_update_schib(sch))
+		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
+
 out_unlock:
 	spin_unlock_irqrestore(sch->lock, flags);
 
-- 
2.35.1



