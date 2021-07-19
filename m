Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3F43CDC24
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbhGSOva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344399AbhGSOsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CD266141D;
        Mon, 19 Jul 2021 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708522;
        bh=HGVxpG2ereOq6wSEgejV16fHWTFXBqNPC0DH/gBNWFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUJ1SrGZnYh4MJaMpjj1b3AYgViM3dbSbIqICF1Ma10W5nKMCnjXe4xF5pJ+3Q/ED
         f8QWkMkvMabOSnjWVRVswWDxK8YQAl4FXiKEf+ANBCZa+Ud3Y5KUaT7yhE8WVQMywF
         +TiEPIoKxQjdDRzS+ponp9LwZi/HCMAH8syiLHh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 025/421] ext4: use ext4_grp_locked_error in mb_find_extent
Date:   Mon, 19 Jul 2021 16:47:16 +0200
Message-Id: <20210719144947.130737717@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Brennan <stephen.s.brennan@oracle.com>

commit cd84bbbac12a173a381a64c6ec8b76a5277b87b5 upstream.

Commit 5d1b1b3f492f ("ext4: fix BUG when calling ext4_error with locked
block group") introduces ext4_grp_locked_error to handle unlocking a
group in error cases. Otherwise, there is a possibility of a sleep while
atomic. However, since 43c73221b3b1 ("ext4: replace BUG_ON with WARN_ON
in mb_find_extent()"), mb_find_extent() has contained a ext4_error()
call while a group spinlock is held. Replace this with
ext4_grp_locked_error.

Fixes: 43c73221b3b1 ("ext4: replace BUG_ON with WARN_ON in mb_find_extent()")
Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Link: https://lore.kernel.org/r/20210623232114.34457-1-stephen.s.brennan@oracle.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1542,10 +1542,11 @@ static int mb_find_extent(struct ext4_bu
 	if (ex->fe_start + ex->fe_len > EXT4_CLUSTERS_PER_GROUP(e4b->bd_sb)) {
 		/* Should never happen! (but apparently sometimes does?!?) */
 		WARN_ON(1);
-		ext4_error(e4b->bd_sb, "corruption or bug in mb_find_extent "
-			   "block=%d, order=%d needed=%d ex=%u/%d/%d@%u",
-			   block, order, needed, ex->fe_group, ex->fe_start,
-			   ex->fe_len, ex->fe_logical);
+		ext4_grp_locked_error(e4b->bd_sb, e4b->bd_group, 0, 0,
+			"corruption or bug in mb_find_extent "
+			"block=%d, order=%d needed=%d ex=%u/%d/%d@%u",
+			block, order, needed, ex->fe_group, ex->fe_start,
+			ex->fe_len, ex->fe_logical);
 		ex->fe_len = 0;
 		ex->fe_start = 0;
 		ex->fe_group = 0;


