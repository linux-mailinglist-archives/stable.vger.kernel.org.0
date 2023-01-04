Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F1D65D80F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjADQKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbjADQKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549273E0E9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2BB7B8172B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43216C433F0;
        Wed,  4 Jan 2023 16:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848590;
        bh=+WDdi6mni24hGl6ZMgfUGIWMGyc0k0Q1KgoUiOjz8Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOZwJbevK1v2BdHtLYngIpCoX+rUbeKT8geYMhHnDNbjrK2pSNyTMiXSqZsIVppKz
         wTvW94cdjbLL6yaOP2PzOE6YoWH7adP/DxzksNhVcxgk/nbBHX0bRzDcaBvn3q2dPc
         TCuVlkDI7JToVjXJ0U6RZFI8r6u0HQHLA2ZTiRDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kees Cook <keescook@chromium.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.1 032/207] random: add helpers for random numbers with given floor or range
Date:   Wed,  4 Jan 2023 17:04:50 +0100
Message-Id: <20230104160512.930390063@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 7f576b2593a978451416424e75f69ad1e3ae4efe upstream.

Now that we have get_random_u32_below(), it's nearly trivial to make
inline helpers to compute get_random_u32_above() and
get_random_u32_inclusive(), which will help clean up open coded loops
and manual computations throughout the tree.

One snag is that in order to make get_random_u32_inclusive() operate on
closed intervals, we have to do some (unlikely) special case handling if
get_random_u32_inclusive(0, U32_MAX) is called. The least expensive way
of doing this is actually to adjust the slowpath of
get_random_u32_below() to have its undefined 0 result just return the
output of get_random_u32(). We can make this basically free by calling
get_random_u32() before the branch, so that the branch latency gets
interleaved.

Cc: stable@vger.kernel.org # to ease future backports that use this api
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   18 +++++++++++++++++-
 include/linux/random.h |   25 +++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -161,6 +161,8 @@ EXPORT_SYMBOL(wait_for_random_bytes);
  *	u16 get_random_u16()
  *	u32 get_random_u32()
  *	u32 get_random_u32_below(u32 ceil)
+ *	u32 get_random_u32_above(u32 floor)
+ *	u32 get_random_u32_inclusive(u32 floor, u32 ceil)
  *	u64 get_random_u64()
  *	unsigned long get_random_long()
  *
@@ -522,7 +524,21 @@ u32 __get_random_u32_below(u32 ceil)
 	 * of `-ceil % ceil` is analogous to `2^32 % ceil`, but is computable
 	 * in 32-bits.
 	 */
-	u64 mult = (u64)ceil * get_random_u32();
+	u32 rand = get_random_u32();
+	u64 mult;
+
+	/*
+	 * This function is technically undefined for ceil == 0, and in fact
+	 * for the non-underscored constant version in the header, we build bug
+	 * on that. But for the non-constant case, it's convenient to have that
+	 * evaluate to being a straight call to get_random_u32(), so that
+	 * get_random_u32_inclusive() can work over its whole range without
+	 * undefined behavior.
+	 */
+	if (unlikely(!ceil))
+		return rand;
+
+	mult = (u64)ceil * rand;
 	if (unlikely((u32)mult < ceil)) {
 		u32 bound = -ceil % ceil;
 		while (unlikely((u32)mult < bound))
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -92,6 +92,31 @@ static inline u32 get_random_u32_below(u
 }
 
 /*
+ * Returns a random integer in the interval (floor, U32_MAX], with uniform
+ * distribution, suitable for all uses. Fastest when floor is a constant, but
+ * still fast for variable floor as well.
+ */
+static inline u32 get_random_u32_above(u32 floor)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && floor == U32_MAX,
+			 "get_random_u32_above() must take floor < U32_MAX");
+	return floor + 1 + get_random_u32_below(U32_MAX - floor);
+}
+
+/*
+ * Returns a random integer in the interval [floor, ceil], with uniform
+ * distribution, suitable for all uses. Fastest when floor and ceil are
+ * constant, but still fast for variable floor and ceil as well.
+ */
+static inline u32 get_random_u32_inclusive(u32 floor, u32 ceil)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && __builtin_constant_p(ceil) &&
+			 (floor > ceil || ceil - floor == U32_MAX),
+			 "get_random_u32_inclusive() must take floor <= ceil");
+	return floor + get_random_u32_below(ceil - floor + 1);
+}
+
+/*
  * On 64-bit architectures, protect against non-terminated C string overflows
  * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.
  */


