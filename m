Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A71137CFA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgAKJvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:51:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgAKJvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:51:52 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E62CF2082E;
        Sat, 11 Jan 2020 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736312;
        bh=+omM7I4KuuuOfeolNeiCmQdWML8/9kyeNwCQLH73fBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bD3MIRrJtVQlJoWF1yy6QL9RSmuDIP1eX+yaCh2U9JJJTNSR3jYApeCJsOKaj4iEs
         gMSr75spwx7WfHSD1NlQMhZ3h3snEv+dWn5JThuLqOZa/4jkVjApuiPIshxi28TswH
         iAgzhiEan1/8YBLhgQnuCja+SNG2x1xmYBgP+V+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/59] md: raid1: check rdev before reference in raid1_sync_request func
Date:   Sat, 11 Jan 2020 10:49:17 +0100
Message-Id: <20200111094838.711326636@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

[ Upstream commit 028288df635f5a9addd48ac4677b720192747944 ]

In raid1_sync_request func, rdev should be checked before reference.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index abb99515068b..096f3a2ba524 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2630,7 +2630,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 				write_targets++;
 			}
 		}
-		if (bio->bi_end_io) {
+		if (rdev && bio->bi_end_io) {
 			atomic_inc(&rdev->nr_pending);
 			bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
-- 
2.20.1



