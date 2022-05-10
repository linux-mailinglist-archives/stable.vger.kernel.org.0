Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05E152188E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245535AbiEJNjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbiEJNfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:35:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD822B9CB0;
        Tue, 10 May 2022 06:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5790BCE1EED;
        Tue, 10 May 2022 13:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD3DC385A6;
        Tue, 10 May 2022 13:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189080;
        bh=tVVWGkF/iT6p3c+HWVoArkGTv1eamDF6usUjCAoXFHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTr7wbeOWfnweWN/w1ycAyYj1dLmXckUct3TCv8i/cc4EyUR3nr47I/EoHZ4gn60b
         /OQ34G469IRCg7PzcLtKkcfcz75/PYBHkw9GMQe/DKWzZoQ/4bdd+Yxgz2s/2cQtBi
         WEh8oXBe9SnB1/dCU8pP6xS57MkJbkbDr70l8/b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 49/52] dm: interlock pending dm_io and dm_wait_for_bios_completion
Date:   Tue, 10 May 2022 15:08:18 +0200
Message-Id: <20220510130731.288376880@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 9f6dc633761006f974701d4c88da71ab68670749 upstream.

Commit d208b89401e0 ("dm: fix mempool NULL pointer race when
completing IO") didn't go far enough.

When bio_end_io_acct ends the count of in-flight I/Os may reach zero
and the DM device may be suspended. There is a possibility that the
suspend races with dm_stats_account_io.

Fix this by adding percpu "pending_io" counters to track outstanding
dm_io. Move kicking of suspend queue to dm_io_dec_pending(). Also,
rename md_in_flight_bios() to dm_in_flight_bios() and update it to
iterate all pending_io counters.

Fixes: d208b89401e0 ("dm: fix mempool NULL pointer race when completing IO")
Cc: stable@vger.kernel.org
Co-developed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -681,14 +681,16 @@ static void end_io_acct(struct mapped_de
 {
 	unsigned long duration = jiffies - start_time;
 
-	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
-			    start_time);
-
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, stats_aux);
 
+	smp_wmb();
+
+	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
+			    start_time);
+
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(wq_has_sleeper(&md->wait)))
 		wake_up(&md->wait);
@@ -2494,6 +2496,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb();
+
 	return r;
 }
 


