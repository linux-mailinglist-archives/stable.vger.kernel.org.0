Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D4443D6A
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 07:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhKCGwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 02:52:17 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59842 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhKCGwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 02:52:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 05557218DF;
        Wed,  3 Nov 2021 06:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635922180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BeqVs7y0PI+aBH3DeB1M2f+3yZUqahLHqE7Hzgy+EJo=;
        b=R5L4WQK+wXV3nHvLJ4hHEsR9nLyxOTg9Z3Q/+zV6LZa6hhohX0GYVU9vmVhaRVopX4tkXp
        V6keVBoNWjK6RDrW7bDbfltv/lrOw6077qdg3ikuehx/AuYCKesh/eGo9oGLiwdUPc4Rto
        zcOmzkGcTcKTdhyLZWINlJLd6JRh6nM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635922180;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BeqVs7y0PI+aBH3DeB1M2f+3yZUqahLHqE7Hzgy+EJo=;
        b=VtGgvg151s/10ETivKGWnzhWyHA0G7328V47y5IgzURZugzaOk1/HoWlaPK3ufg6fKcp1D
        8reQg+in1gmopJBA==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id D7C2C2C150;
        Wed,  3 Nov 2021 06:49:37 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] bcache: fix use-after-free problem in bcache_device_free()
Date:   Wed,  3 Nov 2021 14:49:17 +0800
Message-Id: <20211103064917.67383-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4a9a65dff95e..86b9e355c583 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -885,9 +885,9 @@ static void bcache_device_free(struct bcache_device *d)
 		bcache_device_detach(d);
 
 	if (disk) {
-		blk_cleanup_disk(disk);
 		ida_simple_remove(&bcache_device_idx,
 				  first_minor_to_idx(disk->first_minor));
+		blk_cleanup_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);
-- 
2.31.1

