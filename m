Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA175EA345
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiIZLW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiIZLVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:21:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E87F53031;
        Mon, 26 Sep 2022 03:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3654660AF5;
        Mon, 26 Sep 2022 10:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A397C433D6;
        Mon, 26 Sep 2022 10:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188679;
        bh=R4uEFQXXft9s+qEOUmUElH92LOwYOg5bBGOVc1VHW+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqKBYzTxDKolVLxS3FKMp+jAOXBTkFP247tWeFuGnZw2TN2f5Cbowtw38u9NyCINi
         +L9oYFVAHcitZ7lTPbcqOvtpV/Am7vKiWp4BWB6zZhX/VuoXZzSbnu5c2yUte2Q3AJ
         bpBYelCtuvNj5qOvUgd5F5XGUhNjHkLYJpim3k2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Mohan Rao .vanimina" <mailtoc.mohanrao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 054/148] vmlinux.lds.h: CFI: Reduce alignment of jump-table to function alignment
Date:   Mon, 26 Sep 2022 12:11:28 +0200
Message-Id: <20220926100758.045992970@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 13b0566962914e167cb3238fbe29ced618f07a27 upstream.

Due to undocumented, hysterical raisins on x86, the CFI jump-table
sections in .text are needlessly aligned to PMD_SIZE in the vmlinux
linker script. When compiling a CFI-enabled arm64 kernel with a 64KiB
page-size, a PMD maps 512MiB of virtual memory and so the .text section
increases to a whopping 940MiB and blows the final Image up to 960MiB.
Others report a link failure.

Since the CFI jump-table requires only instruction alignment, reduce the
alignment directives to function alignment for parity with other parts
of the .text section. This reduces the size of the .text section for the
aforementioned 64KiB page size arm64 kernel to 19MiB for a much more
reasonable total Image size of 39MiB.

Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Mohan Rao .vanimina" <mailtoc.mohanrao@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/CAL_GTzigiNOMYkOPX1KDnagPhJtFNqSK=1USNbS0wUL4PW6-Uw@mail.gmail.com/
Fixes: cf68fffb66d6 ("add support for Clang CFI")
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220922215715.13345-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -549,10 +549,9 @@
  */
 #ifdef CONFIG_CFI_CLANG
 #define TEXT_CFI_JT							\
-		. = ALIGN(PMD_SIZE);					\
+		ALIGN_FUNCTION();					\
 		__cfi_jt_start = .;					\
 		*(.text..L.cfi.jumptable .text..L.cfi.jumptable.*)	\
-		. = ALIGN(PMD_SIZE);					\
 		__cfi_jt_end = .;
 #else
 #define TEXT_CFI_JT


