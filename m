Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5ADF6CC4E4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjC1PKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjC1PKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEF0EB65
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55109B81D84
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A659BC433D2;
        Tue, 28 Mar 2023 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015923;
        bh=z2gkB8yvrfNSrtRIIsJ1Z8vM9S7nvl3gsuAsqB9cgNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9G2yDgK9XG+eIEE60e421HyQzCtha3N/dbYde1etIbjyBcQJQoiPdVRQEcwMJj6/
         EVHR2OLf8G9Zz+DV7asEKgG/TIq1l6alHsDkvejAALoHgzyfVSBBxZB8xvf5AopAfS
         G/jc/UN6gZ/shL9ARWfyLoMFmt3ToBxS3bMjfQwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 216/224] dm stats: check for and propagate alloc_percpu failure
Date:   Tue, 28 Mar 2023 16:43:32 +0200
Message-Id: <20230328142626.331813089@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit d3aa3e060c4a80827eb801fc448debc9daa7c46b upstream.

Check alloc_precpu()'s return value and return an error from
dm_stats_init() if it fails. Update alloc_dev() to fail if
dm_stats_init() does.

Otherwise, a NULL pointer dereference will occur in dm_stats_cleanup()
even if dm-stats isn't being actively used.

Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    7 ++++++-
 drivers/md/dm-stats.h |    2 +-
 drivers/md/dm.c       |    4 +++-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -188,7 +188,7 @@ static int dm_stat_in_flight(struct dm_s
 	       atomic_read(&shared->in_flight[WRITE]);
 }
 
-void dm_stats_init(struct dm_stats *stats)
+int dm_stats_init(struct dm_stats *stats)
 {
 	int cpu;
 	struct dm_stats_last_position *last;
@@ -197,11 +197,16 @@ void dm_stats_init(struct dm_stats *stat
 	INIT_LIST_HEAD(&stats->list);
 	stats->precise_timestamps = false;
 	stats->last = alloc_percpu(struct dm_stats_last_position);
+	if (!stats->last)
+		return -ENOMEM;
+
 	for_each_possible_cpu(cpu) {
 		last = per_cpu_ptr(stats->last, cpu);
 		last->last_sector = (sector_t)ULLONG_MAX;
 		last->last_rw = UINT_MAX;
 	}
+
+	return 0;
 }
 
 void dm_stats_cleanup(struct dm_stats *stats)
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -21,7 +21,7 @@ struct dm_stats_aux {
 	unsigned long long duration_ns;
 };
 
-void dm_stats_init(struct dm_stats *st);
+int dm_stats_init(struct dm_stats *st);
 void dm_stats_cleanup(struct dm_stats *st);
 
 struct mapped_device;
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2105,7 +2105,9 @@ static struct mapped_device *alloc_dev(i
 	if (!md->pending_io)
 		goto bad;
 
-	dm_stats_init(&md->stats);
+	r = dm_stats_init(&md->stats);
+	if (r < 0)
+		goto bad;
 
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);


