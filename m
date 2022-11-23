Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DC5635452
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiKWJFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiKWJEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:04:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F6F102E66
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F72B61B43
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371FEC433C1;
        Wed, 23 Nov 2022 09:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194255;
        bh=xyIqQROCqa729HDL6Jul9/otBWrSig47Pk599ClpMjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diftH5YO5+lih+ch3zhgo91WVtssSrX+Rn4wSOUTSH5CnILoD/WblrAe3ypP/x+Ko
         9dHuC3RHRav7xtxxII402hQHqptrmC8Tn5liUCr1cCX3Q9lGPiX4g7QKOJbZI7wftP
         GH4jlkRGC+BJtesikqcCvMOPztROVEXC6rZI7E5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhao Wenhui <zhaowenhui8@huawei.com>,
        xiafukun <xiafukun@huawei.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.19 027/114] vmlinux.lds.h: Fix placement of .data..decrypted section
Date:   Wed, 23 Nov 2022 09:50:14 +0100
Message-Id: <20221123084552.925933761@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 000f8870a47bdc36730357883b6aef42bced91ee upstream.

Commit d4c639990036 ("vmlinux.lds.h: Avoid orphan section with !SMP")
fixed an orphan section warning by adding the '.data..decrypted' section
to the linker script under the PERCPU_DECRYPTED_SECTION define but that
placement introduced a panic with !SMP, as the percpu sections are not
instantiated with that configuration so attempting to access variables
defined with DEFINE_PER_CPU_DECRYPTED() will result in a page fault.

Move the '.data..decrypted' section to the DATA_MAIN define so that the
variables in it are properly instantiated at boot time with
CONFIG_SMP=n.

Cc: stable@vger.kernel.org
Fixes: d4c639990036 ("vmlinux.lds.h: Avoid orphan section with !SMP")
Link: https://lore.kernel.org/cbbd3548-880c-d2ca-1b67-5bb93b291d5f@huawei.com/
Debugged-by: Ard Biesheuvel <ardb@kernel.org>
Reported-by: Zhao Wenhui <zhaowenhui8@huawei.com>
Tested-by: xiafukun <xiafukun@huawei.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221108174934.3384275-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -242,6 +242,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -843,7 +844,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else


