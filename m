Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9850966CBA0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbjAPRPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbjAPRPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:15:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67562B63E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 725C1B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA07C433EF;
        Mon, 16 Jan 2023 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888150;
        bh=O/9tsFI4emxdDNgtibqOCVKxzNGTpK0JznlLJKRUlIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFFnPmfhrVKJQUcNkLkUC0UUFJaObBXHtb5R+vK/Tkrwtcajt2/Yte7RfyyY/mmgY
         yBSeK9W2dLRhO+5PcDGGcImBqynsMEUzgWeGnksi81ubwCfQrgNGXPoKy5Xz9c2xgL
         zlvT3HB1l9CR3YuId1MEqLtJd/2MyrLyJkgV8lIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hyunwoo Kim <imv4bel@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 4.19 392/521] media: dvb-core: Fix UAF due to refcount races at releasing
Date:   Mon, 16 Jan 2023 16:50:54 +0100
Message-Id: <20230116154904.649093108@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit fd3d91ab1c6ab0628fe642dd570b56302c30a792 upstream.

The dvb-core tries to sync the releases of opened files at
dvb_dmxdev_release() with two refcounts: dvbdev->users and
dvr_dvbdev->users.  A problem is present in those two syncs: when yet
another dvb_demux_open() is called during those sync waits,
dvb_demux_open() continues to process even if the device is being
closed.  This includes the increment of the former refcount, resulting
in the leftover refcount after the sync of the latter refcount at
dvb_dmxdev_release().  It ends up with use-after-free, since the
function believes that all usages were gone and releases the
resources.

This patch addresses the problem by adding the check of dmxdev->exit
flag at dvb_demux_open(), just like dvb_dvr_open() already does.  With
the exit flag check, the second call of dvb_demux_open() fails, hence
the further corruption can be avoided.

Also for avoiding the races of the dmxdev->exit flag reference, this
patch serializes the dmxdev->exit set up and the sync waits with the
dmxdev->mutex lock at dvb_dmxdev_release().  Without the mutex lock,
dvb_demux_open() (or dvb_dvr_open()) may run concurrently with
dvb_dmxdev_release(), which allows to skip the exit flag check and
continue the open process that is being closed.

CVE-2022-41218 is assigned to those bugs above.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/20220908132754.30532-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dmxdev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -800,6 +800,11 @@ static int dvb_demux_open(struct inode *
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
 
+	if (dmxdev->exit) {
+		mutex_unlock(&dmxdev->mutex);
+		return -ENODEV;
+	}
+
 	for (i = 0; i < dmxdev->filternum; i++)
 		if (dmxdev->filter[i].state == DMXDEV_STATE_FREE)
 			break;
@@ -1457,7 +1462,10 @@ EXPORT_SYMBOL(dvb_dmxdev_init);
 
 void dvb_dmxdev_release(struct dmxdev *dmxdev)
 {
+	mutex_lock(&dmxdev->mutex);
 	dmxdev->exit = 1;
+	mutex_unlock(&dmxdev->mutex);
+
 	if (dmxdev->dvbdev->users > 1) {
 		wait_event(dmxdev->dvbdev->wait_queue,
 				dmxdev->dvbdev->users == 1);


