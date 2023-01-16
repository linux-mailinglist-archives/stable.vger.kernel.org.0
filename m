Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3551966C4D8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjAPP64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjAPP6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E762915543
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F85B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0502FC433F0;
        Mon, 16 Jan 2023 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884725;
        bh=Xk69cy4wqPiV4fV7PIldGb5tFpkAiC+OmRnd02WSkSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZg2lJTvsIvUs1X2zq2IpJSfjvqAEfwbW99VaBGvS7DLBb9czVwvbr8cZBuldngAV
         w1BeI1g9IpPHcbJJO9DeTjxoOkLw5JxdANRtBxA0Lq+yUQgUKP7Uy/lSma+jYP6ijC
         F6DaQChi2bUN/nwuJ+S8keMkNVh5CAAq0K9/CC4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/183] nfsd: remove the pages_flushed statistic from filecache
Date:   Mon, 16 Jan 2023 16:50:39 +0100
Message-Id: <20230116154808.293963574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1f696e230ea5198e393368b319eb55651828d687 ]

We're counting mapping->nrpages, but not all of those are necessarily
dirty. We don't really have a simple way to count just the dirty pages,
so just remove this stat since it's not accurate.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 0b3a551fa58b ("nfsd: fix handling of cached open files in nfsd4_open codepath")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index cee44405cf7d..28fff3672df9 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -33,7 +33,6 @@ static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
-static DEFINE_PER_CPU(unsigned long, nfsd_file_pages_flushed);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
 struct nfsd_fcache_disposal {
@@ -371,7 +370,6 @@ nfsd_file_flush(struct nfsd_file *nf)
 
 	if (!file || !(file->f_mode & FMODE_WRITE))
 		return;
-	this_cpu_add(nfsd_file_pages_flushed, file->f_mapping->nrpages);
 	if (vfs_fsync(file, 1) != 0)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
@@ -998,7 +996,6 @@ nfsd_file_cache_shutdown(void)
 		per_cpu(nfsd_file_acquisitions, i) = 0;
 		per_cpu(nfsd_file_releases, i) = 0;
 		per_cpu(nfsd_file_total_age, i) = 0;
-		per_cpu(nfsd_file_pages_flushed, i) = 0;
 		per_cpu(nfsd_file_evictions, i) = 0;
 	}
 }
@@ -1213,7 +1210,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
+	unsigned long releases = 0, evictions = 0;
 	unsigned long hits = 0, acquisitions = 0;
 	unsigned int i, count = 0, buckets = 0;
 	unsigned long lru = 0, total_age = 0;
@@ -1241,7 +1238,6 @@ int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		releases += per_cpu(nfsd_file_releases, i);
 		total_age += per_cpu(nfsd_file_total_age, i);
 		evictions += per_cpu(nfsd_file_evictions, i);
-		pages_flushed += per_cpu(nfsd_file_pages_flushed, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1255,6 +1251,5 @@ int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		seq_printf(m, "mean age (ms): %ld\n", total_age / releases);
 	else
 		seq_printf(m, "mean age (ms): -\n");
-	seq_printf(m, "pages flushed: %lu\n", pages_flushed);
 	return 0;
 }
-- 
2.35.1



