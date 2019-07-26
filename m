Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6935E76A12
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387805AbfGZNl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbfGZNly (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE6DC22BF5;
        Fri, 26 Jul 2019 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148513;
        bh=p68XiTC1LTWllQk29SVgoAQsHI6JE9Recy3GGh2LFFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEFDqa+AfqiuXz9z/Ug67UyN9k7Oxz3YK+CAn3dPnJEA5Pf1Rx5sGEFqYcqUBE03r
         N8xUiu0gDehocxVgsg5h7uMTtFbjCKpx9Fvs+7SjCQeiD4P5SPF4kUO5slRQUDmuzV
         xKRk6YmVo2gUsjWEOpegzb+u+SHqKwoGV1Q9txfc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 76/85] x86/uaccess: Remove ELF function annotation from copy_user_handle_tail()
Date:   Fri, 26 Jul 2019 09:39:26 -0400
Message-Id: <20190726133936.11177-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 3a6ab4bcc52263dd5b1d2fd2e4ce95a38c798b4d ]

After an objtool improvement, it's complaining about the CLAC in
copy_user_handle_tail():

  arch/x86/lib/copy_user_64.o: warning: objtool: .altinstr_replacement+0x12: redundant UACCESS disable
  arch/x86/lib/copy_user_64.o: warning: objtool:   copy_user_handle_tail()+0x6: (alt)
  arch/x86/lib/copy_user_64.o: warning: objtool:   copy_user_handle_tail()+0x2: (alt)
  arch/x86/lib/copy_user_64.o: warning: objtool:   copy_user_handle_tail()+0x0: <=== (func)

copy_user_handle_tail() is incorrectly marked as a callable function, so
objtool is rightfully concerned about the CLAC with no corresponding
STAC.

Remove the ELF function annotation.  The copy_user_handle_tail() code
path is already verified by objtool because it's jumped to by other
callable asm code (which does the corresponding STAC).

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/6b6e436774678b4b9873811ff023bd29935bee5b.1563413318.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/copy_user_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 378a1f70ae7d..4fe1601dbc5d 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -239,7 +239,7 @@ copy_user_handle_tail:
 	ret
 
 	_ASM_EXTABLE_UA(1b, 2b)
-ENDPROC(copy_user_handle_tail)
+END(copy_user_handle_tail)
 
 /*
  * copy_user_nocache - Uncached memory copy with exception handling
-- 
2.20.1

