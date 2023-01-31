Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6330A68305E
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjAaPBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjAaPAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:00:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B167539A6;
        Tue, 31 Jan 2023 07:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9578961565;
        Tue, 31 Jan 2023 15:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22602C4339E;
        Tue, 31 Jan 2023 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177225;
        bh=2eJvU72bguGWNcOSPX5RnYvIcsZFnsi3YJtrC2eEK7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FF7N+hOU3dPlZ2reCprCMbWhFtMARMJ2CXpdZQ48ehokiBpZCRQa2o92dRgSeFx8D
         S+IS+9Csw2F8IfIlfoYc0/mBluHtCl0JSI8MBluJJ4R6ooQ5aXVNuGv+IrqeQRavgn
         QYHWeG0PMQwK3qQpnDpaFK3mi1vxfB9mOPSCc5ANyX1jGhRxNWNyAqKnWlH35D1g2a
         uAr5n8cYqjjCrFan/GVupfgtNq9A9Uf2hs8MRr/TYu8ZsSd0A/4jPKKISKGV+/LlVL
         VSNL65YyeZegbIQDIoZuMSXpiU6xEKlXpSEC6Ldc3IIJ3FfMHHdNwRLAdGNK++Vb09
         734XkCsyaDgKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alexandre Pereira <alexpereira@disroot.org>,
        Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 19/20] bcache: Silence memcpy() run-time false positive warnings
Date:   Tue, 31 Jan 2023 09:59:45 -0500
Message-Id: <20230131145946.1249850-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit be0d8f48ad97f5b775b0af3310343f676dbf318a ]

struct bkey has internal padding in a union, but it isn't always named
the same (e.g. key ## _pad, key_p, etc). This makes it extremely hard
for the compiler to reason about the available size of copies done
against such keys. Use unsafe_memcpy() for now, to silence the many
run-time false positive warnings:

  memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
  memcpy: detected field-spanning write (size 24) of single field "&b->key" at drivers/md/bcache/btree.c:939 (size 16)
  memcpy: detected field-spanning write (size 24) of single field "&temp.key" at drivers/md/bcache/extents.c:428 (size 16)

Reported-by: Alexandre Pereira <alexpereira@disroot.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216785
Acked-by: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230106060229.never.047-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/bcache_ondisk.h | 3 ++-
 drivers/md/bcache/journal.c       | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 97413586195b..f96034e0ba4f 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -106,7 +106,8 @@ static inline unsigned long bkey_bytes(const struct bkey *k)
 	return bkey_u64s(k) * sizeof(__u64);
 }
 
-#define bkey_copy(_dest, _src)	memcpy(_dest, _src, bkey_bytes(_src))
+#define bkey_copy(_dest, _src)	unsafe_memcpy(_dest, _src, bkey_bytes(_src), \
+					/* bkey is always padded */)
 
 static inline void bkey_copy_key(struct bkey *dest, const struct bkey *src)
 {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index e5da469a4235..c182c21de2e8 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -149,7 +149,8 @@ reread:		left = ca->sb.bucket_size - offset;
 				    bytes, GFP_KERNEL);
 			if (!i)
 				return -ENOMEM;
-			memcpy(&i->j, j, bytes);
+			unsafe_memcpy(&i->j, j, bytes,
+				/* "bytes" was calculated by set_bytes() above */);
 			/* Add to the location after 'where' points to */
 			list_add(&i->list, where);
 			ret = 1;
-- 
2.39.0

