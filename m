Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D406147ABF
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731123AbgAXJhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbgAXJhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:37:32 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26C7520838;
        Fri, 24 Jan 2020 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858652;
        bh=LdMtAhIRiJYllcyWrGJwebZShdEmQUxBWrHKPuLMNuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEm1EGLJbKyyPgc0Eb+7puxW0tu8/CL0+lJEacJm6I/wbX/m8QaWivnG/Dx/u+7En
         8ztPzNw1Uu2BI28KPkfE75dttb08jMczP+6Jczm5iM5hAhvfIEok4kv61jtAK7+u4M
         97Op4SwjRc0blpapjGBeBvWt/UYCsiLVUMl/W488=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Waiman Long <longman@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/639] Revert "efi: Fix debugobjects warning on efi_rts_work"
Date:   Fri, 24 Jan 2020 10:22:51 +0100
Message-Id: <20200124093047.257102718@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 3e6b472f474accf757e107919f8ee42e7315ac0d which is
commit ef1491e791308317bb9851a0ad380c4a68b58d54 upstream.

Chris reports that this commit has problems and should not have been
backported to 4.19.y

Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Waiman Long <longman@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/runtime-wrappers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -95,7 +95,7 @@ struct efi_runtime_work {
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
-	INIT_WORK(&efi_rts_work.work, efi_call_rts);			\
+	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
 	efi_rts_work.arg1 = _arg1;					\
 	efi_rts_work.arg2 = _arg2;					\
 	efi_rts_work.arg3 = _arg3;					\


