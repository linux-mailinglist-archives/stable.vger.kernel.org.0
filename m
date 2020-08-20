Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BFD24B37F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgHTJsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbgHTJsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E19012078D;
        Thu, 20 Aug 2020 09:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916884;
        bh=qJmEpL7tQCrTn65OLAj/uvcxZFClayXp+iHkQUQEPGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMmfbVHy0aqOHWroCYr6hDJUcjLmk0XVNTu7JUy6TqaFIWETygrCsZ6HFHqzqDdMW
         3lFcl6qUrffhqwWVFaL7/vnUmbEXSo2CohimgsZ/7mO+GQUOZGuKo4uHWuMi144eT5
         6ioeIQIT6wFVDxoEjQqVYZaw+dJ1z2QYBHX8p0pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 051/152] ext2: fix missing percpu_counter_inc
Date:   Thu, 20 Aug 2020 11:20:18 +0200
Message-Id: <20200820091556.333647768@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit bc2fbaa4d3808aef82dd1064a8e61c16549fe956 upstream.

sbi->s_freeinodes_counter is only decreased by the ext2 code, it is never
increased. This patch fixes it.

Note that sbi->s_freeinodes_counter is only used in the algorithm that
tries to find the group for new allocations, so this bug is not easily
visible (the only visibility is that the group finding algorithm selects
inoptinal result).

Link: https://lore.kernel.org/r/alpine.LRH.2.02.2004201538300.19436@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext2/ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -80,6 +80,7 @@ static void ext2_release_inode(struct su
 	if (dir)
 		le16_add_cpu(&desc->bg_used_dirs_count, -1);
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
+	percpu_counter_inc(&EXT2_SB(sb)->s_freeinodes_counter);
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
 	mark_buffer_dirty(bh);
@@ -528,7 +529,7 @@ got:
 		goto fail;
 	}
 
-	percpu_counter_add(&sbi->s_freeinodes_counter, -1);
+	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
 


