Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF166C482
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjAPPz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjAPPzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D612234DB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79A106102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9273EC433D2;
        Mon, 16 Jan 2023 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884526;
        bh=QdC4cgQODGkKUIbrNESF99GYx8pGTR1ixjbIP1YIP3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oesxEViYW8NFD1pImV3Vq3QUVrOon0zRGf2yONEKvxfcDqVP/lTyfNHCmTAMt4WSA
         XC0JgKM2fwK5Rc6j6cd7opTqiAFbmoG1m0uw5hvWlsSRYf1MR12kDQ6pCZTXhjHafC
         SKnAm4Z8UTIU2DMTr49br1GwHpMhqYyrr+GVcEp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 010/183] efi: tpm: Avoid READ_ONCE() for accessing the event log
Date:   Mon, 16 Jan 2023 16:48:53 +0100
Message-Id: <20230116154803.819910275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit d3f450533bbcb6dd4d7d59cadc9b61b7321e4ac1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tpm_eventlog.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -198,8 +198,8 @@ static __always_inline int __calc_tpm2_e
 	 * The loop below will unmap these fields if the log is larger than
 	 * one page, so save them here for reference:
 	 */
-	count = READ_ONCE(event->count);
-	event_type = READ_ONCE(event->event_type);
+	count = event->count;
+	event_type = event->event_type;
 
 	/* Verify that it's the log header */
 	if (event_header->pcr_idx != 0 ||


