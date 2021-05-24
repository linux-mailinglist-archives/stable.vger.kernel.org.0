Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048E038EE83
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhEXPvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234647AbhEXPtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC6761482;
        Mon, 24 May 2021 15:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870671;
        bh=3ZeiDhm+spCnfo9ewsHEmaH16QnaJG53j5HVpSGOSaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NntM6VlDr/z+7ntR3wMN+XT0yx621HlJkLhl+DDuNyiqByToALjkOohDhLQmb/mR1
         BdL8r8xK3i4lfN6BAQL+t8vE4IEInnz7pt304tGt8Je0+oFyLDNHd7XgUp3yFkdlE6
         mnBvKfTBQqyJDNOTlLTBEiICcYMI/DqKgIhClw/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Peter Rosin <peda@axentia.se>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 51/71] Revert "gdrom: fix a memory leak bug"
Date:   Mon, 24 May 2021 17:25:57 +0200
Message-Id: <20210524152328.117780704@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
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
@@ -860,7 +860,6 @@ static void __exit exit_gdrom(void)
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
 	kfree(gd.toc);
-	kfree(gd.cd_info);
 }
 
 module_init(init_gdrom);


