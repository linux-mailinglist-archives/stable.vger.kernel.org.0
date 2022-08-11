Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E180590044
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbiHKPiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiHKPiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:38:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C449926E;
        Thu, 11 Aug 2022 08:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A46C6164C;
        Thu, 11 Aug 2022 15:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DEFC433D6;
        Thu, 11 Aug 2022 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232043;
        bh=LxSm56Y73RiuLft9uw9gT6r3ldbY9uWCMCForicZMqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyN/yRsA6AV4vuzxCvi675Q5p6+/tPxbLJ132NT0/PQBN0bw7ToXr84J3rGK7eTd7
         Dea+7jQt1GbAjKIuS4IuEn2mEf0rn3l+zPp1HeNYYEur+ZOh8Y6r+BSZNP/41fezQB
         fGDz7FJmUrbyb+Hcrig7AAaJ4rsJCaHVrxQLH90YILlXlNHDp6AavctioKIdho2We4
         x8lTrn2GJe74WptAATRvCN6GV7vHsmc2p3SBPrRbAwfJvjqwC/K9XTQVFl7Ow3W8Kq
         3r2qOc6TkRNI9rNyd9/cbxAjwHpqnIit2eT78W8oS5OVCZ5Ll8+XzExWTOPxm8Dnw3
         0J0ojw+uepQPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Mason <clm@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Domas Mituzas <domas@fb.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 054/105] iomap: skip pages past eof in iomap_do_writepage()
Date:   Thu, 11 Aug 2022 11:27:38 -0400
Message-Id: <20220811152851.1520029-54-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mason <clm@fb.com>

[ Upstream commit d58562ca6c992fc5577838d010c8a37401c2a831 ]

iomap_do_writepage() sends pages past i_size through
folio_redirty_for_writepage(), which normally isn't a problem because
truncate and friends clean them very quickly.

When the system has cgroups configured, we can end up in situations
where one cgroup has almost no dirty pages at all, and other cgroups
consume the entire background dirty limit.  This is especially common in
our XFS workloads in production because they have cgroups using O_DIRECT
for almost all of the IO mixed in with cgroups that do more traditional
buffered IO work.

We've hit storms where the redirty path hits millions of times in a few
seconds, on all a single file that's only ~40 pages long.  This leads to
long tail latencies for file writes because the pdflush workers are
hogging the CPU from some kworkers bound to the same CPU.

Reproducing this on 5.18 was tricky because 869ae85dae ("xfs: flush new
eof page on truncate...") ends up writing/waiting most of these dirty pages
before truncate gets a chance to wait on them.

The actual repro looks like this:

/*
 * run me in a cgroup all alone.  Start a second cgroup with dd
 * streaming IO into the block device.
 */
int main(int ac, char **av) {
	int fd;
	int ret;
	char buf[BUFFER_SIZE];
	char *filename = av[1];

	memset(buf, 0, BUFFER_SIZE);

	if (ac != 2) {
		fprintf(stderr, "usage: looper filename\n");
		exit(1);
	}
	fd = open(filename, O_WRONLY | O_CREAT, 0600);
	if (fd < 0) {
		err(errno, "failed to open");
	}
	fprintf(stderr, "looping on %s\n", filename);
	while(1) {
		/*
		 * skip past page 0 so truncate doesn't write and wait
		 * on our extent before changing i_size
		 */
		ret = lseek(fd, 8192, SEEK_SET);
		if (ret < 0)
			err(errno, "lseek");
		ret = write(fd, buf, BUFFER_SIZE);
		if (ret != BUFFER_SIZE)
			err(errno, "write failed");
		/* start IO so truncate has to wait after i_size is 0 */
		ret = sync_file_range(fd, 16384, 4095, SYNC_FILE_RANGE_WRITE);
		if (ret < 0)
			err(errno, "sync_file_range");
		ret = ftruncate(fd, 0);
		if (ret < 0)
			err(errno, "truncate");
		usleep(1000);
	}
}

And this bpftrace script will show when you've hit a redirty storm:

kretprobe:xfs_vm_writepages {
    delete(@dirty[pid]);
}

kprobe:xfs_vm_writepages {
    @dirty[pid] = 1;
}

kprobe:folio_redirty_for_writepage /@dirty[pid] > 0/ {
    $inode = ((struct folio *)arg1)->mapping->host->i_ino;
    @inodes[$inode] = count();
    @redirty++;
    if (@redirty > 90000) {
        printf("inode %d redirty was %d", $inode, @redirty);
        exit();
    }
}

This patch has the same number of failures on xfstests as unpatched 5.18:
Failures: generic/648 xfs/019 xfs/050 xfs/168 xfs/299 xfs/348 xfs/506
xfs/543

I also ran it through a long stress of multiple fsx processes hammering.

(Johannes Weiner did significant tracing and debugging on this as well)

Signed-off-by: Chris Mason <clm@fb.com>
Co-authored-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Domas Mituzas <domas@fb.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d2a9f699e17e..02b8bb46e0b3 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1478,10 +1478,10 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 		pgoff_t end_index = isize >> PAGE_SHIFT;
 
 		/*
-		 * Skip the page if it's fully outside i_size, e.g. due to a
-		 * truncate operation that's in progress. We must redirty the
-		 * page so that reclaim stops reclaiming it. Otherwise
-		 * iomap_release_folio() is called on it and gets confused.
+		 * Skip the page if it's fully outside i_size, e.g.
+		 * due to a truncate operation that's in progress.  We've
+		 * cleaned this page and truncate will finish things off for
+		 * us.
 		 *
 		 * Note that the end_index is unsigned long.  If the given
 		 * offset is greater than 16TB on a 32-bit system then if we
@@ -1496,7 +1496,7 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 		 */
 		if (folio->index > end_index ||
 		    (folio->index == end_index && poff == 0))
-			goto redirty;
+			goto unlock;
 
 		/*
 		 * The page straddles i_size.  It must be zeroed out on each
@@ -1514,6 +1514,7 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 
 redirty:
 	folio_redirty_for_writepage(wbc, folio);
+unlock:
 	folio_unlock(folio);
 	return 0;
 }
-- 
2.35.1

