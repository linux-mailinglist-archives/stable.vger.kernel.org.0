Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD769F412
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjBVMMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBVMM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:12:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B099360AE
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 04:12:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AA3161425
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 12:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5733FC4339C;
        Wed, 22 Feb 2023 12:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677067948;
        bh=yYLRlUlGUt4NrJedcMZFwwfsaIBPlVsH1cGPT0gDTRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqV22YXryCCAP8bd69XEcKTTgOqEbjP82XxoY9DY4HHGsp0v0C3YPQ7ZRrh9/1nnd
         nB4q0jGn1jFpZv1vGvRj+xlgkpdRS3dBX7d5yfP+Qu/AyK09jPH9sN2axhWMVS40Aj
         MvWC9RLszrokGnjuQgTX6NRrUuWxD08yd6dx+d69CZZEyILWuAit92YxfDOHRCeDVE
         NYPicXtQw2srYwlYqQb6gHXQnGEWR5GGhK4u3AiHoQG8Po8YRT0x9qwU+3pwLtH0Ey
         hfNXc+2okpTyvbIhH5q/cc8A1dpEpQRgIE3jBmoj8pH4hGWLlezOWDeNSW6jlKNJLq
         oo97pZgcGJYEQ==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Todd Kjos <tkjos@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH v5.15.y 3/5] binder: fix pointer cast warning
Date:   Wed, 22 Feb 2023 12:12:06 +0000
Message-Id: <20230222121208.898198-4-lee@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
In-Reply-To: <20230222121208.898198-1-lee@kernel.org>
References: <20230222121208.898198-1-lee@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 9a0a930fe2535a76ad70d3f43caeccf0d86a3009 upstream.

binder_uintptr_t is not the same as uintptr_t, so converting it into a
pointer requires a second cast:

drivers/android/binder.c: In function 'binder_translate_fd_array':
drivers/android/binder.c:2511:28: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
 2511 |         sender_ufda_base = (void __user *)sender_uparent->buffer + fda->parent_offset;
      |                            ^

Fixes: 656e01f3ab54 ("binder: read pre-translated fds from sender buffer")
Acked-by: Todd Kjos <tkjos@google.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211207122448.1185769-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/android/binder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index d1a9d23cdd0db..bace6034c9afd 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2544,7 +2544,8 @@ static int binder_translate_fd_array(struct list_head *pf_head,
 	 */
 	fda_offset = (parent->buffer - (uintptr_t)t->buffer->user_data) +
 		fda->parent_offset;
-	sender_ufda_base = (void __user *)sender_uparent->buffer + fda->parent_offset;
+	sender_ufda_base = (void __user *)(uintptr_t)sender_uparent->buffer +
+				fda->parent_offset;
 
 	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32)) ||
 	    !IS_ALIGNED((unsigned long)sender_ufda_base, sizeof(u32))) {
-- 
2.39.2.637.g21b0678d19-goog

