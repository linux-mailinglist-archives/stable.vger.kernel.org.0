Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC2F66AAB6
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjANJup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjANJuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:50:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0478F4495
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:50:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94A8960A0A
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B186C433D2;
        Sat, 14 Jan 2023 09:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689843;
        bh=PreuDEf7i2uOUdFURMKp5Oex5Ht/arPk0lgaL3IaoFM=;
        h=Subject:To:Cc:From:Date:From;
        b=NtrfLRkA67f79lXINRyGFz5+Az2rSSZj5ro9iG+HTsGCIOfjwOPRN+Pd0l1Yuvpvr
         uLzeG5FIqbY3U5TW+ygAFbjb3zfxC3HlygR8auGj85Kz+YH63s5OoM61UpL9wumCX8
         kGWaiW95rKE1Fs4DSNJiswW1v0Vg/fLlaO7LEfMc=
Subject: FAILED: patch "[PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log" failed to apply to 4.14-stable tree
To:     ardb@kernel.org, jarkko@kernel.org, mjg59@srcf.ucam.org,
        nathan@kernel.org, pjones@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:50:26 +0100
Message-ID: <1673689826120215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d3f450533bbc ("efi: tpm: Avoid READ_ONCE() for accessing the event log")
047d50aee341 ("efi/tpm: Don't access event->count when it isn't mapped")
c46f3405692d ("tpm: Reserve the TPM final events table")
44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
c8faabfc6f48 ("tpm: add _head suffix to tcg_efi_specid_event and tcg_pcr_event2")
3425d934fc03 ("efi/x86: Handle page faults occurring while running EFI runtime services")
9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
71e0940d52e1 ("efi: honour memory reservations passed via a linux specific config table")
50a7ca3c6fc8 ("mm: convert return type of handle_mm_fault() caller to vm_fault_t")
3eb420e70d87 ("efi: Use a work queue to invoke EFI Runtime Services")
c90fca951e90 ("Merge tag 'powerpc-4.18-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3f450533bbcb6dd4d7d59cadc9b61b7321e4ac1 Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 9 Jan 2023 10:44:31 +0100
Subject: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log

Nathan reports that recent kernels built with LTO will crash when doing
EFI boot using Fedora's GRUB and SHIM. The culprit turns out to be a
misaligned load from the TPM event log, which is annotated with
READ_ONCE(), and under LTO, this gets translated into a LDAR instruction
which does not tolerate misaligned accesses.

Interestingly, this does not happen when booting the same kernel
straight from the UEFI shell, and so the fact that the event log may
appear misaligned in memory may be caused by a bug in GRUB or SHIM.

However, using READ_ONCE() to access firmware tables is slightly unusual
in any case, and here, we only need to ensure that 'event' is not
dereferenced again after it gets unmapped, but this is already taken
care of by the implicit barrier() semantics of the early_memunmap()
call.

Cc: <stable@vger.kernel.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1782
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 20c0ff54b7a0..7d68a5cc5881 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -198,8 +198,8 @@ static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *ev
 	 * The loop below will unmap these fields if the log is larger than
 	 * one page, so save them here for reference:
 	 */
-	count = READ_ONCE(event->count);
-	event_type = READ_ONCE(event->event_type);
+	count = event->count;
+	event_type = event->event_type;
 
 	/* Verify that it's the log header */
 	if (event_header->pcr_idx != 0 ||

