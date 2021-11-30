Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F219D463844
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243519AbhK3O64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50796 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbhK3O45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34F16B81A5E;
        Tue, 30 Nov 2021 14:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089BEC53FC7;
        Tue, 30 Nov 2021 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284015;
        bh=4gMosLM0bfzlbBKIdYD4na+sA6rW/HTz9SSsJSFfsXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6TTssWLhNZTlwIor0zMKOk58DnXYyvTECosWd4z8DY6M9UfRmKnyJ1u1GgYJ3Q9+
         1KokEu5Hu+3Mc0SsPadeYPSwK3rIqZcADWinq3OUjiOrS3ut9N8rXCgeO5qk17yGeU
         HmdD5pifbs2z9jmQAlqlQ+K8fwyi0nO1OAXtO3FOczCJogihgAh9+QroLm9WZ0WgF7
         8ti4OcfYnjqdCZ2FDEjSukBaUK8Rw8qsxy05T7reEIEPyB38dMbQY9iuKfDAtEv2Lm
         oDnKBUyTbN9BjhKuwOQjfDCvhNDQnbhRlpU9zIlHCmvUMG3axk5rIZvonIpUOPMCA3
         Bo+EIZAaYUWAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Green <evgreen@chromium.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/14] PM: hibernate: Fix snapshot partial write lengths
Date:   Tue, 30 Nov 2021 09:53:12 -0500
Message-Id: <20211130145317.946676-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145317.946676-1-sashal@kernel.org>
References: <20211130145317.946676-1-sashal@kernel.org>
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
index 69017a569f302..ba6a028e0035d 100644
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

