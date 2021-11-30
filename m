Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64694638B3
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbhK3PFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244483AbhK3PB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:01:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE45C08E9AE;
        Tue, 30 Nov 2021 06:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4787CE1A7A;
        Tue, 30 Nov 2021 14:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24980C53FC1;
        Tue, 30 Nov 2021 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283991;
        bh=Vq2BUP7U2OhILi6TMYWhb5X6RNIV1LJqN9la6OYqdwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQxmLdTcXGhHBGp6srl4pW9EFcHqkLGkLNbGJFSMH8B/ImvrcZAg5MiBafS+U031h
         oUAd9RdZ58d3AHcbGcUJFQJydPQpb7YNNn9dd+7MIGE8u1fRMeT9sz9UQG1uB5j2b/
         l3X4lGS3xo91d5CQdobUbi6gmCGVwqf0yS+V9QinYT3Rm6yZRl7hfVoq6/lyhUvt46
         VMx/CyQlbhkpz4/Jg5QoU3XqfM2DzodwXZks9p3O/OabNN6gRfh5pIyE2ZaB+9QVRI
         2EchndqonojCXBgv63o5osznwMqslf7GdkyNuxlZkhOFFbIgRUYuNw//+h3bueQs7D
         FG43XBPXfjTxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Green <evgreen@chromium.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/17] PM: hibernate: Fix snapshot partial write lengths
Date:   Tue, 30 Nov 2021 09:52:38 -0500
Message-Id: <20211130145243.946407-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index 2d8b60a3c86b9..d5f58a541ff61 100644
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

