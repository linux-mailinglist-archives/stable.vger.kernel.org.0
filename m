Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295CF65D535
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239559AbjADOMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbjADOMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:12:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3378D1B1F4
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C54436173D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A47C433D2;
        Wed,  4 Jan 2023 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841552;
        bh=sx5DNL+Ecjw7OMG6PRZByIzYR1lhhjJS2wNvzFUYaME=;
        h=Subject:To:Cc:From:Date:From;
        b=MdORyGnNpjkYi2r29CzhNG+3bCUypMvKCGh7F7v3R3E8oSBAZ4M8dcR1Yd49f6n/o
         FiMlqFChLjp1jTc9BULlCwzyq97cZCkfg2t91p9LLmS+DDDlWfkk51wKntVp7Gd3KY
         LBpde3+Xg8C980gJSAWbnQDxasw40fKty0R6sv64=
Subject: FAILED: patch "[PATCH] media: dvb-core: Fix UAF due to refcount races at releasing" failed to apply to 4.9-stable tree
To:     tiwai@suse.de, hverkuil-cisco@xs4all.nl, imv4bel@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:12:28 +0100
Message-ID: <1672841548142100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fd3d91ab1c6a ("media: dvb-core: Fix UAF due to refcount races at releasing")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd3d91ab1c6ab0628fe642dd570b56302c30a792 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Mon, 31 Oct 2022 11:02:45 +0100
Subject: [PATCH] media: dvb-core: Fix UAF due to refcount races at releasing

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

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index f6ee678107d3..9ce5f010de3f 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -790,6 +790,11 @@ static int dvb_demux_open(struct inode *inode, struct file *file)
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
@@ -1448,7 +1453,10 @@ EXPORT_SYMBOL(dvb_dmxdev_init);
 
 void dvb_dmxdev_release(struct dmxdev *dmxdev)
 {
+	mutex_lock(&dmxdev->mutex);
 	dmxdev->exit = 1;
+	mutex_unlock(&dmxdev->mutex);
+
 	if (dmxdev->dvbdev->users > 1) {
 		wait_event(dmxdev->dvbdev->wait_queue,
 				dmxdev->dvbdev->users == 1);

