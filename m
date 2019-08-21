Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9AC96F5A
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 04:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfHUCTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 22:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfHUCTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 22:19:03 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A6522DA7;
        Wed, 21 Aug 2019 02:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566353942;
        bh=hCqkQYLtLIcLQxsj9Faf1N08kF4Bj0HmBbtLea6LDRI=;
        h=Subject:To:From:Date:From;
        b=HneJyA/2CzXMxWaEn0TPIw5YTQIlvPgL+fH2DpBZEw4eBNMG3dFdaVruw2/WMIR37
         gA29+WQGV8bidCn0inWuqZwAUR1SYItqqv4MazU1w5TssZl6eJvDzYFMoOE4lm51W0
         n9ScMiPDfOlkKg6nM3mqbRSuvUNVaHZ411J5Pv4o=
Subject: patch "staging: erofs: avoid endless loop of invalid lookback distance 0" added to staging-testing
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 20 Aug 2019 19:18:46 -0700
Message-ID: <156635392615224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: erofs: avoid endless loop of invalid lookback distance 0

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 07ae24a38ac0254a5d955e4646806b756a426c0c Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 19 Aug 2019 18:34:26 +0800
Subject: staging: erofs: avoid endless loop of invalid lookback distance 0

As reported by erofs-utils fuzzer, Lookback distance should
be a positive number, so it should be actually looked back
rather than spinning.

Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-7-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/zmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index 7408e86823a4..774dacbc5b32 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -350,6 +350,12 @@ static int vle_extent_lookback(struct z_erofs_maprecorder *m,
 
 	switch (m->type) {
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		if (unlikely(!m->delta[0])) {
+			errln("invalid lookback distance 0 at nid %llu",
+			      vi->nid);
+			DBG_BUGON(1);
+			return -EFSCORRUPTED;
+		}
 		return vle_extent_lookback(m, m->delta[0]);
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 		map->m_flags &= ~EROFS_MAP_ZIPPED;
-- 
2.23.0


