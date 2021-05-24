Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DE238ED92
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhEXPjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233513AbhEXPg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 377CF6141D;
        Mon, 24 May 2021 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870381;
        bh=XHYPZJ9WXzLB6L2N7zgeqXGZs7Z4Kofy3XAQaQOe2DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdE2yteXlcYuHPRt0IFZpOYxztHcQg7jthMIf0tfDvpcsJQi9awQa0ZpKQrfw8UlF
         DbIiwVGpSwN1QWcvrPoznBv39rrcnpfA67MaRRWPaJAqHOC+lC2tC86rWepVR7qLW5
         prnoAySrh5HQGpgvdBXrWzxZnupqEY5dNiXdkz2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Peter Rosin <peda@axentia.se>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 21/36] Revert "gdrom: fix a memory leak bug"
Date:   Mon, 24 May 2021 17:25:06 +0200
Message-Id: <20210524152324.841767227@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
References: <20210524152324.158146731@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 257343d3ed557f11d580d0b7c515dc154f64a42b upstream.

This reverts commit 093c48213ee37c3c3ff1cf5ac1aa2a9d8bc66017.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: Wenwen Wang <wang6495@umn.edu>
Cc: Peter Rosin <peda@axentia.se>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 093c48213ee3 ("gdrom: fix a memory leak bug")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-27-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/gdrom.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -882,7 +882,6 @@ static void __exit exit_gdrom(void)
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
 	kfree(gd.toc);
-	kfree(gd.cd_info);
 }
 
 module_init(init_gdrom);


