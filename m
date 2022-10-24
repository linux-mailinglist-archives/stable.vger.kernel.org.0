Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3B560B086
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiJXQGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiJXQEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2A311878C;
        Mon, 24 Oct 2022 07:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B16EB81668;
        Mon, 24 Oct 2022 12:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1618C433C1;
        Mon, 24 Oct 2022 12:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614153;
        bh=1hCw6cxNbX3YN2yD9VtMsbWe/TAy/Ij432ySJrqy94M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ia73eklo2J+eqZNCED9xxoEEWC6kvd6jIRYZpWLp8miraenbr2vie7+Xnc0T0UwwA
         meV8gzrI0i40Vvw/XBsZcnx4hV3UWih//I4PygnazYacFwi2khOnBUDxcxs5cmkwsl
         eOM9wI3ZUY479gAIV7yUhXXcpfLOsEh2ZgpVE3N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/390] x86/microcode/AMD: Track patch allocation size explicitly
Date:   Mon, 24 Oct 2022 13:28:39 +0200
Message-Id: <20221024113027.862630256@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 712f210a457d9c32414df246a72781550bc23ef6 ]

In preparation for reducing the use of ksize(), record the actual
allocation size for later memcpy(). This avoids copying extra
(uninitialized!) bytes into the patch buffer when the requested
allocation size isn't exactly the size of a kmalloc bucket.
Additionally, fix potential future issues where runtime bounds checking
will notice that the buffer was allocated to a smaller value than
returned by ksize().

Fixes: 757885e94a22 ("x86, microcode, amd: Early microcode patch loading support for AMD")
Suggested-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/lkml/CA+DvKQ+bp7Y7gmaVhacjv9uF6Ar-o4tet872h4Q8RPYPJjcJQA@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/microcode.h    | 1 +
 arch/x86/kernel/cpu/microcode/amd.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 91a06cef50c1..f73327397b89 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -9,6 +9,7 @@
 struct ucode_patch {
 	struct list_head plist;
 	void *data;		/* Intel uses only this one */
+	unsigned int size;
 	u32 patch_id;
 	u16 equiv_cpu;
 };
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 3f6b137ef4e6..c87936441339 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -783,6 +783,7 @@ static int verify_and_add_patch(u8 family, u8 *fw, unsigned int leftover,
 		kfree(patch);
 		return -EINVAL;
 	}
+	patch->size = *patch_size;
 
 	mc_hdr      = (struct microcode_header_amd *)(fw + SECTION_HDR_SIZE);
 	proc_id     = mc_hdr->processor_rev_id;
@@ -864,7 +865,7 @@ load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
 		return ret;
 
 	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
-	memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
+	memcpy(amd_ucode_patch, p->data, min_t(u32, p->size, PATCH_MAX_SIZE));
 
 	return ret;
 }
-- 
2.35.1



