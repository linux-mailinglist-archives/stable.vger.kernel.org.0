Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE12205FB6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391673AbgFWUfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391670AbgFWUfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:35:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63DA52080C;
        Tue, 23 Jun 2020 20:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944521;
        bh=LpdBqfnHy9Us/Raz3M4gjLPdYu6w6ISBSDI2DIDW4Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxyNKOVTSSfl77aArEx3FBprilnEL5PN9buHyFX0UEh8AC9q8jmTedOgSlXsAN80S
         /B78JclOgSwk3XQzRdmj1NsFHrlN8ps2zEHDgXooXPwNAwkglcGoWuc4a3Cpr44yo1
         42meP75AP1xIM5GYwvgeFciQ2i9FgUOlPhhAqm7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/206] dm mpath: switch paths in dm_blk_ioctl() code path
Date:   Tue, 23 Jun 2020 21:55:50 +0200
Message-Id: <20200623195318.068661931@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 207ca0ad0b59d..c1ad84f3414cd 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1868,7 +1868,7 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 	int r;
 
 	current_pgpath = READ_ONCE(m->current_pgpath);
-	if (!current_pgpath)
+	if (!current_pgpath || !test_bit(MPATHF_QUEUE_IO, &m->flags))
 		current_pgpath = choose_pgpath(m, 0);
 
 	if (current_pgpath) {
-- 
2.25.1



