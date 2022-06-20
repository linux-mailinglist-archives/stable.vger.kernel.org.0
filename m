Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93876551BB4
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347223AbiFTNkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348571AbiFTNjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:39:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA3C1FCCA;
        Mon, 20 Jun 2022 06:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7909C60A21;
        Mon, 20 Jun 2022 13:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71008C3411B;
        Mon, 20 Jun 2022 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730872;
        bh=5EhDfvdQPyvsqKb5IUjSjMjOE19hRfMsMIYXXUwilTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGueqYXzJlpx/Ui0sNRT1A1l8u7ufEJKJRXPLYO8CYl9HSs2fb5tSgFB7yCEBfMzp
         c1dq2GIz/3sEWCWvmlc8ttMWLb7nsd7jqj+GeGpzI3jVwiKAB9W4FyrfK4r9xR5agk
         Ozmmtvf16mZg8PCIBll0ZukCX6yRovSdFYlvs6Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 083/240] random: zero buffer after reading entropy from userspace
Date:   Mon, 20 Jun 2022 14:49:44 +0200
Message-Id: <20220620124741.278068968@linuxfoundation.org>
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

commit 7b5164fb1279bf0251371848e40bae646b59b3a8 upstream.

This buffer may contain entropic data that shouldn't stick around longer
than needed, so zero out the temporary buffer at the end of write_pool().

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1334,19 +1334,24 @@ static __poll_t random_poll(struct file
 static int write_pool(const char __user *ubuf, size_t count)
 {
 	size_t len;
+	int ret = 0;
 	u8 block[BLAKE2S_BLOCK_SIZE];
 
 	while (count) {
 		len = min(count, sizeof(block));
-		if (copy_from_user(block, ubuf, len))
-			return -EFAULT;
+		if (copy_from_user(block, ubuf, len)) {
+			ret = -EFAULT;
+			goto out;
+		}
 		count -= len;
 		ubuf += len;
 		mix_pool_bytes(block, len);
 		cond_resched();
 	}
 
-	return 0;
+out:
+	memzero_explicit(block, sizeof(block));
+	return ret;
 }
 
 static ssize_t random_write(struct file *file, const char __user *buffer,


