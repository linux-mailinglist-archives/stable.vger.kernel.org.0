Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B968D7D7
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjBGNDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjBGNDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E25F2BED6;
        Tue,  7 Feb 2023 05:03:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E0D76138B;
        Tue,  7 Feb 2023 13:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903D1C433EF;
        Tue,  7 Feb 2023 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775022;
        bh=2eJvU72bguGWNcOSPX5RnYvIcsZFnsi3YJtrC2eEK7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PanLKIfUPSBlmndoRxGriylB++ipG3EaaRdDpLKjJqupD0MsHS6zv5l9ITDGDvtCk
         2Ft83WuIYVAui7AO8IZqv8nn2zMdpQY7eGydGs0waCA9q2bSrVypnZr4xtjW/bt8RH
         Ut2JLQLJCutuBnlXegnYk32Afd5vlTR7EgXhjLtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexandre Pereira <alexpereira@disroot.org>,
        Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/208] bcache: Silence memcpy() run-time false positive warnings
Date:   Tue,  7 Feb 2023 13:56:04 +0100
Message-Id: <20230207125639.351394298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



