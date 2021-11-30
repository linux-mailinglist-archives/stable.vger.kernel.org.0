Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1643E46388C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243946AbhK3PFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59378 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242762AbhK3O5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:57:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38097CE1A8D;
        Tue, 30 Nov 2021 14:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC35C53FCF;
        Tue, 30 Nov 2021 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284055;
        bh=FffVs0YZYMlJiKC9drWO34HxJwSet7WBPs3qouGbUlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbWeH9QdF1ZE6BRbvfWhswIcqiO6DnUhDcCqZDNAdWfFPSrmI+W2yuKBY3je/5wdf
         aeaD4FW9VV0rksm8NXQaRaDZgdn59ug3yF7OicaD/eVw3xRHsfgmGgraMgwa7kz0h0
         U3Yl6wuR8CH+Wxk2cI6QMdCPyKizv4sy4DirUQ5p6llXhWuYnUpNp4cqJhGj4OqHlh
         mLpwDZ9frGNcIc1PR4PiXZBZOKuiUVO4KhwVau2Xol+QkD4FCGsZZQn1VpGmScnYsc
         ShFMAQZYhIy9V/4O0GiBq/O1OpjLeqjvcn7ctKpuDWgAkQ6f7EmnrCdu+/RxQnbnZi
         zWzmMaGbXn6hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Green <evgreen@chromium.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 7/9] PM: hibernate: Fix snapshot partial write lengths
Date:   Tue, 30 Nov 2021 09:54:00 -0500
Message-Id: <20211130145402.947049-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145402.947049-1-sashal@kernel.org>
References: <20211130145402.947049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

[ Upstream commit 88a5045f176b78c33a269a30a7b146e99c550bd9 ]

snapshot_write() is inappropriately limiting the amount of data that can
be written in cases where a partial page has already been written. For
example, one would expect to be able to write 1 byte, then 4095 bytes to
the snapshot device, and have both of those complete fully (since now
we're aligned to a page again). But what ends up happening is we write 1
byte, then 4094/4095 bytes complete successfully.

The reason is that simple_write_to_buffer()'s second argument is the
total size of the buffer, not the size of the buffer minus the offset.
Since simple_write_to_buffer() accounts for the offset in its
implementation, snapshot_write() can just pass the full page size
directly down.

Signed-off-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index f83c1876b39c0..67659e507747e 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -181,7 +181,7 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 		if (res <= 0)
 			goto unlock;
 	} else {
-		res = PAGE_SIZE - pg_offp;
+		res = PAGE_SIZE;
 	}
 
 	if (!data_of(data->handle)) {
-- 
2.33.0

