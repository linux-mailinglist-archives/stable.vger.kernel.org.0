Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE3455C5FD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiF0Ld7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiF0LdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B19FBE2B;
        Mon, 27 Jun 2022 04:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5969E61510;
        Mon, 27 Jun 2022 11:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68236C3411D;
        Mon, 27 Jun 2022 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329414;
        bh=cuO2nTisTqBS0cLwTF9hisxzJeuL2o6+A2Rz7bYaU/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msKQhhZZfmwNbaPw/bts5dgyCB2ZJKJ3ljYK5i5cN9kdYHUq5CYtEPpC6oo4O9W1L
         p3Cn0VIZ44oknn/RmKAW7KPOX6oZqnHAgviot11fcndA/YmO1YxSHic+xXpWDrRrSk
         GZUZ/SQW/N0G9kBqzUXMkox2o3wTLg2DQs4xBcXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 11/60] dm era: commit metadata in postsuspend after worker stops
Date:   Mon, 27 Jun 2022 13:21:22 +0200
Message-Id: <20220627111927.985048485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
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
@@ -1397,7 +1397,7 @@ static void start_worker(struct era *era
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
-	flush_workqueue(era->wq);
+	drain_workqueue(era->wq);
 }
 
 /*----------------------------------------------------------------
@@ -1581,6 +1581,12 @@ static void era_postsuspend(struct dm_ta
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


