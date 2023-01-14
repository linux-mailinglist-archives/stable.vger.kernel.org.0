Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3F166AAB5
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjANJub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjANJua (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:50:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D536E172F
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:50:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7189960765
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F42C433EF;
        Sat, 14 Jan 2023 09:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689828;
        bh=o9CPXJftg6Nxd/PfLwHui3HZIh9vE4qtYiPWTGzfa6I=;
        h=Subject:To:Cc:From:Date:From;
        b=b9cD3ihp0wn/JXAu13UCkTCX5/7BeLqWJnG2f7YL9vo2t/P+o0wX7bsdvqKvWWVnd
         SiVmSogH+WTtZqV5MhUcQX88RFrkH9XojKlaD+3jpgSzamX3IpdO8HG/3i2Er10HHX
         AwxRh0cGFX8iH08gVPGLFE8ENq9yPxEXL1/Ne60w=
Subject: FAILED: patch "[PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log" failed to apply to 4.19-stable tree
To:     ardb@kernel.org, jarkko@kernel.org, mjg59@srcf.ucam.org,
        nathan@kernel.org, pjones@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:50:25 +0100
Message-ID: <167368982522206@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
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

