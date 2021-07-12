Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B833C47FC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhGLGfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237806AbhGLGex (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B58610E6;
        Mon, 12 Jul 2021 06:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071501;
        bh=cDTbJhtT1KZywLOqfgUcrky/28iSPtnpqMoS9+aEOuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuVxzixkzJQgUAoM5EebQhrv9A4MPCdXXBrhk/+gD9dnxlemN/E26VIL+qu0bXQF9
         fKgx4gQHgaxKuv9tG7Bt6Is3Fr0/7dMvIqSqxkT8qjf9/jnHGnaHpBpg75TKxfnHqd
         BpizP6nIlgiq2nwv4/VIe+1W0Ij+qeitqVUlxoPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Lindroth <thomas.lindroth@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 096/593] fuse: ignore PG_workingset after stealing
Date:   Mon, 12 Jul 2021 08:04:16 +0200
Message-Id: <20210712060853.774648843@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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


