Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E367E40E4FF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345286AbhIPRGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349199AbhIPRDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B142061B22;
        Thu, 16 Sep 2021 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810082;
        bh=QL4aZuOEJkfchcacfa6x3lAC/IoaWcbnIqERGifXzk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7x94EI+Te4DnwuLZv8SsciOZ4ZMq2SO2Zk6XSkX9cbs/YztQV7BxunEZjJ6DRjNU
         1uGvvM/lF1AsfH9gmJ/LRYzW5ndPeTSaQN+NdhOVvmAGobe59o+6tPnvfVjcvZy3vC
         4pwg/wq351kq/WISIL5JzKpke4s7qFbv1TaT8dWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 011/432] btrfs: reduce the preemptive flushing threshold to 90%
Date:   Thu, 16 Sep 2021 17:56:00 +0200
Message-Id: <20210916155811.192987085@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 93c60b17f2b5fca2c5931d7944788d1ef5f25528 upstream.

The preemptive flushing code was added in order to avoid needing to
synchronously wait for ENOSPC flushing to recover space.  Once we're
almost full however we can essentially flush constantly.  We were using
98% as a threshold to determine if we were simply full, however in
practice this is a really high bar to hit.  For example reports of
systems running into this problem had around 94% usage and thus
continued to flush.  Fix this by lowering the threshold to 90%, which is
a more sane value, especially for smaller file systems.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212185
CC: stable@vger.kernel.org # 5.12+
Fixes: 576fa34830af ("btrfs: improve preemptive background space flushing")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -733,7 +733,7 @@ static bool need_preemptive_reclaim(stru
 {
 	u64 global_rsv_size = fs_info->global_block_rsv.reserved;
 	u64 ordered, delalloc;
-	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
+	u64 thresh = div_factor_fine(space_info->total_bytes, 90);
 	u64 used;
 
 	/* If we're just plain full then async reclaim just slows us down. */


