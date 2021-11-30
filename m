Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAA24638CD
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244628AbhK3PGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244767AbhK3PCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:02:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F093C08EA7A;
        Tue, 30 Nov 2021 06:54:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C705DCE1A85;
        Tue, 30 Nov 2021 14:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A5EC53FC1;
        Tue, 30 Nov 2021 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284039;
        bh=IRNl89iNWB4QAcHxaeCLSft8m8dqDltEHcATHgGYmdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRZYqbI8Kmniq4279H30M0WXWFYRQiV+h7Gys/oW033djuLhx0EIPWvKd3lNjZy0g
         qkjNne/5QMY+hy+oL7PdZJKy5UoimRo3h7IxQ8IWUoHirNj9oKELWbAXtYRlSBQINZ
         0avLXZgNvWJ5ZCSp5UkIojB37YS9rRvlKJ6ZBrFDKa7rwZm7DzaRRy17T6UcTMrUxP
         mMHkKqGph5bDYViSW/KSszclM+qLOwbAHjK7Lg6ONm0q23o/BDlTgYX+AY7WUtCmpk
         8AdUfTXljSGNcBTNRcF9iPw+1fj0bJjYw8A0URRljWkKYVnPzXoq9Y+2CKabS5WFl6
         K/zNMqb2n/80w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Green <evgreen@chromium.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/12] PM: hibernate: Fix snapshot partial write lengths
Date:   Tue, 30 Nov 2021 09:53:38 -0500
Message-Id: <20211130145341.946891-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145341.946891-1-sashal@kernel.org>
References: <20211130145341.946891-1-sashal@kernel.org>
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
index bc6dde1f1567d..07216a0a751d7 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -183,7 +183,7 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 		if (res <= 0)
 			goto unlock;
 	} else {
-		res = PAGE_SIZE - pg_offp;
+		res = PAGE_SIZE;
 	}
 
 	if (!data_of(data->handle)) {
-- 
2.33.0

