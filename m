Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B96F4637F9
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbhK3O5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49028 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243411AbhK3OzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:55:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4637EB81A52;
        Tue, 30 Nov 2021 14:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E844C53FC1;
        Tue, 30 Nov 2021 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283909;
        bh=3ZU4XvksUimkGRLrEk5UohMKNveSnLHq5HBAhjcZfBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrkxDQoymZmyl6yi/xm8QilGfbnv27bbJD6CSUyyN7+yCNREBP8HLG+ryGOIXZw6W
         g+vKouC7a30CqqXUOV6iN0yRDJhAauYG/HgWUILHakadCYw5fngi7QvX2tvYrq3cze
         JXxxxbzH1SPheRX4erFvmVoYnzKk2KIphjZc97xMRZ9rWY+F2hGiXAYT92H8B5gE6P
         y9sOjq+1xa6cD2gMJe8Pth8BeD2wdLNY+YGL4TOyQOBvVbcVJY1MXMqKTNt5Gl1IuK
         5J1NHi9IRd56pQXIrSvxRQnMYnJU4ltgoMHLoCiTP8TydUMhpu1ldek+YMe+BXQKN3
         28mkHtVtg6YZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Green <evgreen@chromium.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/43] PM: hibernate: Fix snapshot partial write lengths
Date:   Tue, 30 Nov 2021 09:50:16 -0500
Message-Id: <20211130145022.945517-39-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index 740723bb38852..ad241b4ff64c5 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -177,7 +177,7 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 		if (res <= 0)
 			goto unlock;
 	} else {
-		res = PAGE_SIZE - pg_offp;
+		res = PAGE_SIZE;
 	}
 
 	if (!data_of(data->handle)) {
-- 
2.33.0

