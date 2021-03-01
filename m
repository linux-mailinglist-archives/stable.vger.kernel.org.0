Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555B0328568
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbhCAQxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235242AbhCAQrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D86D364F9D;
        Mon,  1 Mar 2021 16:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616295;
        bh=kBEix182w2bi50NGpwe+wfAnwWIV81svujiD9dN5yzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkxzpAZZryjc6ba/jP93INabWMVqGVlqH/bzIqtjBsIpzC753UNpf/APo+0MwKisK
         Q19HfyVR03VA1jfy0cG7L9I/7/WGV3P6jiR3sw9VAYoXY9PTySA5AIg2td8IyXWM6v
         k1hgVspY+qUVX36j6SscJ+kepWAx9SlUS5vfsUak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/176] sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set
Date:   Mon,  1 Mar 2021 17:12:55 +0100
Message-Id: <20210301161026.043278363@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 80bddf5c93a99e11fc9faf7e4b575d01cecd45d3 ]

Currently COMPAT on SPARC64 selects COMPAT_BINFMT_ELF unconditionally,
even when BINFMT_ELF is not enabled. This causes a kconfig warning.

Instead, just select COMPAT_BINFMT_ELF if BINFMT_ELF is enabled.
This builds cleanly with no kconfig warnings.

WARNING: unmet direct dependencies detected for COMPAT_BINFMT_ELF
  Depends on [n]: COMPAT [=y] && BINFMT_ELF [=n]
  Selected by [y]:
  - COMPAT [=y] && SPARC64 [=y]

Fixes: 26b4c912185a ("sparc,sparc64: unify Kconfig files")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4e83f950713e9..76734ec93e1f0 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -574,7 +574,7 @@ config COMPAT
 	bool
 	depends on SPARC64
 	default y
-	select COMPAT_BINFMT_ELF
+	select COMPAT_BINFMT_ELF if BINFMT_ELF
 	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
 	select COMPAT_OLD_SIGACTION
-- 
2.27.0



