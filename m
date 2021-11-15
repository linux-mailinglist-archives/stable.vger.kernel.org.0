Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239E94514D0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346070AbhKOUNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345072AbhKOT0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E61663713;
        Mon, 15 Nov 2021 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003389;
        bh=AtRP5XiR+CgkAOFjl+aDTVB6Zga+m98wcHP/Bzqj6Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cb7ghgIqR7D+OGV7A2ZaU8CITqFJSDprnlAi+f2DfsJq2fWVkRWFux+e1FtCQ0N6z
         Vux1vstqiK7QJj81tVB16pL2FeYWg0/ISyCS4RclL+D7nhRCM0bgWtJehlroXr7xxJ
         JB3wap3nbwcZeYsoJZkU4NcVzQNjo+LT8plmx5f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 884/917] bcache: fix use-after-free problem in bcache_device_free()
Date:   Mon, 15 Nov 2021 18:06:19 +0100
Message-Id: <20211115165459.028711455@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 8468f45091d2866affed6f6a7aecc20779139173 upstream.

In bcache_device_free(), pointer disk is referenced still in
ida_simple_remove() after blk_cleanup_disk() gets called on this
pointer. This may cause a potential panic by use-after-free on the
disk pointer.

This patch fixes the problem by calling blk_cleanup_disk() after
ida_simple_remove().

Fixes: bc70852fd104 ("bcache: convert to blk_alloc_disk/blk_cleanup_disk")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable@vger.kernel.org # v5.14+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211103064917.67383-1-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -885,9 +885,9 @@ static void bcache_device_free(struct bc
 		bcache_device_detach(d);
 
 	if (disk) {
-		blk_cleanup_disk(disk);
 		ida_simple_remove(&bcache_device_idx,
 				  first_minor_to_idx(disk->first_minor));
+		blk_cleanup_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);


