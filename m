Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5E15DB73
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfGCCPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfGCCPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67686218A3;
        Wed,  3 Jul 2019 02:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120137;
        bh=kxd6DhSp0GnWT3gKbEadLw4u2K2Ny8vIqZRTBU3o9zI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IP4pcFdYItVDa6lu9q8+cT88ZD/tCPgk0fJ0KK27f7rNtzR/Rb25VEOPpAXRJSGLl
         mmU25ISJVJS2xtXONrIzkNhyZAFeXhKIQB61K1IZoURtUFTFv3v97rkxNRc4FUYwNQ
         F9dkSoLpxM0NnoBsxzMzGIsX60BL6IxCVoj8aS3E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>,
        "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 14/39] x86/efi: fix a -Wtype-limits compilation warning
Date:   Tue,  2 Jul 2019 22:14:49 -0400
Message-Id: <20190703021514.17727-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 919aef44d73d5d0c04213cb1bc31149cc074e65e ]

Compiling a kernel with W=1 generates this warning,

arch/x86/platform/efi/quirks.c:731:16: warning: comparison of unsigned
expression >= 0 is always true [-Wtype-limits]

Fixes: 3425d934fc03 ("efi/x86: Handle page faults occurring while running ...")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index a25a9fd987a9..529522c62d89 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -724,7 +724,7 @@ void efi_recover_from_page_fault(unsigned long phys_addr)
 	 * Address range 0x0000 - 0x0fff is always mapped in the efi_pgd, so
 	 * page faulting on these addresses isn't expected.
 	 */
-	if (phys_addr >= 0x0000 && phys_addr <= 0x0fff)
+	if (phys_addr <= 0x0fff)
 		return;
 
 	/*
-- 
2.20.1

