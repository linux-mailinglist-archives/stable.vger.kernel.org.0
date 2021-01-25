Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947B83031C3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbhAYSpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbhAYSoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:44:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 316F220665;
        Mon, 25 Jan 2021 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600278;
        bh=L12r3wmBAj3TnYzDg8oJdCSFwlYkN5GcIaH9wV1z8LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPEr/Yo9SMeYDHRSpao7pkaGwbH+mHuZ0LFO/ebd0FSvqHT8pQtwygJoHBUo2fn6t
         uFffzR/xHEqZQoGYmfj2YPfL8Jk9IYJNzoFpuUapaXoxn3EJzv1L4nkesHDnXnbfFo
         fH0FpeQ2NHLZ5HI8VLyoa5ccGJ/3b9mZc2S/KS/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 09/86] btrfs: dont clear ret in btrfs_start_dirty_block_groups
Date:   Mon, 25 Jan 2021 19:38:51 +0100
Message-Id: <20210125183201.432071079@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 34d1eb0e599875064955a74712f08ff14c8e3d5f upstream.

If we fail to update a block group item in the loop we'll break, however
we'll do btrfs_run_delayed_refs and lose our error value in ret, and
thus not clean up properly.  Fix this by only running the delayed refs
if there was no failure.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/block-group.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2497,7 +2497,8 @@ again:
 	 * Go through delayed refs for all the stuff we've just kicked off
 	 * and then loop back (just once)
 	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
+	if (!ret)
+		ret = btrfs_run_delayed_refs(trans, 0);
 	if (!ret && loops == 0) {
 		loops++;
 		spin_lock(&cur_trans->dirty_bgs_lock);


