Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A27190A7
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfEISrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfEISrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFC1217F9;
        Thu,  9 May 2019 18:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427636;
        bh=WE7DH8v4uGIWCVhMwzNdRbqkimb09nk1+twnWPRqxgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hq+Wu8uWbSbS9mNkoKHrqEUpRjxDrsfyu7na0jH42aaqlDJXjoQh7CX/EktJ4CjaF
         1ihQMpf9SgLhUY+V7ywbNj6iY9GAcDkfMfZ46pXyl0PxHY8dZ3i8xV23drr122j4Fz
         aS2gg72nEDzNbt1QfHpztUBVo0cl6b2bcrZ7ht7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suresh Udipi <sudipi@jp.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Christian Gromm <christian.gromm@microchip.com>
Subject: [PATCH 4.19 06/66] staging: most: cdev: fix chrdev_region leak in mod_exit
Date:   Thu,  9 May 2019 20:41:41 +0200
Message-Id: <20190509181302.485638271@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suresh Udipi <sudipi@jp.adit-jv.com>

commit af708900e9a48c0aa46070c8a8cdf0608a1d2025 upstream.

It looks like v4.18-rc1 commit [0] which upstreams mld-1.8.0
commit [1] missed to fix the memory leak in mod_exit function.

Do it now.

[0] aba258b7310167 ("staging: most: cdev: fix chrdev_region leak")
[1] https://github.com/microchip-ais/linux/commit/a2d8f7ae7ea381
    ("staging: most: cdev: fix leak for chrdev_region")

Signed-off-by: Suresh Udipi <sudipi@jp.adit-jv.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Acked-by: Christian Gromm <christian.gromm@microchip.com>
Fixes: aba258b73101 ("staging: most: cdev: fix chrdev_region leak")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/most/cdev/cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/most/cdev/cdev.c
+++ b/drivers/staging/most/cdev/cdev.c
@@ -546,7 +546,7 @@ static void __exit mod_exit(void)
 		destroy_cdev(c);
 		destroy_channel(c);
 	}
-	unregister_chrdev_region(comp.devno, 1);
+	unregister_chrdev_region(comp.devno, CHRDEV_REGION_SIZE);
 	ida_destroy(&comp.minor_id);
 	class_destroy(comp.class);
 }


