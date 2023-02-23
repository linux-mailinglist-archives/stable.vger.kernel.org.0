Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355066A0A20
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbjBWNNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbjBWNNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D72B567AB
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19DC7616E2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97F9C4339E;
        Thu, 23 Feb 2023 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157943;
        bh=V+zYl9zkS5oAYAWCkniidp1NAxsc0BaVZSBroS7AqSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5men+KfVSEo9jRt+vvNY+mqLZiOvn8R/KBYC18d1TS3jt7apUEH710t4dMBHr6P/
         L36FDPYOcMEfRGJESbWXK3DepJQfKuyWBHsU66OVjejwY2RWiL/fxQSeVI6uhm+oYN
         a8ha29PqTrOYmcMrV4PD83Pj76remoBYRDWWdzfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, lee@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Todd Kjos <tkjos@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Carlos Llamas <cmllamas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.15 25/36] binder: fix pointer cast warning
Date:   Thu, 23 Feb 2023 14:07:01 +0100
Message-Id: <20230223130430.224723961@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2544,7 +2544,8 @@ static int binder_translate_fd_array(str
 	 */
 	fda_offset = (parent->buffer - (uintptr_t)t->buffer->user_data) +
 		fda->parent_offset;
-	sender_ufda_base = (void __user *)sender_uparent->buffer + fda->parent_offset;
+	sender_ufda_base = (void __user *)(uintptr_t)sender_uparent->buffer +
+				fda->parent_offset;
 
 	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32)) ||
 	    !IS_ALIGNED((unsigned long)sender_ufda_base, sizeof(u32))) {


