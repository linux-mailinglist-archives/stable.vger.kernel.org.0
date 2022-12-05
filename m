Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6507643451
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbiLEToa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbiLEToO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:44:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D23261A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:41:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48468B8118F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE90CC433C1;
        Mon,  5 Dec 2022 19:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269289;
        bh=VHa0UVcFclgV0/CRLiJhQE8bAwgj5mUvm97pZNe4sUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7WMRtPFuswswCFwUWNdRcO7zYr+JEoJp7RORBTPRh9W0RWOmoUEzBrN6NQnp6UGj
         D5OFEExFDesApqVXNMl33mG8AU3gR82cE2KcEYh2HYZi8ZdXVAnrpXEXFMkvAqrfwj
         sUdE04bLWtGcyQ+UCAnvdxZKvtm/tKQUZoozZ6Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Todd Kjos <tkjos@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Carlos Llamas <cmllamas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.4 072/153] binder: fix pointer cast warning
Date:   Mon,  5 Dec 2022 20:09:56 +0100
Message-Id: <20221205190810.787354843@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2911,7 +2911,8 @@ static int binder_translate_fd_array(str
 	 */
 	fda_offset = (parent->buffer - (uintptr_t)t->buffer->user_data) +
 		fda->parent_offset;
-	sender_ufda_base = (void __user *)sender_uparent->buffer + fda->parent_offset;
+	sender_ufda_base = (void __user *)(uintptr_t)sender_uparent->buffer +
+				fda->parent_offset;
 
 	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32)) ||
 	    !IS_ALIGNED((unsigned long)sender_ufda_base, sizeof(u32))) {


