Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDC0200FBB
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392835AbgFSPVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392824AbgFSPVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E3D520706;
        Fri, 19 Jun 2020 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580074;
        bh=1nuTO3/C9PLdayS+YAYuAtfHYtA++BUHbRE+Z0bXpyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDu1eD76p4eOLVHwhhqR4Hn9407ceJKCVigrdcQzadJc5erVfQ7lTmCpbBhHTX96l
         CINRZ1WnEuRmS+wbOnZB0rUdjKVd4M06AaSIDvBN72MBWp4Fr/jk4Ohqo1WcEaPcL2
         /RrEPIScMchzrXBDelcKhkgM3WfRjYzX3ZsMZbEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Elena Petrova <lenaptr@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 082/376] ubsan: entirely disable alignment checks under UBSAN_TRAP
Date:   Fri, 19 Jun 2020 16:30:00 +0200
Message-Id: <20200619141714.225619751@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 9380ce246a052a1e00121cd480028b6907aeae38 ]

Commit 8d58f222e85f ("ubsan: disable UBSAN_ALIGNMENT under
COMPILE_TEST") tried to fix the pathological results of UBSAN_ALIGNMENT
with UBSAN_TRAP (which objtool would rightly scream about), but it made
an assumption about how COMPILE_TEST gets set (it is not set for
randconfig).  As a result, we need a bigger hammer here: just don't
allow the alignment checks with the trap mode.

Fixes: 8d58f222e85f ("ubsan: disable UBSAN_ALIGNMENT under COMPILE_TEST")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Link: http://lkml.kernel.org/r/202005291236.000FCB6@keescook
Link: https://lore.kernel.org/lkml/742521db-1e8c-0d7a-1ed4-a908894fb497@infradead.org/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.ubsan | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index 929211039bac..27bcc2568c95 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -63,7 +63,7 @@ config UBSAN_SANITIZE_ALL
 config UBSAN_ALIGNMENT
 	bool "Enable checks for pointers alignment"
 	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
-	depends on !X86 || !COMPILE_TEST
+	depends on !UBSAN_TRAP
 	help
 	  This option enables the check of unaligned memory accesses.
 	  Enabling this option on architectures that support unaligned
-- 
2.25.1



