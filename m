Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2A676FF4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjAVP05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjAVP05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D4223102;
        Sun, 22 Jan 2023 07:26:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3763CB80B1D;
        Sun, 22 Jan 2023 15:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65751C433EF;
        Sun, 22 Jan 2023 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401213;
        bh=Tuxs1NEZKMDWUzPV7lythlqKChoHyY+HjxS2sgagfYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ms4xLW3l8g0jMCt2vw/nvR39G+VTyaF/2GDOoKB1lQ0VS1fPRFtnfIWtHSw85BKJt
         UUdSt2xyuSbZodgpGRGinGSD64nXl4FBJVWd1DLSRyDB7Ovu7Q2seFTDgB1t8gKqEw
         sQrj1Ml4exyHl5M3hGQV4FXzG2dHchemQf+3s5Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jann Horn <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Huang Ying <ying.huang@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 153/193] exit: Allow oops_limit to be disabled
Date:   Sun, 22 Jan 2023 16:04:42 +0100
Message-Id: <20230122150253.385351580@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit de92f65719cd672f4b48397540b9f9eff67eca40 upstream.

In preparation for keeping oops_limit logic in sync with warn_limit,
have oops_limit == 0 disable checking the Oops counter.

Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/kernel.rst |    5 +++--
 kernel/exit.c                               |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -671,8 +671,9 @@ oops_limit
 ==========
 
 Number of kernel oopses after which the kernel should panic when
-``panic_on_oops`` is not set. Setting this to 0 or 1 has the same effect
-as setting ``panic_on_oops=1``.
+``panic_on_oops`` is not set. Setting this to 0 disables checking
+the count. Setting this to  1 has the same effect as setting
+``panic_on_oops=1``. The default value is 10000.
 
 
 osrelease, ostype & version
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -954,7 +954,7 @@ void __noreturn make_task_dead(int signr
 	 * To make sure this can't happen, place an upper bound on how often the
 	 * kernel may oops without panic().
 	 */
-	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit))
+	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit) && oops_limit)
 		panic("Oopsed too often (kernel.oops_limit is %d)", oops_limit);
 
 	/*


