Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A1F1675D4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733060AbgBUIOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732691AbgBUIOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:14:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4949220578;
        Fri, 21 Feb 2020 08:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272841;
        bh=OJ3QoIR3qxJpH00wRqFPDjc6ftqQZW1lGIxutzeBQR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nioc86XoMAvPamyLHLm9nAA97cGmXzPC8i4YoVUoSFzMki/fxKiSru3o7xfL4YnrK
         NflNbE8UShoRmOu6R0sH5NjxIk+IJV2QYhftupqh4Vw0DKG+5qFo2oJlkNnh6dW3QE
         zppAsJuyHNtkmXYP2k+cn+dvmA+WNJj1NL1B2DlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, philip@philip-seeger.de,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 266/344] btrfs: device stats, log when stats are zeroed
Date:   Fri, 21 Feb 2020 08:41:05 +0100
Message-Id: <20200221072413.816390924@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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
index f7d9fc1a6fc2f..9ab3ae5df3005 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7561,6 +7561,8 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			else
 				btrfs_dev_stat_set(dev, i, 0);
 		}
+		btrfs_info(fs_info, "device stats zeroed by %s (%d)",
+			   current->comm, task_pid_nr(current));
 	} else {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
 			if (stats->nr_items > i)
-- 
2.20.1



