Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6372B1FE8AA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgFRBJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgFRBJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D3F521D79;
        Thu, 18 Jun 2020 01:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442549;
        bh=aQ+s8ER3hoBSa3ufxybtu7BNUAdGWVj2UOglNEeqrkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Futf6twzzErxSNRzzl8puiYgpoZ0a3K2UBu7t8gjG6VHtOexbil5+Wj3YhBGwOdCV
         jwy84lLPURfYlcd+8C15GyUBZi9+v1vcx+ZcG0gvuHTSPlWxhF+0tQrammOSSgGblb
         tKlh8bL8MiC/8CMzHNAQS1NFGwIQcxDrklCVgtRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.7 047/388] dm mpath: switch paths in dm_blk_ioctl() code path
Date:   Wed, 17 Jun 2020 21:02:24 -0400
Message-Id: <20200618010805.600873-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 2361ae595352dec015d14292f1b539242d8446d6 ]

SCSI LUN passthrough code such as qemu's "scsi-block" device model
pass every IO to the host via SG_IO ioctls. Currently, dm-multipath
calls choose_pgpath() only in the block IO code path, not in the ioctl
code path (unless current_pgpath is NULL). This has the effect that no
path switching and thus no load balancing is done for SCSI-passthrough
IO, unless the active path fails.

Fix this by using the same logic in multipath_prepare_ioctl() as in
multipath_clone_and_map().

Note: The allegedly best path selection algorithm, service-time,
still wouldn't work perfectly, because the io size of the current
request is always set to 0. Changing that for the IO passthrough
case would require the ioctl cmd and arg to be passed to dm's
prepare_ioctl() method.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3e500098132f..e0c800cf87a9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1918,7 +1918,7 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 	int r;
 
 	current_pgpath = READ_ONCE(m->current_pgpath);
-	if (!current_pgpath)
+	if (!current_pgpath || !test_bit(MPATHF_QUEUE_IO, &m->flags))
 		current_pgpath = choose_pgpath(m, 0);
 
 	if (current_pgpath) {
-- 
2.25.1

