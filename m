Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9397C38F061
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhEXQDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhEXQCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F2F6199B;
        Mon, 24 May 2021 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871228;
        bh=l5znzEEp+drGCc3MSCCVnVpCS2tcza2eGBpHeaiJtnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+xmWVwnzcFz3iEi0hZxlOSyQKt8dnxbIIdvTjsRcpKZmdLDiDmJduRWuEgBvEu4/
         61yGaNkopuoiOM/1NOG7m65flaVFPb0jVt6Y9Xg0+PIsnQSkb0qtb8Q1eneP2NwOn3
         J8V4aoSK1U7aUE5HgoMwDW9IRmGXOZoi11U4zr8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Peter Rosin <peda@axentia.se>,
        Atul Gopinathan <atulgopinathan@gmail.com>
Subject: [PATCH 5.12 104/127] cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom
Date:   Mon, 24 May 2021 17:27:01 +0200
Message-Id: <20210524152338.367982185@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
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
@@ -831,6 +831,8 @@ static int remove_gdrom(struct platform_
 	if (gdrom_major)
 		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	unregister_cdrom(gd.cd_info);
+	kfree(gd.cd_info);
+	kfree(gd.toc);
 
 	return 0;
 }
@@ -862,7 +864,6 @@ static void __exit exit_gdrom(void)
 {
 	platform_device_unregister(pd);
 	platform_driver_unregister(&gdrom_driver);
-	kfree(gd.toc);
 }
 
 module_init(init_gdrom);


