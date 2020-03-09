Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA217E9AE
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgCIUGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:06:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42205 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgCIUGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:06:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 78C8821FE7;
        Mon,  9 Mar 2020 16:06:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 16:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=93i6RV
        D0aX0P8w3CdLJVXUciOPa4ebI+8VHMxXuUvIM=; b=cMDzXCI2Y9fanqRCk6mPL8
        WTy4GKp4Fo2ji9Dmhmwz7W5YUBXcxIFxyNx7Np3yFC3vGku4obiBYKlG1A7XuDuK
        XCCymyw4OnuNOmbivZ9jSVV5q6GkCav6Gpe8zzxnG09U1IDhIfofhzpTNKd8POLY
        6AIjFWBaqjZeD76IdmO8s+P46KdCI9Pc2KCZW/LEe29mEvknKUVkJpxfwszf+oTM
        r2sJPKqwDQ+bVuO+QhuoNhKw9dHQYtFohsYMosXYzSZjhf/7pQ8XwgzYXdQnZqn1
        IhTt1vKr4kS2bb76YjcPtoyCQpiPHqN2xhmRT4KSsqF0cULlXpE/lGNtbZKZfScg
        ==
X-ME-Sender: <xms:rKFmXmeH38UEdJVTbL41JciAyslpUjWgU4z5SwQ642Jc3j1Da-fOkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:rKFmXom5JD6erLvZ0i3jPGrzA09XSYuAytcFcLOYYYG6Ej7aKVEX2g>
    <xmx:rKFmXhxb1-1vnhpSTY57F9qzo84PR2MhYETBQwGcl5qQuz16LNA7Fg>
    <xmx:rKFmXoj8Ox5ofbwFn2iIwq5MOVOWmKP6Ige1D7KpGA1vD9xD_bQo4g>
    <xmx:rKFmXmf0KFrWce8EMHKjV9WpYAEwgwF5f8r91Fiu9NHifpI8XbCCEg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02B523280060;
        Mon,  9 Mar 2020 16:06:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm cache: fix a crash due to incorrect work item cancelling" failed to apply to 4.9-stable tree
To:     mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 21:06:02 +0100
Message-ID: <158378436239197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

