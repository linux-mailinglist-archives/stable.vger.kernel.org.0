Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB39965AFAC
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjABKjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjABKjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:39:37 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038791D0;
        Mon,  2 Jan 2023 02:39:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6936B205F5;
        Mon,  2 Jan 2023 10:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1672655975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9xe2eMFnILH/jDMx9pAFzxHyWx3I3CkIiF3DU9xLhJ8=;
        b=0TVeymCcyKqOOeieQacnsxkc9lkFjJHsY0Bx+WH8TpER8kYx6pSvC3p95SUxNqBmRJXXZu
        oEDQh+trA1qBRrZPcdeQ/yBTOvyd1Jd8mP0/ivtD4rN64oLaPW6fL65YsdvIr0kAcV8ns5
        Ax0WsI+B+EeBeOWoLo8F6TaJLo9nAus=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1672655975;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9xe2eMFnILH/jDMx9pAFzxHyWx3I3CkIiF3DU9xLhJ8=;
        b=WsrHznqV/LCPAzulNABvB/gmrJzHu2rHQcOoBbLOw1q/9xrgv/YG3zOFUhtVwZhbL4Rh4E
        j0zynpfNBY+XZ6Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F2F013427;
        Mon,  2 Jan 2023 10:39:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wIbCDme0smP3WgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 02 Jan 2023 10:39:35 +0000
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        patches@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/kexec: fix double vfree of image->elf_headers
Date:   Mon,  2 Jan 2023 11:39:17 +0100
Message-Id: <20230102103917.20987-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An investigation of a "Trying to vfree() nonexistent vm area" bug
occurring in arch_kimage_file_post_load_cleanup() doing a
vfree(image->elf_headers) in our 5.14-based kernel yielded the following
double vfree() scenario, also present in mainline:

SYSCALL_DEFINE5(kexec_file_load)
  kimage_file_alloc_init()
    kimage_file_prepare_segments()
      arch_kexec_kernel_image_probe()
        kexec_image_load_default()
          kexec_bzImage64_ops.load()
            bzImage64_load()
              crash_load_segments()
                prepare_elf_headers(image, &kbuf.buffer, &kbuf.bufsz);
                image->elf_headers = kbuf.buffer;
		ret = kexec_add_buffer(&kbuf);
		if (ret) vfree((void *)image->elf_headers); // first vfree()
      if (ret) kimage_file_post_load_cleanup()
        vfree(image->elf_headers);                          // second vfree()

AFAICS the scenario is possible since v5.19 commit b3e34a47f989
("x86/kexec: fix memory leak of elf header buffer") that was marked for
stable and also was backported to our kernel.

Fix the problem by setting the pointer to NULL after the first vfree().
Also set elf_headers_sz to 0, as kimage_file_post_load_cleanup() does.

Fixes: b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/crash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 9730c88530fc..0d651c05a49e 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -403,6 +403,8 @@ int crash_load_segments(struct kimage *image)
 	ret = kexec_add_buffer(&kbuf);
 	if (ret) {
 		vfree((void *)image->elf_headers);
+		image->elf_headers = NULL;
+		image->elf_headers_sz = 0;
 		return ret;
 	}
 	image->elf_load_addr = kbuf.mem;
-- 
2.39.0

