Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577533C4C48
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhGLHDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241202AbhGLHAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19E916052B;
        Mon, 12 Jul 2021 06:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073071;
        bh=cDTbJhtT1KZywLOqfgUcrky/28iSPtnpqMoS9+aEOuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhXRqRHTQu/CVKLPS+52JN+QKeJaw7/goaS+NT0tbhqjFc2st0P6/Z+tdBv4oTkek
         xdXgEcNbqIL8AZeVHpTskH+C0/MG9+40jPu/UqDAMT7GIxxzASBuX6bT0AX67ZaKME
         RuimWwzoN/hLbaXOgMwVZyl4QNgbmWbuBntEsMQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Lindroth <thomas.lindroth@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.12 115/700] fuse: ignore PG_workingset after stealing
Date:   Mon, 12 Jul 2021 08:03:18 +0200
Message-Id: <20210712060941.172806383@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit b89ecd60d38ec042d63bdb376c722a16f92bcb88 upstream.

Fix the "fuse: trying to steal weird page" warning.

Description from Johannes Weiner:

  "Think of it as similar to PG_active. It's just another usage/heat
   indicator of file and anon pages on the reclaim LRU that, unlike
   PG_active, persists across deactivation and even reclaim (we store it in
   the page cache / swapper cache tree until the page refaults).

   So if fuse accepts pages that can legally have PG_active set,
   PG_workingset is fine too."

Reported-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Fixes: 1899ad18c607 ("mm: workingset: tell cache transitions from workingset thrashing")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -783,6 +783,7 @@ static int fuse_check_page(struct page *
 	       1 << PG_uptodate |
 	       1 << PG_lru |
 	       1 << PG_active |
+	       1 << PG_workingset |
 	       1 << PG_reclaim |
 	       1 << PG_waiters))) {
 		dump_page(page, "fuse: trying to steal weird page");


