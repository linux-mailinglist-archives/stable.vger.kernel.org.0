Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D2318B70D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbgCSNVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730083AbgCSNVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:21:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76105206D7;
        Thu, 19 Mar 2020 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624073;
        bh=UU1CiJv8QNpyvkVa8gz91Hsjp4AYZbOgAmrjiT4G+e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoClOY8Cuhzc9TELcHrPY0vVLTg6tncCd9Bka7JGV0MNCkwRC3lIglXFT/1W0Drbp
         lKxp4BroajiVCA8WDULZinSu3ZFBFmg2aLBI+xzrESwUho0vJA9xN694e+95ZcPPkS
         cYiaS0xSsoPdnrLCVopRD+LkSz1xmm+n/YTHBhDg=
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
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 4.19 47/48] efi: Fix debugobjects warning on efi_rts_work
Date:   Thu, 19 Mar 2020 14:04:29 +0100
Message-Id: <20200319123917.572389749@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit ef1491e791308317bb9851a0ad380c4a68b58d54 upstream.

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
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/runtime-wrappers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -62,7 +62,7 @@ struct efi_runtime_work efi_rts_work;
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
-	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
+	INIT_WORK(&efi_rts_work.work, efi_call_rts);			\
 	efi_rts_work.arg1 = _arg1;					\
 	efi_rts_work.arg2 = _arg2;					\
 	efi_rts_work.arg3 = _arg3;					\


