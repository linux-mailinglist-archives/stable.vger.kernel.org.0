Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C375C551D3E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbiFTNuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349007AbiFTNrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784DA1A056;
        Mon, 20 Jun 2022 06:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D38360FEF;
        Mon, 20 Jun 2022 13:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBF8C3411B;
        Mon, 20 Jun 2022 13:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731010;
        bh=FHCpQXUyZuymp9eUMYo1Xrjj9Tv2JqAA3JogK1g4j7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3oT2OuOV9zFQ0RYY/hu7jpeF5T7+iYcZsm3RwlLVW9bdVFbd9YOQVgOFFOKCbN49
         gyw7WFP+lhB28FAiTmrp0ubQ0Ous1BWYOvbXCAA31s1FXgrBeF+dYCiS+cf6rJf4Rs
         pjat6pzd2Jbg2B6kskVSu9LNEy08gXgTqYoNmBb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 126/240] random: allow partial reads if later user copies fail
Date:   Mon, 20 Jun 2022 14:50:27 +0200
Message-Id: <20220620124742.663624602@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 5209aed5137880fa229746cb521f715e55596460 upstream.

Rather than failing entirely if a copy_to_user() fails at some point,
instead we should return a partial read for the amount that succeeded
prior, unless none succeeded at all, in which case we return -EFAULT as
before.

This makes it consistent with other reader interfaces. For example, the
following snippet for /dev/zero outputs "4" followed by "1":

  int fd;
  void *x = mmap(NULL, 4096, PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
  assert(x != MAP_FAILED);
  fd = open("/dev/zero", O_RDONLY);
  assert(fd >= 0);
  printf("%zd\n", read(fd, x, 4));
  printf("%zd\n", read(fd, x + 4095, 4));
  close(fd);

This brings that same standard behavior to the various RNG reader
interfaces.

While we're at it, we can streamline the loop logic a little bit.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -523,8 +523,7 @@ EXPORT_SYMBOL(get_random_bytes);
 
 static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
 {
-	ssize_t ret = 0;
-	size_t len;
+	size_t len, left, ret = 0;
 	u32 chacha_state[CHACHA_BLOCK_SIZE / sizeof(u32)];
 	u8 output[CHACHA_BLOCK_SIZE];
 
@@ -543,37 +542,40 @@ static ssize_t get_random_bytes_user(voi
 	 * the user directly.
 	 */
 	if (nbytes <= CHACHA_KEY_SIZE) {
-		ret = copy_to_user(buf, &chacha_state[4], nbytes) ? -EFAULT : nbytes;
+		ret = nbytes - copy_to_user(buf, &chacha_state[4], nbytes);
 		goto out_zero_chacha;
 	}
 
-	do {
+	for (;;) {
 		chacha20_block(chacha_state, output);
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
 
 		len = min_t(size_t, nbytes, CHACHA_BLOCK_SIZE);
-		if (copy_to_user(buf, output, len)) {
-			ret = -EFAULT;
+		left = copy_to_user(buf, output, len);
+		if (left) {
+			ret += len - left;
 			break;
 		}
 
-		nbytes -= len;
 		buf += len;
 		ret += len;
+		nbytes -= len;
+		if (!nbytes)
+			break;
 
 		BUILD_BUG_ON(PAGE_SIZE % CHACHA_BLOCK_SIZE != 0);
-		if (!(ret % PAGE_SIZE) && nbytes) {
+		if (ret % PAGE_SIZE == 0) {
 			if (signal_pending(current))
 				break;
 			cond_resched();
 		}
-	} while (nbytes);
+	}
 
 	memzero_explicit(output, sizeof(output));
 out_zero_chacha:
 	memzero_explicit(chacha_state, sizeof(chacha_state));
-	return ret;
+	return ret ? ret : -EFAULT;
 }
 
 /*


