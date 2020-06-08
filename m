Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF09C1F2318
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgFHXMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbgFHXMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8035220897;
        Mon,  8 Jun 2020 23:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657951;
        bh=7LvtuBEfEARJ4C3bAoCTpWgj4kiNyoFDh4ndTV3l0RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2ncPrcJyYFmbitGDaC1Z9hSqsiTdmhXiBMyvriO+XKcdR+PoQL8/Ib8sfjfTpsBz
         anuoUhbIAqFFqUgyMkxxWPBCVdH0X9MEXomtku7knBt+/m5dkH3CCTnJwx/lOb1X/d
         eXcyh4AwCeVQYmGN0tJORTc5G1GZwDjUSWe6vqxM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 016/606] gcc-10: mark more functions __init to avoid section mismatch warnings
Date:   Mon,  8 Jun 2020 19:02:21 -0400
Message-Id: <20200608231211.3363633-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e99332e7b4cda6e60f5b5916cf9943a79dbef902 upstream.

It seems that for whatever reason, gcc-10 ends up not inlining a couple
of functions that used to be inlined before.  Even if they only have one
single callsite - it looks like gcc may have decided that the code was
unlikely, and not worth inlining.

The code generation difference is harmless, but caused a few new section
mismatch errors, since the (now no longer inlined) function wasn't in
the __init section, but called other init functions:

   Section mismatch in reference from the function kexec_free_initrd() to the function .init.text:free_initrd_mem()
   Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memremap()
   Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()

So add the appropriate __init annotation to make modpost not complain.
In both cases there were trivially just a single callsite from another
__init function.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/tpm.c | 2 +-
 init/initramfs.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 31f9f0e369b9..55b031d2c989 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -16,7 +16,7 @@
 int efi_tpm_final_log_size;
 EXPORT_SYMBOL(efi_tpm_final_log_size);
 
-static int tpm2_calc_event_log_size(void *data, int count, void *size_info)
+static int __init tpm2_calc_event_log_size(void *data, int count, void *size_info)
 {
 	struct tcg_pcr_event2_head *header;
 	int event_size, size = 0;
diff --git a/init/initramfs.c b/init/initramfs.c
index 8ec1be4d7d51..7a38012e1af7 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -542,7 +542,7 @@ void __weak free_initrd_mem(unsigned long start, unsigned long end)
 }
 
 #ifdef CONFIG_KEXEC_CORE
-static bool kexec_free_initrd(void)
+static bool __init kexec_free_initrd(void)
 {
 	unsigned long crashk_start = (unsigned long)__va(crashk_res.start);
 	unsigned long crashk_end   = (unsigned long)__va(crashk_res.end);
-- 
2.25.1

