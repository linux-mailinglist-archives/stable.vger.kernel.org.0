Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3736752643D
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380729AbiEMO17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380739AbiEMO1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:27:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248D4DFB7;
        Fri, 13 May 2022 07:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E01586216C;
        Fri, 13 May 2022 14:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19A0C36AE2;
        Fri, 13 May 2022 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452018;
        bh=8nYjadxN9N1RTFRbp0seHgxawJmSGG0+3SicY1sPKHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTtJ6nZUyUWDNx+Qf3rl9LI2Ur0Qi/F1JbzIHdMkr4URhc1UfsqjUGmwDPyUNW87Y
         cX55ODQIUzSJPtnix4K80unqQw8P6LbKlM5W4aXjCxmLYVDAQiep52f6Wr3culwBhi
         n+iGzSKScZ/4DPtPpDufGmHEZKfMTmrweo3VYpC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 5.4 04/18] drm/i915: Cast remain to unsigned long in eb_relocate_vma
Date:   Fri, 13 May 2022 16:23:30 +0200
Message-Id: <20220513142229.281127401@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
References: <20220513142229.153291230@linuxfoundation.org>
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

From: Nathan Chancellor <natechancellor@gmail.com>

commit 7bf03e7504e433da274963c447648876902b86df upstream.

A recent commit in clang added -Wtautological-compare to -Wall, which is
enabled for i915 after -Wtautological-compare is disabled for the rest
of the kernel so we see the following warning on x86_64:

 ../drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c:1433:22: warning:
 result of comparison of constant 576460752303423487 with expression of
 type 'unsigned int' is always false
 [-Wtautological-constant-out-of-range-compare]
         if (unlikely(remain > N_RELOC(ULONG_MAX)))
            ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~
 ../include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
 # define unlikely(x)    __builtin_expect(!!(x), 0)
                                            ^
 1 warning generated.

It is not wrong in the case where ULONG_MAX > UINT_MAX but it does not
account for the case where this file is built for 32-bit x86, where
ULONG_MAX == UINT_MAX and this check is still relevant.

Cast remain to unsigned long, which keeps the generated code the same
(verified with clang-11 on x86_64 and GCC 9.2.0 on x86 and x86_64) and
the warning is silenced so we can catch more potential issues in the
future.

Closes: https://github.com/ClangBuiltLinux/linux/issues/778
Suggested-by: Michel Dänzer <michel@daenzer.net>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200214054706.33870-1-natechancellor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1452,7 +1452,7 @@ static int eb_relocate_vma(struct i915_e
 
 	urelocs = u64_to_user_ptr(entry->relocs_ptr);
 	remain = entry->relocation_count;
-	if (unlikely(remain > N_RELOC(ULONG_MAX)))
+	if (unlikely((unsigned long)remain > N_RELOC(ULONG_MAX)))
 		return -EINVAL;
 
 	/*


