Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8400240E4FE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbhIPRG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349201AbhIPRDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7845E617E3;
        Thu, 16 Sep 2021 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810085;
        bh=h//m39MXKjaSM7cXKJkiwWuxGBYGJcyZaGF+pbGT8sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FHT+IEKNfbwEi3wJznAypkIZxESvV4XXxl9OiK+KsPpzabxkARCo8sQtdogBgrtT
         E2oSOMJCSxrs5eDre/9t4PFA2c4Xqsp8dBMW9A6TJX5P5uOgM5/kFrgijITzMWbepY
         tnrIbkdIWRvCxCZOc6dpaYDjpYrk9MCBs2GLxOoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 012/432] btrfs: do not do preemptive flushing if the majority is global rsv
Date:   Thu, 16 Sep 2021 17:56:01 +0200
Message-Id: <20210916155811.227794182@linuxfoundation.org>
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

commit 114623979405abf0b143f9c6688b3ff00ee48338 upstream.

A common characteristic of the bug report where preemptive flushing was
going full tilt was the fact that the vast majority of the free metadata
space was used up by the global reserve.  The hard 90% threshold would
cover the majority of these cases, but to be even smarter we should take
into account how much of the outstanding reservations are covered by the
global block reserve.  If the global block reserve accounts for the vast
majority of outstanding reservations, skip preemptive flushing, as it
will likely just cause churn and pain.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212185
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -741,6 +741,20 @@ static bool need_preemptive_reclaim(stru
 	     global_rsv_size) >= thresh)
 		return false;
 
+	used = space_info->bytes_may_use + space_info->bytes_pinned;
+
+	/* The total flushable belongs to the global rsv, don't flush. */
+	if (global_rsv_size >= used)
+		return false;
+
+	/*
+	 * 128MiB is 1/4 of the maximum global rsv size.  If we have less than
+	 * that devoted to other reservations then there's no sense in flushing,
+	 * we don't have a lot of things that need flushing.
+	 */
+	if (used - global_rsv_size <= SZ_128M)
+		return false;
+
 	/*
 	 * We have tickets queued, bail so we don't compete with the async
 	 * flushers.


