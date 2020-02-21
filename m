Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38482167497
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387661AbgBUIWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388376AbgBUIWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:22:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DF342469D;
        Fri, 21 Feb 2020 08:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273372;
        bh=LO9osZihFUTbpG6o//SCjgXWqG9dLGPwwMhlrka+frI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THU0b81WdrI00j90vi0oBVOhfUVnrDo4UKbdOcoDCCJXDrKk6gNyTIC+A9hXskGlm
         HqbYTEfT5E/MYdGsg/azPYN0XhOitumEdWYOH8QjAbU6rYLIFZpW9XOhk4hwL/aKul
         afTUCkc8rMTPU5vbTGmagYKE8t9VNuRAGsg2zIRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, philip@philip-seeger.de,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/191] btrfs: device stats, log when stats are zeroed
Date:   Fri, 21 Feb 2020 08:41:59 +0100
Message-Id: <20200221072308.109191972@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit a69976bc69308aa475d0ba3b8b3efd1d013c0460 ]

We had a report indicating that some read errors aren't reported by the
device stats in the userland. It is important to have the errors
reported in the device stat as user land scripts might depend on it to
take the reasonable corrective actions. But to debug these issue we need
to be really sure that request to reset the device stat did not come
from the userland itself. So log an info message when device error reset
happens.

For example:
 BTRFS info (device sdc): device stats zeroed by btrfs(9223)

Reported-by: philip@philip-seeger.de
Link: https://www.spinics.net/lists/linux-btrfs/msg96528.html
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5bbcdcff68a9e..9c3b394b99fa2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7260,6 +7260,8 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			else
 				btrfs_dev_stat_reset(dev, i);
 		}
+		btrfs_info(fs_info, "device stats zeroed by %s (%d)",
+			   current->comm, task_pid_nr(current));
 	} else {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
 			if (stats->nr_items > i)
-- 
2.20.1



