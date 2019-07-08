Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C9E6227C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388777AbfGHP0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388791AbfGHP0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 607062166E;
        Mon,  8 Jul 2019 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599578;
        bh=guJo8kQuNGCLr9IcAC48ivEXO+m7e0YNXbz8SATXBW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsWvngfjgFWWVBtahIQfeeEPDQjm8V/loCwWLhWg1KhVQvy1jE3fVGGG4QogqHKFQ
         EpeRBlYLYx9717WXXGcJdyhNKgnct6T4oKzOcD0LO00S2Y05cDS9zB7ctfn/ry24OC
         GGBaEohud9mY7gEiwum4S04upHuE+ADF0fAv07ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-btrfs@vger.kernel.org,
        Olivier Mazouffre <olivier.mazouffre@ims-bordeaux.fr>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4.14 56/56] stable/btrfs: fix backport bug in d819d97ea025 ("btrfs: honor path->skip_locking in backref code")
Date:   Mon,  8 Jul 2019 17:13:48 +0200
Message-Id: <20190708150524.341162307@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

Upstream commit 38e3eebff643 ("btrfs: honor path->skip_locking in
backref code") was incorrectly backported to 4.14.y . It misses removal
of two lines from original commit, what cause deadlock.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203993
Reported-by: Olivier Mazouffre <olivier.mazouffre@ims-bordeaux.fr>
Fixes: d819d97ea025 ("btrfs: honor path->skip_locking in backref code")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1290,8 +1290,6 @@ again:
 					ret = -EIO;
 					goto out;
 				}
-				btrfs_tree_read_lock(eb);
-				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				if (!path->skip_locking) {
 					btrfs_tree_read_lock(eb);
 					btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);


