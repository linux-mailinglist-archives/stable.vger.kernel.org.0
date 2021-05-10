Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BED37853D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhEJK7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233988AbhEJKzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6152E61C2E;
        Mon, 10 May 2021 10:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643386;
        bh=NnXrD86QDaepdkZjCNN7ZgN4nfylby90UqM9E5K6xzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCBLQeJCyQgDr5bbTf3Gjn5CQWicMR7+xI5DnPbSqSoobaMP7Cc7Mg4ytQNBgKv8A
         jCaDJRELALcMJEe7V0spr3VhOJ56OEwYV41VZH0EMpF2pwq/W8eB5Nc+FFPrENC2ok
         LMO43LhNo17FIu9Q+FAPK73zhamLiG/eHwclrKIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Ming-Hung Tsai <mtsai@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 294/299] dm space map common: fix division bug in sm_ll_find_free_block()
Date:   Mon, 10 May 2021 12:21:31 +0200
Message-Id: <20210510102014.640012135@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

commit 5208692e80a1f3c8ce2063a22b675dd5589d1d80 upstream.

This division bug meant the search for free metadata space could skip
the final allocation bitmap's worth of entries. Fix affects DM thinp,
cache and era targets.

Cc: stable@vger.kernel.org
Signed-off-by: Joe Thornber <ejt@redhat.com>
Tested-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -339,6 +339,8 @@ int sm_ll_find_free_block(struct ll_disk
 	 */
 	begin = do_div(index_begin, ll->entries_per_block);
 	end = do_div(end, ll->entries_per_block);
+	if (end == 0)
+		end = ll->entries_per_block;
 
 	for (i = index_begin; i < index_end; i++, begin = 0) {
 		struct dm_block *blk;


