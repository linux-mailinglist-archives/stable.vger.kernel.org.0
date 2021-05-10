Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740FD378714
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhEJLN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235912AbhEJLG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:06:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15BDD61624;
        Mon, 10 May 2021 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644218;
        bh=NnXrD86QDaepdkZjCNN7ZgN4nfylby90UqM9E5K6xzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsbLVOicL8H1gZhHZArK7OEqaMdsF96mmROqTSTbf9BgANpbpNgWhFQXXOXuAD1Mu
         CVRwqxaknT1bikwo9leBdJShK4sI2QG4JZGplJXgxOOhGQZc6+LCxPA1XaTIGq0e8W
         d8LyLYCMGVP63mbqJiK+bYMd5nitbIzrzO9jQkgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Ming-Hung Tsai <mtsai@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 336/342] dm space map common: fix division bug in sm_ll_find_free_block()
Date:   Mon, 10 May 2021 12:22:06 +0200
Message-Id: <20210510102021.211736963@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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


