Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCCC662250
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 11:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbjAIKBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 05:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237076AbjAIKBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 05:01:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E8F13CCE;
        Mon,  9 Jan 2023 02:00:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42987B80D6B;
        Mon,  9 Jan 2023 10:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4E7C433D2;
        Mon,  9 Jan 2023 10:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673258405;
        bh=Nh8eBv0pbdoP2Fxa0Ctewmwg/Sjiw7vgx4Zhp6AFwrA=;
        h=From:To:Cc:Subject:Date:From;
        b=EdhUqKnT0U1DCDLSZeOgg8imXGwMtcZDpAS0L2UdP7Qnhnu0aPLOTWQInj5B99Jx/
         SBnolViQ9rIKcFKvKNr6EtPMV4qSzwgX6Ms7SHlxLC7JSJmpGYXXOqAA6MyqZL1ui2
         7vrpUuhO9qRTE1HFsvOq/dxofg0+pHjnQLHfof+wbdkvhETy6iecVLn1FvB5F+w5bI
         FN2VCpCejswQJGSQEHVOxfUPmm+lFpIErf0MoGWZ7gXqJIEpLJOGvNkD7IKSCG/lOz
         S7teXnZnCZkV/NneFdsHSgDnrhJMTxiXsE++W390OA9BxAXcH4CJNK45OFiPouhSWD
         mTc6YZBK3YNSw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-efi@vger.kernel.org, will@kernel.org,
        catalin.marinas@arm.com, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org, Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log
Date:   Mon,  9 Jan 2023 10:59:48 +0100
Message-Id: <20230109095948.2471205-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1895; i=ardb@kernel.org; h=from:subject; bh=Nh8eBv0pbdoP2Fxa0Ctewmwg/Sjiw7vgx4Zhp6AFwrA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBju+WT2qQ1l9KxiZXUPY8HLSZjOTMomBF3ScVyUzK0 LTZ+0IiJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY7vlkwAKCRDDTyI5ktmPJDMTDA Ci5HPG2rRnKV8cwXA2HNl+/KRumoSC7n8OjYP/JkiSSIOyUvPnncFLgT5jvFUrACvk7+13y1lHLZ7x JUFxbLz6l6rT5CqM7ui/lwrmZ0rOlkWAoJOK9JnmVSmuMUI+Y5Wzi5BQGfKbR+DA2F15DFbNx/hLFf ffWg2A5SCnZ18H84EBGs3xAnqpF52K7r3mBOa0Y9Acu//XPcO+/yUVLJVKJTkesKz9FSIxmRWknUov pyXR1iMR50ZPWFuKguJN6sjkiNcZ4q8Cuw15f1DnFdXAmG78Sp/tmHtuOlBh+I+k3SK0bkWRI3VLMi MANfQ6Y9yfRj/2n0kTGBziW2otWc6eQhrpGkwYb+/Q8LUPzsYPn9yLsGXPDMt6fGJLkdVgCydWfN7e Gfcezgh/ArrAy+n6cjIa02uH9BJ6WLlvN3ODAxhYG7zj0gdzl8PYd+ScLuyaPQ5jaROAFVYDzNPC+d S2YzfKkfKGMluKmdWFEFOnYQ7dMwFOc4IkJsORAGv1kOA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
dereferenced again after it gets unmapped, so a compiler barrier should
be sufficient, and works around the reported issue.

Cc: <stable@vger.kernel.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1782
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/tpm_eventlog.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 20c0ff54b7a0d313..0abcc85904cba874 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -198,8 +198,10 @@ static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *ev
 	 * The loop below will unmap these fields if the log is larger than
 	 * one page, so save them here for reference:
 	 */
-	count = READ_ONCE(event->count);
-	event_type = READ_ONCE(event->event_type);
+	count = event->count;
+	event_type = event->event_type;
+
+	barrier();
 
 	/* Verify that it's the log header */
 	if (event_header->pcr_idx != 0 ||
-- 
2.39.0

