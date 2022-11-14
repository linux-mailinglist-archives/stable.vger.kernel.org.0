Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56084628085
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbiKNNGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbiKNNGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:06:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E82AC51
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E351B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9DDC433D6;
        Mon, 14 Nov 2022 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431186;
        bh=cufJMALQRxsWPm4GhyIwlgHFdtdzqQpNLVMVOZFKaIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGIXdfKqFYnHh9kySHGSe6oQtzqZh9uOwSxKq1VwzslMDCAIQCMxe9MnwlNjOw62h
         1qdoz1PSAhCvju598SuLvucS6MFe6eI2MigwKUCsYwwXSwCUOpHWEWL0VhX+lcxrF4
         9s2kPDO/8Kv2QCAqySK77jbw135We4nxspOZzCDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhao Wenhui <zhaowenhui8@huawei.com>,
        xiafukun <xiafukun@huawei.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.0 132/190] vmlinux.lds.h: Fix placement of .data..decrypted section
Date:   Mon, 14 Nov 2022 13:45:56 +0100
Message-Id: <20221114124504.574305390@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
@@ -333,6 +333,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -975,7 +976,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else


