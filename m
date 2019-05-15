Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50DF1F8F7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 18:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfEOQvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 12:51:21 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33020 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfEOQvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 12:51:21 -0400
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:d573:a076:d1fd:3417:b195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id EDED326D7C1;
        Wed, 15 May 2019 17:51:16 +0100 (BST)
From:   Helen Koike <helen.koike@collabora.com>
To:     dm-devel@redhat.com
Cc:     kernel@collabora.com, Helen Koike <helen.koike@collabora.com>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: [PATCH v2] dm ioctl: fix hang in early create error condition
Date:   Wed, 15 May 2019 13:50:54 -0300
Message-Id: <20190515165054.12680-1-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dm_early_create() function (which deals with "dm-mod.create=" kernel
command line option) calls dm_hash_insert() who gets an extra reference
to the md object.

In case of failure, this reference wasn't being released, causing
dm_destroy() to hang, thus hanging the whole boot process.

Fix this by calling __hash_remove() in the error path.

Fixes: 6bbc923dfcf57d ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Helen Koike <helen.koike@collabora.com>

---
Hi,

I also tested this patch version with the new test case in the following test
script:

https://gitlab.collabora.com/koike/dm-cmdline-test/commit/d2d7a0ee4a49931cdb59f08a837b516c2d5d743d

Thanks
Helen

Changes in v2:
- instead of modifying dm_hash_insert() to return the hash cell, use
__get_name_cell(dmi->name) instead.

 drivers/md/dm-ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c740153b4e52..1e03bc89e20f 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2069,7 +2069,7 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 	/* alloc table */
 	r = dm_table_create(&t, get_mode(dmi), dmi->target_count, md);
 	if (r)
-		goto err_destroy_dm;
+		goto err_hash_remove;
 
 	/* add targets */
 	for (i = 0; i < dmi->target_count; i++) {
@@ -2116,6 +2116,10 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 
 err_destroy_table:
 	dm_table_destroy(t);
+err_hash_remove:
+	(void) __hash_remove(__get_name_cell(dmi->name));
+	/* release reference from __get_name_cell */
+	dm_put(md);
 err_destroy_dm:
 	dm_put(md);
 	dm_destroy(md);
-- 
2.20.1

