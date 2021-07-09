Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C193C24E1
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhGINZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhGINZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 009D8613C9;
        Fri,  9 Jul 2021 13:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836955;
        bh=PzpvqfU6f5oLWuoHECyjw67HkBbYMx6fOd7uBxrq38g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h99U7f7bfp4OQiSK0pCpl2wcRMlpvZ/OIlEJn8L6Hb/KjeepJtSjlwQ2Q4Wj3vnVP
         RHPvjQ7xdZLVj87Hpfzra3nq2DPmtyC/sTcR5R2ya2HikR3qsGNVswUGZBGFj7lI/0
         9vtCXelZz1xJa3aGmwPefr9ZKKFR7XFh18+nsTIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sid Manning <sidneym@codeaurora.org>,
        Brian Cain <bcain@codeaurora.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.12 03/11] Hexagon: change jumps to must-extend in futex_atomic_*
Date:   Fri,  9 Jul 2021 15:21:40 +0200
Message-Id: <20210709131554.527225172@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sid Manning <sidneym@codeaurora.org>

commit 6fff7410f6befe5744d54f0418d65a6322998c09 upstream.

Cross-section jumps from .fixup section must be extended.

Signed-off-by: Sid Manning <sidneym@codeaurora.org>
Signed-off-by: Brian Cain <bcain@codeaurora.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/hexagon/include/asm/futex.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/hexagon/include/asm/futex.h
+++ b/arch/hexagon/include/asm/futex.h
@@ -21,7 +21,7 @@
 	"3:\n" \
 	".section .fixup,\"ax\"\n" \
 	"4: %1 = #%5;\n" \
-	"   jump 3b\n" \
+	"   jump ##3b\n" \
 	".previous\n" \
 	".section __ex_table,\"a\"\n" \
 	".long 1b,4b,2b,4b\n" \
@@ -90,7 +90,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	"3:\n"
 	".section .fixup,\"ax\"\n"
 	"4: %0 = #%6\n"
-	"   jump 3b\n"
+	"   jump ##3b\n"
 	".previous\n"
 	".section __ex_table,\"a\"\n"
 	".long 1b,4b,2b,4b\n"


