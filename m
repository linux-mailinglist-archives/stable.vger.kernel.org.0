Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90F220D9EC
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbgF2TwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387724AbgF2Tkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2AA251C7;
        Mon, 29 Jun 2020 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444498;
        bh=/wwFr023xKwZwoH9KeM4gDBBd7FR80d/Yi4TuXHM080=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiSnj/eB/DD0YTAdsgAYhAwHt9jVf7i/S/niw8ibxCvfSIqFH04SjTuyvMlV4Ilws
         tCYoVEfQRrv5++bW9mXtHudtQScxQ3LwvxjWDpNAbXgng0v1Jv7cJRWXURRdCEjnUz
         ryJnN4zQzp68qgGKM8hkKId34dhWXiWK6IVElIM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huaisheng Ye <yehs1@lenovo.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 175/178] dm writecache: correct uncommitted_block when discarding uncommitted entry
Date:   Mon, 29 Jun 2020 11:25:20 -0400
Message-Id: <20200629152523.2494198-176-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huaisheng Ye <yehs1@lenovo.com>

commit 39495b12ef1cf602e6abd350dce2ef4199906531 upstream.

When uncommitted entry has been discarded, correct wc->uncommitted_block
for getting the exact number.

Fixes: 48debafe4f2fe ("dm: add writecache target")
Cc: stable@vger.kernel.org
Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 0d6ca723257f6..64d75bbefda11 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -805,6 +805,8 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				writecache_wait_for_ios(wc, WRITE);
 				discarded_something = true;
 			}
+			if (!writecache_entry_is_committed(wc, e))
+				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.25.1

