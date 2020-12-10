Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB462D5DFA
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390972AbgLJOfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:35:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390965AbgLJOfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:35:46 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 31/54] dm: remove invalid sparse __acquires and __releases annotations
Date:   Thu, 10 Dec 2020 15:27:08 +0100
Message-Id: <20201210142603.565252708@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit bde3808bc8c2741ad3d804f84720409aee0c2972 upstream.

Fixes sparse warnings:
drivers/md/dm.c:508:12: warning: context imbalance in 'dm_prepare_ioctl' - wrong count at exit
drivers/md/dm.c:543:13: warning: context imbalance in 'dm_unprepare_ioctl' - wrong count at exit

Fixes: 971888c46993f ("dm: hold DM table for duration of ioctl rather than use blkdev_get")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -495,7 +495,6 @@ out:
 
 static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 			    struct block_device **bdev)
-	__acquires(md->io_barrier)
 {
 	struct dm_target *tgt;
 	struct dm_table *map;
@@ -529,7 +528,6 @@ retry:
 }
 
 static void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
-	__releases(md->io_barrier)
 {
 	dm_put_live_table(md, srcu_idx);
 }


