Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D6D1F29E1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbgFIAFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731156AbgFHXV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54920208FE;
        Mon,  8 Jun 2020 23:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658488;
        bh=IlCy+/PA9cG/OOuLd1GmNkRJfPDP1bUeB3weSGCHfdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEKH1mVmk/P2snFmc2Ixc5A0ouqadKRtuECElT6n5XBUZHWlGciWYDeUATVMQKrX7
         63SSvhbrrFHnPMhPzC2b+UHl994vS0CdkIPUVGo+4ebgzTTsgj2HkjC0XuC/BN8ChC
         r4zuLieDw+BZ1feZddbpPIkTCoDbgraW3ley6eAs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Michal Hocko <mhocko@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 122/175] raid5: remove gfp flags from scribble_alloc()
Date:   Mon,  8 Jun 2020 19:17:55 -0400
Message-Id: <20200608231848.3366970-122-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit ba54d4d4d2844c234f1b4692bd8c9e0f833c8a54 ]

Using GFP_NOIO flag to call scribble_alloc() from resize_chunk() does
not have the expected behavior. kvmalloc_array() inside scribble_alloc()
which receives the GFP_NOIO flag will eventually call kmalloc_node() to
allocate physically continuous pages.

Now we have memalloc scope APIs in mddev_suspend()/mddev_resume() to
prevent memory reclaim I/Os during raid array suspend context, calling
to kvmalloc_array() with GFP_KERNEL flag may avoid deadlock of recursive
I/O as expected.

This patch removes the useless gfp flags from parameters list of
scribble_alloc(), and call kvmalloc_array() with GFP_KERNEL flag. The
incorrect GFP_NOIO flag does not exist anymore.

Fixes: b330e6a49dc3 ("md: convert to kvmalloc")
Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 36cd7c2fbf40..a3cbc9f4fec1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2228,14 +2228,19 @@ static int grow_stripes(struct r5conf *conf, int num)
  * of the P and Q blocks.
  */
 static int scribble_alloc(struct raid5_percpu *percpu,
-			  int num, int cnt, gfp_t flags)
+			  int num, int cnt)
 {
 	size_t obj_size =
 		sizeof(struct page *) * (num+2) +
 		sizeof(addr_conv_t) * (num+2);
 	void *scribble;
 
-	scribble = kvmalloc_array(cnt, obj_size, flags);
+	/*
+	 * If here is in raid array suspend context, it is in memalloc noio
+	 * context as well, there is no potential recursive memory reclaim
+	 * I/Os with the GFP_KERNEL flag.
+	 */
+	scribble = kvmalloc_array(cnt, obj_size, GFP_KERNEL);
 	if (!scribble)
 		return -ENOMEM;
 
@@ -2267,8 +2272,7 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 
 		percpu = per_cpu_ptr(conf->percpu, cpu);
 		err = scribble_alloc(percpu, new_disks,
-				     new_sectors / STRIPE_SECTORS,
-				     GFP_NOIO);
+				     new_sectors / STRIPE_SECTORS);
 		if (err)
 			break;
 	}
@@ -6765,8 +6769,7 @@ static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu
 			       conf->previous_raid_disks),
 			   max(conf->chunk_sectors,
 			       conf->prev_chunk_sectors)
-			   / STRIPE_SECTORS,
-			   GFP_KERNEL)) {
+			   / STRIPE_SECTORS)) {
 		free_scratch_buffer(conf, percpu);
 		return -ENOMEM;
 	}
-- 
2.25.1

