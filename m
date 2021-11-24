Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126E745C5CA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353050AbhKXOAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355721AbhKXN6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E6DC633E5;
        Wed, 24 Nov 2021 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759307;
        bh=wPPOdLjqMWK95/PtIkbeEP2lxKIHa8CXAALtrWh4oNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqW8+Dha5hBaW74hTTDLwHCj5dejY5OJEgwCAv+HuR0IBlnBj+D/TgPPBO4oOgwFe
         5xDA881nXSKDtXpVvoPhqSO9xFgAq5ak5pP1XAOIHS3mNfkw0eYo3eKh/O7XfFyS8y
         ObOvyXqt6Z7iXZ7U1wtjawD520KjzcoXqUR1Uzgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 190/279] pstore/blk: Use "%lu" to format unsigned long
Date:   Wed, 24 Nov 2021 12:57:57 +0100
Message-Id: <20211124115725.289261984@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 61eb495c83bf6ebde490992bf888ca15b9babc39 upstream.

On 32-bit:

    fs/pstore/blk.c: In function ‘__best_effort_init’:
    include/linux/kern_levels.h:5:18: warning: format ‘%zu’ expects argument of type ‘size_t’, but argument 3 has type ‘long unsigned int’ [-Wformat=]
	5 | #define KERN_SOH "\001"  /* ASCII Start Of Header */
	  |                  ^~~~~~
    include/linux/kern_levels.h:14:19: note: in expansion of macro ‘KERN_SOH’
       14 | #define KERN_INFO KERN_SOH "6" /* informational */
	  |                   ^~~~~~~~
    include/linux/printk.h:373:9: note: in expansion of macro ‘KERN_INFO’
      373 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
	  |         ^~~~~~~~~
    fs/pstore/blk.c:314:3: note: in expansion of macro ‘pr_info’
      314 |   pr_info("attached %s (%zu) (no dedicated panic_write!)\n",
	  |   ^~~~~~~

Cc: stable@vger.kernel.org
Fixes: 7bb9557b48fcabaa ("pstore/blk: Use the normal block device I/O path")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210629103700.1935012-1-geert@linux-m68k.org
Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pstore/blk.c
+++ b/fs/pstore/blk.c
@@ -311,7 +311,7 @@ static int __init __best_effort_init(voi
 	if (ret)
 		kfree(best_effort_dev);
 	else
-		pr_info("attached %s (%zu) (no dedicated panic_write!)\n",
+		pr_info("attached %s (%lu) (no dedicated panic_write!)\n",
 			blkdev, best_effort_dev->zone.total_size);
 
 	return ret;


