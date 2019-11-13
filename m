Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65E9FA4DA
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbfKMCTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbfKMBzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB23222CD;
        Wed, 13 Nov 2019 01:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610115;
        bh=RCewstX/TBOlPvkRFaX/7Ew/LarAdpNmJALeRfGKJbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/YIf6MvxCchCITZ/o25tzebTttbOQIAKl/yiuVPkhmP3HDrfHN3kIdQaW9pvRAQ9
         UQE8iTZUuMAYMyvkS3BvUPlaep2t+zOrBpNWzLOU/0GNA0udnhMHp/ohU9czjVG7M8
         2rCsLxKihBwKbDPCTTuf4Qjgk4LvDIYfcwoQcVyw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Holmberg <hans.holmberg@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 171/209] lightnvm: pblk: fix write amplificiation calculation
Date:   Tue, 12 Nov 2019 20:49:47 -0500
Message-Id: <20191113015025.9685-171-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Holmberg <hans.holmberg@cnexlabs.com>

[ Upstream commit 765462fa4c4d0fd3eb718f2ba14cb04c35219854 ]

When the user data counter exceeds 32 bits, the write amplification
calculation does not provide the right value. Fix this by using
div64_u64 in stead of div64.

Fixes: 76758390f83e ("lightnvm: pblk: export write amplification counters to sysfs")
Signed-off-by: Hans Holmberg <hans.holmberg@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/lightnvm/pblk-sysfs.c b/drivers/lightnvm/pblk-sysfs.c
index 8d2ed510c04b3..bdc86ee4c7793 100644
--- a/drivers/lightnvm/pblk-sysfs.c
+++ b/drivers/lightnvm/pblk-sysfs.c
@@ -343,7 +343,6 @@ static ssize_t pblk_get_write_amp(u64 user, u64 gc, u64 pad,
 {
 	int sz;
 
-
 	sz = snprintf(page, PAGE_SIZE,
 			"user:%lld gc:%lld pad:%lld WA:",
 			user, gc, pad);
@@ -355,7 +354,7 @@ static ssize_t pblk_get_write_amp(u64 user, u64 gc, u64 pad,
 		u32 wa_frac;
 
 		wa_int = (user + gc + pad) * 100000;
-		wa_int = div_u64(wa_int, user);
+		wa_int = div64_u64(wa_int, user);
 		wa_int = div_u64_rem(wa_int, 100000, &wa_frac);
 
 		sz += snprintf(page + sz, PAGE_SIZE - sz, "%llu.%05u\n",
-- 
2.20.1

