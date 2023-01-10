Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0711C664B46
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbjAJSkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239630AbjAJSkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5D855854
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:34:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8C40B81902
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCAAC433D2;
        Tue, 10 Jan 2023 18:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375679;
        bh=0APOuDKYE825f33aBg7RHGZI0/iQ/Y49j++6cRggJQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQe33iAmN9Hjaz5weqoOqY5bguXgujVeL8/ITzwg8foQmTiZSOXAt/ZKPvmIheWrZ
         tfRI9MmmEJRCVWJPhAIase2F/jvkfNh42ryxYH2Liv9IFNoDJtowDuFooSS+iocgUE
         uumLekS8V+RgtzwAekA7cXzJDzr+M7UnS2Pc/vyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Baoquan He <bhe@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        stable@kernel.org
Subject: [PATCH 5.15 265/290] x86/kexec: Fix double-free of elf header buffer
Date:   Tue, 10 Jan 2023 19:05:57 +0100
Message-Id: <20230110180041.125646307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit d00dd2f2645dca04cf399d8fc692f3f69b6dd996 upstream.

After

  b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer"),

freeing image->elf_headers in the error path of crash_load_segments()
is not needed because kimage_file_post_load_cleanup() will take
care of that later. And not clearing it could result in a double-free.

Drop the superfluous vfree() call at the error path of
crash_load_segments().

Fixes: b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20221122115122.13937-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/crash.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -401,10 +401,8 @@ int crash_load_segments(struct kimage *i
 	kbuf.buf_align = ELF_CORE_HEADER_ALIGN;
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	ret = kexec_add_buffer(&kbuf);
-	if (ret) {
-		vfree((void *)image->elf_headers);
+	if (ret)
 		return ret;
-	}
 	image->elf_load_addr = kbuf.mem;
 	pr_debug("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 		 image->elf_load_addr, kbuf.bufsz, kbuf.bufsz);


