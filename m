Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55646561D9F
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiF3ODY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbiF3OCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DDAB48;
        Thu, 30 Jun 2022 06:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9928A620EB;
        Thu, 30 Jun 2022 13:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7B2C34115;
        Thu, 30 Jun 2022 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597183;
        bh=mAlzY4+qXjdLojrOSA13Bsh+r1xYcbPlD1Afg/rBXqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzjpqAVSJCi2iP1tRKM1TJQ6Xz7ZdIwFeVLmKauJCsF+B/RzN1q+9cQ5Hx4o4Xhdz
         NgXb5K7j+QmlarzT1R1rDTswRgHvFTAAZWpuu2Q81xEixR+ST9TYiI+ukBMLPT6gmd
         PkiAFpKGj8omz9FXbIwsGDr3Gsmn1oATM8/MofkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 07/49] dm era: commit metadata in postsuspend after worker stops
Date:   Thu, 30 Jun 2022 15:46:20 +0200
Message-Id: <20220630133234.124223830@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
@@ -1396,7 +1396,7 @@ static void start_worker(struct era *era
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
-	flush_workqueue(era->wq);
+	drain_workqueue(era->wq);
 }
 
 /*----------------------------------------------------------------
@@ -1580,6 +1580,12 @@ static void era_postsuspend(struct dm_ta
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


