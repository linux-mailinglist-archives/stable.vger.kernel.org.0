Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4D114C90
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbfEFOln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbfEFOln (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:41:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C528520C01;
        Mon,  6 May 2019 14:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153702;
        bh=qH/V5U6geHfVfZ2F0E2UNIsWNssJW+kuSQOBNqbi2HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1I+JB++m46OLxqP7oQoXxrc2rP7Ol6eq8MEzM/Bt9hSdPPPXODvC9OE5Fx5p5Up/L
         3PGkr2NwxZBSKf2ZbmBeSpgGi7jZzZw2/j6YwP0czehPdpUfvwkiJ6CP2GU2PybTMm
         VJV6GURGxjvj0ORwmZkVkJFulJpi4Jd7fK5Z1/lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/99] efi: Fix debugobjects warning on efi_rts_work
Date:   Mon,  6 May 2019 16:31:53 +0200
Message-Id: <20190506143055.740457435@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ef1491e791308317bb9851a0ad380c4a68b58d54 ]

The following commit:

  9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")

converted 'efi_rts_work' from an auto variable to a global variable.
However, when submitting the work, INIT_WORK_ONSTACK() was still used,
causing the following complaint from debugobjects:

  ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760, but annotated.

Change the macro to just INIT_WORK() to eliminate the warning.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
Link: http://lkml.kernel.org/r/20181114175544.12860-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index b0aeffd4e269..1606abead22c 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -95,7 +95,7 @@ struct efi_runtime_work {
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
-	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
+	INIT_WORK(&efi_rts_work.work, efi_call_rts);			\
 	efi_rts_work.arg1 = _arg1;					\
 	efi_rts_work.arg2 = _arg2;					\
 	efi_rts_work.arg3 = _arg3;					\
-- 
2.20.1



