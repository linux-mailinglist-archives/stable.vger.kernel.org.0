Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E01551BEF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347721AbiFTNpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348903AbiFTNn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:43:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77532C653;
        Mon, 20 Jun 2022 06:16:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8257CB811E3;
        Mon, 20 Jun 2022 13:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0040C3411B;
        Mon, 20 Jun 2022 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730642;
        bh=HE8iMqlHztMzX9EeQuj+Az3zcpbQEHqL2jzZjC7T6Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPs1IIkz8uCA1Howki+DKBgltfLI96WthIyEq7aEM0zAlD1hBSMr1hN29RDVhGQwj
         b3p/wDZtXfQwSr/tziVP8NJ7fw10DTSgJDgV+mhRJyGUWjVPsKV2X/afW8+R76d71a
         F5To29ITvOoKyqFrt4c0+vdnlsQyOzmY0FwB9QEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 011/240] random: add GRND_INSECURE to return best-effort non-cryptographic bytes
Date:   Mon, 20 Jun 2022 14:48:32 +0200
Message-Id: <20220620124738.135287998@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 75551dbf112c992bc6c99a972990b3f272247e23 upstream.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/d5473b56cf1fa900ca4bd2b3fc1e5b8874399919.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c       |   11 +++++++++--
 include/uapi/linux/random.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2217,7 +2217,14 @@ SYSCALL_DEFINE3(getrandom, char __user *
 {
 	int ret;
 
-	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
+	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM|GRND_INSECURE))
+		return -EINVAL;
+
+	/*
+	 * Requesting insecure and blocking randomness at the same time makes
+	 * no sense.
+	 */
+	if ((flags & (GRND_INSECURE|GRND_RANDOM)) == (GRND_INSECURE|GRND_RANDOM))
 		return -EINVAL;
 
 	if (count > INT_MAX)
@@ -2226,7 +2233,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	if (flags & GRND_RANDOM)
 		return _random_read(flags & GRND_NONBLOCK, buf, count);
 
-	if (!crng_ready()) {
+	if (!(flags & GRND_INSECURE) && !crng_ready()) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
 		ret = wait_for_random_bytes();
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -49,8 +49,10 @@ struct rand_pool_info {
  *
  * GRND_NONBLOCK	Don't block and return EAGAIN instead
  * GRND_RANDOM		Use the /dev/random pool instead of /dev/urandom
+ * GRND_INSECURE	Return non-cryptographic random bytes
  */
 #define GRND_NONBLOCK	0x0001
 #define GRND_RANDOM	0x0002
+#define GRND_INSECURE	0x0004
 
 #endif /* _UAPI_LINUX_RANDOM_H */


