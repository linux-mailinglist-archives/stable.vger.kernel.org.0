Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF26B2015
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389726AbfIMNPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389732AbfIMNPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:45 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C571F206BB;
        Fri, 13 Sep 2019 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380545;
        bh=zFskO4KDNb4IBX5Ugsg8jZrG6R4mDRf3CfSFygV7v6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLtrzLJ9JTXr0UiTB32dvHpK4cih1LH6bf9I9okIUMuLFTKhfEQdb/pfwCtlnD9pK
         RrtfqMPnYoeAfyZ5iVSiIjn/1LZ3c17C9XfnM2IO/nF+trDe96YqGOG680K0Tjc0DF
         ZDi7q0NCIQvx4AOXe4V/iHcccvYfHCc5Dag9MGPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/190] btrfs: scrub: pass fs_info to scrub_setup_ctx
Date:   Fri, 13 Sep 2019 14:05:54 +0100
Message-Id: <20190913130607.519210914@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 92f7ba434f51e8e9317f1d166105889aa230abd2 ]

We can pass fs_info directly as this is the only member of btrfs_device
that's bing used inside scrub_setup_ctx.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 5a2d10ba747f7..efaad3e1b295a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -578,12 +578,11 @@ static void scrub_put_ctx(struct scrub_ctx *sctx)
 		scrub_free_ctx(sctx);
 }
 
-static noinline_for_stack
-struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
+static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
+		struct btrfs_fs_info *fs_info, int is_dev_replace)
 {
 	struct scrub_ctx *sctx;
 	int		i;
-	struct btrfs_fs_info *fs_info = dev->fs_info;
 
 	sctx = kzalloc(sizeof(*sctx), GFP_KERNEL);
 	if (!sctx)
@@ -592,7 +591,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	sctx->is_dev_replace = is_dev_replace;
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
-	sctx->fs_info = dev->fs_info;
+	sctx->fs_info = fs_info;
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -3881,7 +3880,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return ret;
 	}
 
-	sctx = scrub_setup_ctx(dev, is_dev_replace);
+	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
 	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-- 
2.20.1



