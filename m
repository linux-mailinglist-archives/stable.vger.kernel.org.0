Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0C28911
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392158AbfEWTac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392143AbfEWTac (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05E8520879;
        Thu, 23 May 2019 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639831;
        bh=OXAKRAzjo2jHwrzZdwTydx34Rw0Yt7nFcc573flfAXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLFDIjIj9Ly86NwcuPcz5w4dMFAhWXGUdXKNVL2uh2jiwmOxF2LmXCLaOUXOZJ4Pn
         pkXL8ihreI+/aRHVVYVn+j9lgTI7xGMv9mBpqpC+GYf4tw20jRxNkleqfObTAINDX2
         v+bF2DqGvN5PEfdAAmuyvLi1QhhQIcFi9qsLWeNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helen Koike <helen.koike@collabora.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.1 108/122] dm ioctl: fix hang in early create error condition
Date:   Thu, 23 May 2019 21:07:10 +0200
Message-Id: <20190523181719.695301559@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

commit 0f41fcf78849c902ddca564f99a8e23ccfc80333 upstream.

The dm_early_create() function (which deals with "dm-mod.create=" kernel
command line option) calls dm_hash_insert() who gets an extra reference
to the md object.

In case of failure, this reference wasn't being released, causing
dm_destroy() to hang, thus hanging the whole boot process.

Fix this by calling __hash_remove() in the error path.

Fixes: 6bbc923dfcf57d ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-ioctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2069,7 +2069,7 @@ int __init dm_early_create(struct dm_ioc
 	/* alloc table */
 	r = dm_table_create(&t, get_mode(dmi), dmi->target_count, md);
 	if (r)
-		goto err_destroy_dm;
+		goto err_hash_remove;
 
 	/* add targets */
 	for (i = 0; i < dmi->target_count; i++) {
@@ -2116,6 +2116,10 @@ int __init dm_early_create(struct dm_ioc
 
 err_destroy_table:
 	dm_table_destroy(t);
+err_hash_remove:
+	(void) __hash_remove(__get_name_cell(dmi->name));
+	/* release reference from __get_name_cell */
+	dm_put(md);
 err_destroy_dm:
 	dm_put(md);
 	dm_destroy(md);


