Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194FF111ECC
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfLCXEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbfLCWv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667C120848;
        Tue,  3 Dec 2019 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413486;
        bh=5gjQcy1uCeHv3kcTvk63snX8+Meqz8nr+0fnMmrMqBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soNdmgPQ+Fv4085eszI/KX+wtxwVZCni/CuaZzLxWwRHifQGzs26rjRa9Rfk4Fj3q
         7vQRmmujMUQD7kug593UtkyKQY7KFICWC+kIHuAuYCAyZxTPmNYQVZzlyokjpl+vOn
         Fs+h36m/NAcXuqyy36tXcELsGhPB8EFZgzmp5zzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/321] dm raid: fix false -EBUSY when handling check/repair message
Date:   Tue,  3 Dec 2019 23:33:32 +0100
Message-Id: <20191203223434.749778331@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit 74694bcbdf7e28a5ad548cdda9ac56d30be00d13 ]

Sending a check/repair message infrequently leads to -EBUSY instead of
properly identifying an active resync.  This occurs because
raid_message() is testing recovery bits in a racy way.

Fix by calling decipher_sync_action() from raid_message() to properly
identify the idle state of the RAID device.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 6c9b542882613..23de59a692c51 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3690,8 +3690,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_reap_sync_thread(mddev);
 		}
-	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
 	else if (!strcasecmp(argv[0], "resync"))
 		; /* MD_RECOVERY_NEEDED set below */
-- 
2.20.1



