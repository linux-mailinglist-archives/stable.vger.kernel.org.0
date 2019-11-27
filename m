Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C5510BA24
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfK0VAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731269AbfK0VAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:00:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6FD92154A;
        Wed, 27 Nov 2019 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888417;
        bh=IjvQhKnlcixplGYef5OlTSVczlEn23RmU4lkJjnJ5sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv/WpRHFnAhcuKpHJxWY9wo2axTx7BrC/k1lCrlshKMX6ZGqXi66e8INfgI5xgZRI
         O2IetCYs5+1NQoZj60r0KqsWdb9tbSolczn8svkpSu/POcqLA0TmKG+KcYI9hztWEX
         pYdkKf8rqUyp01VMErMcMjY7XoueisowiL6O3IE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/306] dm raid: avoid bitmap with raid4/5/6 journal device
Date:   Wed, 27 Nov 2019 21:29:09 +0100
Message-Id: <20191127203122.125456304@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit d857ad75edf3c0066fcd920746f9dc75382b3324 ]

With raid4/5/6, journal device and write intent bitmap are mutually exclusive.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b78a8a4d061ca..6c9b542882613 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2475,7 +2475,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	}
 
 	/* Enable bitmap creation for RAID levels != 0 */
-	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
+	mddev->bitmap_info.offset = (rt_is_raid0(rs->raid_type) || rs->journal_dev.dev) ? 0 : to_sector(4096);
 	mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
 	if (!test_and_clear_bit(FirstUse, &rdev->flags)) {
-- 
2.20.1



