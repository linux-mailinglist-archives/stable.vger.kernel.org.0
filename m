Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5570A3714BF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhECMAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233705AbhECMA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 520B86137D;
        Mon,  3 May 2021 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043176;
        bh=f+J85lZkGvA2uJMgWYEZNfvAuLMP8vHjqMAx3ZpNd3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmDGoiGupb9SxpQHhWs2kjjyw9DqoaHmzRtAuH60hRObu6Ki89af126SOhmNy4eJw
         v6Ml2A9kMhwCuAe60zaeEW2H+5qdfDlhZxxCZ9OWxigFoOW5j+0VoOj7gRp5cENsZc
         BdtcuD4zYuSkUv02XgmlaDA0+YrV9Zap4+5DvkWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Peter Rosin <peda@axentia.se>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 27/69] cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom
Date:   Mon,  3 May 2021 13:56:54 +0200
Message-Id: <20210503115736.2104747-28-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gopinathan <atulgopinathan@gmail.com>

The fields, "toc" and "cd_info", of "struct gdrom_unit gd" are allocated
in "probe_gdrom()". Prevent a memory leak by making sure "gd.cd_info" is
deallocated in the "remove_gdrom()" function.

Also prevent double free of the field "gd.toc" by moving it from the
module's exit function to "remove_gdrom()". This is because, in
"probe_gdrom()", the function makes sure to deallocate "gd.toc" in case
of any errors, so the exit function invoked later would again free
"gd.toc".

The patch also maintains consistency by deallocating the above mentioned
fields in "remove_gdrom()" along with another memory allocated field
"gd.disk".

Suggested-by: Jens Axboe <axboe@kernel.dk>
Cc: Peter Rosin <peda@axentia.se>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/gdrom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 7f681320c7d3..6c4f6139f853 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -830,6 +830,8 @@ static int remove_gdrom(struct platform_device *devptr)
 	if (gdrom_major)
 		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	unregister_cdrom(gd.cd_info);
+	kfree(gd.cd_info);
+	kfree(gd.toc);
 
 	return 0;
 }
@@ -861,7 +863,6 @@ static void __exit exit_gdrom(void)
 {
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
-	kfree(gd.toc);
 }
 
 module_init(init_gdrom);
-- 
2.31.1

