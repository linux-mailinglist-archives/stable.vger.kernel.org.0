Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAAC603D43
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiJSJAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiJSI7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB47915D5;
        Wed, 19 Oct 2022 01:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70E81617FB;
        Wed, 19 Oct 2022 08:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDE6C433D6;
        Wed, 19 Oct 2022 08:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168887;
        bh=iBCE6CVpGhguyA1nbaVJy4nxf3CDqIVcTmrvTafBJQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfLmhB14Al3mqDOLiJJjjgmmDpyxJCH2fl9I9IVNWqFlqZsKM0QrSeKFhoQP8pHaq
         XYIL4pH4wtVFWKR0VC26SrKCfWulwy1AqaJH6fOTvbzTs61aePuN/pFckYvMIaG0oz
         ktV/E8hidB8XYWjiAjncmDueS+ums+2mJtExCdU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 070/862] dm: verity-loadpin: Only trust verity targets with enforcement
Date:   Wed, 19 Oct 2022 10:22:37 +0200
Message-Id: <20221019083253.012028710@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

commit 916ef6232cc4b84db7082b4c3d3cf1753d9462ba upstream.

Verity targets can be configured to ignore corrupted data blocks.
LoadPin must only trust verity targets that are configured to
perform some kind of enforcement when data corruption is detected,
like returning an error, restarting the system or triggering a
panic.

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Reported-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-loadpin.c |  8 ++++++++
 drivers/md/dm-verity-target.c  | 16 ++++++++++++++++
 drivers/md/dm-verity.h         |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
index 387ec43aef72..4f78cc55c251 100644
--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -14,6 +14,7 @@ LIST_HEAD(dm_verity_loadpin_trusted_root_digests);
 
 static bool is_trusted_verity_target(struct dm_target *ti)
 {
+	int verity_mode;
 	u8 *root_digest;
 	unsigned int digest_size;
 	struct dm_verity_loadpin_trusted_root_digest *trd;
@@ -22,6 +23,13 @@ static bool is_trusted_verity_target(struct dm_target *ti)
 	if (!dm_is_verity_target(ti))
 		return false;
 
+	verity_mode = dm_verity_get_mode(ti);
+
+	if ((verity_mode != DM_VERITY_MODE_EIO) &&
+	    (verity_mode != DM_VERITY_MODE_RESTART) &&
+	    (verity_mode != DM_VERITY_MODE_PANIC))
+		return false;
+
 	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
 		return false;
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 94b6cb599db4..8a00cc42e498 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1446,6 +1446,22 @@ bool dm_is_verity_target(struct dm_target *ti)
 	return ti->type->module == THIS_MODULE;
 }
 
+/*
+ * Get the verity mode (error behavior) of a verity target.
+ *
+ * Returns the verity mode of the target, or -EINVAL if 'ti' is not a verity
+ * target.
+ */
+int dm_verity_get_mode(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+
+	if (!dm_is_verity_target(ti))
+		return -EINVAL;
+
+	return v->mode;
+}
+
 /*
  * Get the root digest of a verity target.
  *
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 45455de1b4bc..98f306ec6a33 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -134,6 +134,7 @@ extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
 extern bool dm_is_verity_target(struct dm_target *ti);
+extern int dm_verity_get_mode(struct dm_target *ti);
 extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
 				     unsigned int *digest_size);
 
-- 
2.38.0



