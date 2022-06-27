Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AE955CCEC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbiF0LhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbiF0Lg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:36:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76131E58;
        Mon, 27 Jun 2022 04:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23DE4B81122;
        Mon, 27 Jun 2022 11:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDCDC3411D;
        Mon, 27 Jun 2022 11:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329518;
        bh=z+1DQVTPAggy8DmvFiwP/5SP/t/XK2yDDfu1fqt3xws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abqLj6Q/miXmci2flJaoCiW49nD0L+2T7fplpX79soYfQa8C6j2v8oywCjVJ9VTTc
         2Pks3TN62LSnzsG1PkfXgahpFJB1FHtzKqGWHMQX0Md+Dfb+JJOwRolwaFnAt6kqqL
         wsLgGJaK710fie/nvlIaKYBN0klr/5BS7n86EEKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 025/135] dm era: commit metadata in postsuspend after worker stops
Date:   Mon, 27 Jun 2022 13:20:32 +0200
Message-Id: <20220627111938.890650023@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 9ae6e8b1c9bbf6874163d1243e393137313762b7 upstream.

During postsuspend dm-era does the following:

1. Archives the current era
2. Commits the metadata, as part of the RPC call for archiving the
   current era
3. Stops the worker

Until the worker stops, it might write to the metadata again. Moreover,
these writes are not flushed to disk immediately, but are cached by the
dm-bufio client, which writes them back asynchronously.

As a result, the committed metadata of a suspended dm-era device might
not be consistent with the in-core metadata.

In some cases, this can result in the corruption of the on-disk
metadata. Suppose the following sequence of events:

1. Load a new table, e.g. a snapshot-origin table, to a device with a
   dm-era table
2. Suspend the device
3. dm-era commits its metadata, but the worker does a few more metadata
   writes until it stops, as part of digesting an archived writeset
4. These writes are cached by the dm-bufio client
5. Load the dm-era table to another device.
6. The new instance of the dm-era target loads the committed, on-disk
   metadata, which don't include the extra writes done by the worker
   after the metadata commit.
7. Resume the new device
8. The new dm-era target instance starts using the metadata
9. Resume the original device
10. The destructor of the old dm-era target instance is called and
    destroys the dm-bufio client, which results in flushing the cached
    writes to disk
11. These writes might overwrite the writes done by the new dm-era
    instance, hence corrupting its metadata.

Fix this by committing the metadata after the worker stops running.

stop_worker uses flush_workqueue to flush the current work. However, the
work item may re-queue itself and flush_workqueue doesn't wait for
re-queued works to finish.

This could result in the worker changing the metadata after they have
been committed, or writing to the metadata concurrently with the commit
in the postsuspend thread.

Use drain_workqueue instead, which waits until the work and all
re-queued works finish.

Fixes: eec40579d8487 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1400,7 +1400,7 @@ static void start_worker(struct era *era
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
-	flush_workqueue(era->wq);
+	drain_workqueue(era->wq);
 }
 
 /*----------------------------------------------------------------
@@ -1570,6 +1570,12 @@ static void era_postsuspend(struct dm_ta
 	}
 
 	stop_worker(era);
+
+	r = metadata_commit(era->md);
+	if (r) {
+		DMERR("%s: metadata_commit failed", __func__);
+		/* FIXME: fail mode */
+	}
 }
 
 static int era_preresume(struct dm_target *ti)


