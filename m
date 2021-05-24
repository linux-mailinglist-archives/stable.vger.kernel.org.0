Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59AD38ED69
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhEXPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233072AbhEXPfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F81B613FE;
        Mon, 24 May 2021 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870349;
        bh=XNHfIXa8t0pA/6xQpixIYGs+1qBhbJw9btNSV41bm/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVMSlDV8ed/esbOBZNJg/V/9Gs0hH5f6bRw1mcW9JygaCoeQl9jW1WMFjAOSgGPFJ
         Wl6JkuouAVIRnCoOZi1405gb0ThjfUqSjtZ/rRQ5p6mluVW0MvmVDqR1JB6cmafgnc
         xBO1JwfAxE7i7Y9aSxe5tU1QDkIHxp1AVlnPe1dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Peter Rosin <peda@axentia.se>,
        Atul Gopinathan <atulgopinathan@gmail.com>
Subject: [PATCH 4.9 22/36] cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom
Date:   Mon, 24 May 2021 17:25:07 +0200
Message-Id: <20210524152324.880475059@linuxfoundation.org>
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

From: Atul Gopinathan <atulgopinathan@gmail.com>

commit d03d1021da6fe7f46efe9f2a7335564e7c9db5ab upstream.

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
Link: https://lore.kernel.org/r/20210503115736.2104747-28-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/gdrom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -850,6 +850,8 @@ static int remove_gdrom(struct platform_
 	if (gdrom_major)
 		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	unregister_cdrom(gd.cd_info);
+	kfree(gd.cd_info);
+	kfree(gd.toc);
 
 	return 0;
 }
@@ -881,7 +883,6 @@ static void __exit exit_gdrom(void)
 {
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
-	kfree(gd.toc);
 }
 
 module_init(init_gdrom);


