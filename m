Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0735E34419F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhCVMeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231334AbhCVMdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BB20619AA;
        Mon, 22 Mar 2021 12:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416419;
        bh=a2Ra/mksqsGTGh+WCV68awS7xaExptq72GPvHAF62G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FD6yfLlpjBPLWdGsHYMKtrElbXuY9uNcZt7aKU9hkR9J4YOrzXqs31irzvoOD7T7W
         gmZw7Y4bjeaniU92H/QciuNWEM6SuCCJpN4W+9nx6ZtVVucc5v0YNkExFZmxl4Zr/e
         tt8bj+FRoXlOydqhwiWTt5+uWS0Yaljg3qRd+t+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 072/120] powerpc/vdso32: Add missing _restgpr_31_x to fix build failure
Date:   Mon, 22 Mar 2021 13:27:35 +0100
Message-Id: <20210322121932.079625552@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 08c18b63d9656e0389087d1956d2b37fd7019172 ]

With some defconfig including CONFIG_CC_OPTIMIZE_FOR_SIZE,
(for instance mvme5100_defconfig and ps3_defconfig), gcc 5
generates a call to _restgpr_31_x.

Until recently it went unnoticed, but
commit 42ed6d56ade2 ("powerpc/vdso: Block R_PPC_REL24 relocations")
made it rise to the surface.

Provide that function (copied from lib/crtsavres.S) in
gettimeofday.S

Fixes: ab037dd87a2f ("powerpc/vdso: Switch VDSO to generic C implementation.")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a7aa198a88bcd33c6e35e99f70f86c7b7f2f9440.1615270757.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso32/gettimeofday.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kernel/vdso32/gettimeofday.S
index a6e29f880e0e..d21d08140a5e 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -65,3 +65,14 @@ V_FUNCTION_END(__kernel_clock_getres)
 V_FUNCTION_BEGIN(__kernel_time)
 	cvdso_call_time __c_kernel_time
 V_FUNCTION_END(__kernel_time)
+
+/* Routines for restoring integer registers, called by the compiler.  */
+/* Called with r11 pointing to the stack header word of the caller of the */
+/* function, just beyond the end of the integer restore area.  */
+_GLOBAL(_restgpr_31_x)
+_GLOBAL(_rest32gpr_31_x)
+	lwz	r0,4(r11)
+	lwz	r31,-4(r11)
+	mtlr	r0
+	mr	r1,r11
+	blr
-- 
2.30.1



