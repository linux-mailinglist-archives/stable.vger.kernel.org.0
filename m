Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F145C07F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344753AbhKXNJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347221AbhKXNHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:07:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDEA361A10;
        Wed, 24 Nov 2021 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757508;
        bh=71r4SbZkS6aYV5jKBEMUXtQqVbIcn/ywhKN8whfw9Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbeAWrLgmW6UWcSIfj/a5AiFOjG8L47ZMQ+tLnX2mGSxw5lKk+UIDm0jfGRJtx71W
         2H8At71bf9Sx+pKHB1o0rtldi96wGouxplwi+VQWBUUzpsUWNymYQEICPbgiS95gKA
         SzEB0rzehCOa6nga5V9ekllL7+L9Be/g4LOWPETk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/323] PM: hibernate: fix sparse warnings
Date:   Wed, 24 Nov 2021 12:55:49 +0100
Message-Id: <20211124115724.295533957@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index b5b97df142d26..9db7f2f93fae3 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -294,7 +294,7 @@ static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
 	return error;
 }
 
-static blk_status_t hib_wait_io(struct hib_bio_batch *hb)
+static int hib_wait_io(struct hib_bio_batch *hb)
 {
 	wait_event(hb->wait, atomic_read(&hb->count) == 0);
 	return blk_status_to_errno(hb->error);
-- 
2.33.0



