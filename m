Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBF1594C45
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbiHPAro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347452AbiHPAp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6417A193579;
        Mon, 15 Aug 2022 13:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1668BB80EA9;
        Mon, 15 Aug 2022 20:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521B5C433C1;
        Mon, 15 Aug 2022 20:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596104;
        bh=UMR9Q6e1EIqM0Fs6+TNQ242WxfelHSW1T1pAVmYgAec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=behzgG/z5SfODjVcI6gD5bCO2XxwqVu2/9ZqesPqJZfBbA+n2KYnMkC6Jtr3BUvSN
         X/baHSYGQGDMVJweHYrKNKEvMezLraAp+I5cZ+Xpl8ezmeWirvWDFdI2rFVRj5yBiY
         lEvG4je7GN9ZyMwfy8o9Pnx/+y0mNlWKQMmvp22c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0939/1157] vfio/ccw: Fix FSM state if mdev probe fails
Date:   Mon, 15 Aug 2022 20:04:55 +0200
Message-Id: <20220815180517.076977276@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit f6c876d67e956de8d69349b0ee43bc7277c09e5c ]

The FSM is in STANDBY state when arriving in vfio_ccw_mdev_probe(),
and this routine converts it to IDLE as part of its processing.
The error exit sets it to IDLE (again) but clears the private->mdev
pointer.

The FSM should of course be managing the state itself, but the
correct thing for vfio_ccw_mdev_probe() to do would be to put
the state back the way it found it.

The corresponding check of private->mdev in vfio_ccw_sch_io_todo()
can be removed, since the distinction is unnecessary at this point.

Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20220707135737.720765-3-farman@linux.ibm.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 5 +++--
 drivers/s390/cio/vfio_ccw_ops.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 35055eb94115..179eb614fa5b 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -106,9 +106,10 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	/*
 	 * Reset to IDLE only if processing of a channel program
 	 * has finished. Do not overwrite a possible processing
-	 * state if the final interrupt was for HSCH or CSCH.
+	 * state if the interrupt was unsolicited, or if the final
+	 * interrupt was for HSCH or CSCH.
 	 */
-	if (private->mdev && cp_is_finished)
+	if (cp_is_finished)
 		private->state = VFIO_CCW_STATE_IDLE;
 
 	if (private->io_trigger)
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 0e05bff78b8e..9a05dadcbb75 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -146,7 +146,7 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	vfio_uninit_group_dev(&private->vdev);
 	atomic_inc(&private->avail);
 	private->mdev = NULL;
-	private->state = VFIO_CCW_STATE_IDLE;
+	private->state = VFIO_CCW_STATE_STANDBY;
 	return ret;
 }
 
-- 
2.35.1



