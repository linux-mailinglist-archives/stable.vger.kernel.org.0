Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84ACB106E67
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbfKVLES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730923AbfKVLEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3DD2084D;
        Fri, 22 Nov 2019 11:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420655;
        bh=RCewstX/TBOlPvkRFaX/7Ew/LarAdpNmJALeRfGKJbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M53mCO3uhJz+e6mijFDCdfLRGVIGnCzaZGwRfpi/rzV0rSPIL6RCeQQJ/ss65slyK
         Hb4jo+vsBQB7i7+UzBaE8V0Bokl3X1H4OgAfHsTqMBEAZ+BVmrlYJKFHWdwzsno2gK
         MJrpJA9fyoa4mEVLOZv0RRwwckFWmeZtsRn86+BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Holmberg <hans.holmberg@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 182/220] lightnvm: pblk: fix write amplificiation calculation
Date:   Fri, 22 Nov 2019 11:29:07 +0100
Message-Id: <20191122100927.382284687@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



