Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB73536097
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348783AbiE0LwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352799AbiE0Lux (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431CF132768;
        Fri, 27 May 2022 04:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDEDC61CF0;
        Fri, 27 May 2022 11:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2815C385A9;
        Fri, 27 May 2022 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651925;
        bh=0ycG1C8R9RfHAaw3cLJ3/vzUv+464neREcYcVWVG6kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6Pfm7soawj9Sa0OEt8ZQAbri1UaIws9MTTTVoTjdSEBdWXr4jiB8uF2hrPLeCjvU
         40QIC7nCy2sRV+LcmjBzl8nROoMWutO9J0eMRHfa1bpN9nkaN+mUgrX2M3NPqwmaMA
         TWFGNvPBjrX06WD0bHauFh1rYQwqEQyiOWn/sSTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 074/163] random: zero buffer after reading entropy from userspace
Date:   Fri, 27 May 2022 10:49:14 +0200
Message-Id: <20220527084838.299637036@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1336,19 +1336,24 @@ static __poll_t random_poll(struct file
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


