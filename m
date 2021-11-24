Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEB345BD95
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245444AbhKXMjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:39:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243823AbhKXMha (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:37:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6031F61074;
        Wed, 24 Nov 2021 12:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756562;
        bh=E1znDqorjFAKd7cD//Xg1QRkHrQkWuqTbAWr7svadqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hg+Zj2lNKs4nYeWTQ5jcQZ59tRxt+1ZUtjhI9jPQIN1powbMKuC4vZNeIZF7gU3/3
         klEbKF1rk9PCDnfgSQgX0welYFeUpxHK3x6FZvxehdzcItnK8CV8gxPvA9Wb8pnlHg
         ZyCTxM5dw+0xTf2Jj5D/EmpKAYMTkODJhfChQ1BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 128/251] PM: hibernate: fix sparse warnings
Date:   Wed, 24 Nov 2021 12:56:10 +0100
Message-Id: <20211124115714.697051737@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 01de5fcd8b1ac0ca28d2bb0921226a54fdd62684 ]

When building the kernel with sparse enabled 'C=1' the following
warnings shows up:

kernel/power/swap.c:390:29: warning: incorrect type in assignment (different base types)
kernel/power/swap.c:390:29:    expected int ret
kernel/power/swap.c:390:29:    got restricted blk_status_t

This is due to function hib_wait_io() returns a 'blk_status_t' which is
a bitwise u8. Commit 5416da01ff6e ("PM: hibernate: Remove
blk_status_to_errno in hib_wait_io") seemed to have mixed up the return
type. However, the 4e4cbee93d56 ("block: switch bios to blk_status_t")
actually broke the behaviour by returning the wrong type.

Rework so function hib_wait_io() returns a 'int' instead of
'blk_status_t' and make sure to call function
blk_status_to_errno(hb->error)' when returning from function
hib_wait_io() a int gets returned.

Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
Fixes: 5416da01ff6e ("PM: hibernate: Remove blk_status_to_errno in hib_wait_io")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/swap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 2bd3670a093de..8b37085a66903 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -292,7 +292,7 @@ static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
 	return error;
 }
 
-static blk_status_t hib_wait_io(struct hib_bio_batch *hb)
+static int hib_wait_io(struct hib_bio_batch *hb)
 {
 	wait_event(hb->wait, atomic_read(&hb->count) == 0);
 	return blk_status_to_errno(hb->error);
-- 
2.33.0



