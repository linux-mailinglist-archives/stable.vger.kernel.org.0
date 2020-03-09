Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31D517E9B0
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgCIUGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:06:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54543 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgCIUGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:06:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C9562209B;
        Mon,  9 Mar 2020 16:06:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 16:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Uy7Wx6
        GAvI7miexqH+9hdeKcjMTihm4PKtty3Nbc6Aw=; b=iHLakEc+lIIf4nA0WtT0fL
        Zyun41lCjZ/vIT6mEMUm0kTEbC43WFp3mSJRw1AJSt+1hiU9xiXF8dJdL3E3T1yD
        /dlbpiMEYf88PdS/ORxIL9hR+mihbiN/h+u1rm1UPFuE2syTAVTWKjmBANJcFwc7
        OlIYBp0hWWcBuMqL1M3kS1rbs5Sed0GJOZ7YHcP1/ObDD5v4QLd4llv+lyjlQPjT
        AqqrTK6ArZfzofeZ34uujAi1GrEatzq5kW9Mv5jy7Ws4RAww3AFemSYKEY81oLnK
        tiUh15SYWYXwCMcPoZeSKoVGOELwyL5dlnkEWWwQLU8AF5gQGZRLb2FGGluzcq6w
        ==
X-ME-Sender: <xms:tKFmXuy-5WX0l8uUl85oVFl70mNUTzNCZR7nub-E2ZGZnqG3PXDX2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfe
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:taFmXuhHDxc4i9eGDGdrxbE6iG_xDo58M6Ilgte-CniNebC6841EIw>
    <xmx:taFmXrX6psewgcnOa99Iy-R5rByawg2yN_Fr4xkyEVQ9JLiV7Aahuw>
    <xmx:taFmXo1mMiuskUWeZTlXLNyDPTlM_gVvLcMcBeCHowccvBKLb8JyxQ>
    <xmx:taFmXpWdjWwi2daqGUdGc81FeyZDyOfaS5r5isQiOsTVrWQ4VuKhqg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A90453280060;
        Mon,  9 Mar 2020 16:06:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm cache: fix a crash due to incorrect work item cancelling" failed to apply to 4.4-stable tree
To:     mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 21:06:03 +0100
Message-ID: <15837843631384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7cdf6a0aae1cccf5167f3f04ecddcf648b78e289 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 19 Feb 2020 10:25:45 -0500
Subject: [PATCH] dm cache: fix a crash due to incorrect work item cancelling

The crash can be reproduced by running the lvm2 testsuite test
lvconvert-thin-external-cache.sh for several minutes, e.g.:
  while :; do make check T=shell/lvconvert-thin-external-cache.sh; done

The crash happens in this call chain:
do_waker -> policy_tick -> smq_tick -> end_hotspot_period -> clear_bitset
-> memset -> __memset -- which accesses an invalid pointer in the vmalloc
area.

The work entry on the workqueue is executed even after the bitmap was
freed. The problem is that cancel_delayed_work doesn't wait for the
running work item to finish, so the work item can continue running and
re-submitting itself even after cache_postsuspend. In order to make sure
that the work item won't be running, we must use cancel_delayed_work_sync.

Also, change flush_workqueue to drain_workqueue, so that if some work item
submits itself or another work item, we are properly waiting for both of
them.

Fixes: c6b4fcbad044 ("dm: add cache target")
Cc: stable@vger.kernel.org # v3.9
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 2d32821b3a5b..f4be63671233 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2846,8 +2846,8 @@ static void cache_postsuspend(struct dm_target *ti)
 	prevent_background_work(cache);
 	BUG_ON(atomic_read(&cache->nr_io_migrations));
 
-	cancel_delayed_work(&cache->waker);
-	flush_workqueue(cache->wq);
+	cancel_delayed_work_sync(&cache->waker);
+	drain_workqueue(cache->wq);
 	WARN_ON(cache->tracker.in_flight);
 
 	/*

