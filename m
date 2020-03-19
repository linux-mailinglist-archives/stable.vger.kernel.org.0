Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A70518B70A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgCSNVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbgCSNVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:21:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D43C206D7;
        Thu, 19 Mar 2020 13:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624061;
        bh=TrcHvj+t0zhknyADv/MVGhq72AnAb4DxejAlu6KPi50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qi3426zyh4xBHbWC9gObPkLXiSQB73uwyFyHDyKhh2cFQEmo/jt/7oczZ5o1ut6iC
         ZD8XGqoaIURM+0Xn0+SUzDEGv5WPOAmEmateS+PasiIKK/OMYhSueiBFZclViSRk1X
         6EKzs8NGLOJBqhI2108t+Y8rfgM1xZvkcTJO8AsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 44/48] ARM: 8958/1: rename missed uaccess .fixup section
Date:   Thu, 19 Mar 2020 14:04:26 +0100
Message-Id: <20200319123916.638882713@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit f87b1c49bc675da30d8e1e8f4b60b800312c7b90 upstream.

When the uaccess .fixup section was renamed to .text.fixup, one case was
missed. Under ld.bfd, the orphaned section was moved close to .text
(since they share the "ax" bits), so things would work normally on
uaccess faults. Under ld.lld, the orphaned section was placed outside
the .text section, making it unreachable.

Link: https://github.com/ClangBuiltLinux/linux/issues/282
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1020633#c44
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.1912032147340.17114@knanqh.ubzr
Link: https://lore.kernel.org/lkml/202002071754.F5F073F1D@keescook/

Fixes: c4a84ae39b4a5 ("ARM: 8322/1: keep .text and .fixup regions closer together")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/lib/copy_from_user.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/lib/copy_from_user.S
+++ b/arch/arm/lib/copy_from_user.S
@@ -100,7 +100,7 @@ ENTRY(arm_copy_from_user)
 
 ENDPROC(arm_copy_from_user)
 
-	.pushsection .fixup,"ax"
+	.pushsection .text.fixup,"ax"
 	.align 0
 	copy_abort_preamble
 	ldmfd	sp!, {r1, r2, r3}


