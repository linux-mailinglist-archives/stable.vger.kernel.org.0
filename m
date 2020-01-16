Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530A813FF60
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389456AbgAPX0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388576AbgAPX0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE8E620684;
        Thu, 16 Jan 2020 23:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217195;
        bh=IL/aoOh9AuCGQjJL/BwlrmEDOqzkzTyXv6qi+8K5jeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njlNV4PsNYKDnRvRivjguaXbqXF0ArjmozNq03pKkhBXwer8FG1zvIJ74tPKoz/Sp
         JfjQeZ7a9TzB/TytECemUtyAAM4m9Pqt/23HWUFuFVWYdkAyGmiWX27LK0Uk2z4mbh
         1TVSS9b0P/fTn1nDbh3UGsBuTTDBZsvgKxK5CMb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Richard Weinberger <richard@nod.at>,
        Romain Izard <romain.izard.pro@gmail.com>
Subject: [PATCH 5.4 162/203] Revert "ubifs: Fix memory leak bug in alloc_ubifs_info() error path"
Date:   Fri, 17 Jan 2020 00:17:59 +0100
Message-Id: <20200116231758.872830984@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

commit 91cbf01178c37086b32148c53e24b04cb77557cf upstream.

This reverts commit 9163e0184bd7d5f779934d34581843f699ad2ffd.

At the point when ubifs_fill_super() runs, we have already a reference
to the super block. So upon deactivate_locked_super() c will get
free()'ed via ->kill_sb().

Cc: Wenwen Wang <wenwen@cs.uga.edu>
Fixes: 9163e0184bd7 ("ubifs: Fix memory leak bug in alloc_ubifs_info() error path")
Reported-by: https://twitter.com/grsecurity/status/1180609139359277056
Signed-off-by: Richard Weinberger <richard@nod.at>
Tested-by: Romain Izard <romain.izard.pro@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2267,10 +2267,8 @@ static struct dentry *ubifs_mount(struct
 		}
 	} else {
 		err = ubifs_fill_super(sb, data, flags & SB_SILENT ? 1 : 0);
-		if (err) {
-			kfree(c);
+		if (err)
 			goto out_deact;
-		}
 		/* We do not support atime */
 		sb->s_flags |= SB_ACTIVE;
 		if (IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))


