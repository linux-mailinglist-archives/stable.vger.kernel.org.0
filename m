Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085B43714BE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhECMAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233626AbhECMA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48FC61278;
        Mon,  3 May 2021 11:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043174;
        bh=q78sN2W/344fYcwHpZVu2QIpgb1rKBZ7O1PO8saM2II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Apqc7f2xk2e4IzySMlfYtFjipxEDGndkIRIlXybRHkgDphKSOU2T26xYE1r5yo/OD
         Ikvy5lMW7RkPlKoztexcLnazfMSa1Z7qq7WehgMQfNosb1X9XHj68xpAam+kcuGTEc
         DIg45JvJ40C6oPiobw7PfvUQ4hd4Irj0DsF4hD7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wenwen Wang <wang6495@umn.edu>, Peter Rosin <peda@axentia.se>,
        Jens Axboe <axboe@kernel.dk>, stable <stable@vger.kernel.org>
Subject: [PATCH 26/69] Revert "gdrom: fix a memory leak bug"
Date:   Mon,  3 May 2021 13:56:53 +0200
Message-Id: <20210503115736.2104747-27-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/gdrom.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 742b4a0932e3..7f681320c7d3 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -862,7 +862,6 @@ static void __exit exit_gdrom(void)
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
 	kfree(gd.toc);
-	kfree(gd.cd_info);
 }
 
 module_init(init_gdrom);
-- 
2.31.1

