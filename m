Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37ECA6648AF
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbjAJSNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjAJSM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:12:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68BC64CF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76582617EC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA48C433D2;
        Tue, 10 Jan 2023 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374300;
        bh=eOl1NMaMazQGbtIBH02ohkfluw1QFycUlov2MiDILG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuFeEvKaO9BffXnFg4AtbOxPG0P7K1Yw+mRVYuqfBS4wT6ucup+5ftn3yRkBvqQJz
         ZKN9RJsIG+Bg3p3tFzlbrEf6MGrrKW/0VXR2PnFnSFVDDwPnItnvwiZ0/kXwQEubhG
         NUBWu0Jr3xHGw08cNxe1eqIUTBD7JakCM8LPnmxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Baoquan He <bhe@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        stable@kernel.org
Subject: [PATCH 6.0 121/148] x86/kexec: Fix double-free of elf header buffer
Date:   Tue, 10 Jan 2023 19:03:45 +0100
Message-Id: <20230110180021.033234345@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
 		 image->elf_load_addr, kbuf.bufsz, kbuf.memsz);


