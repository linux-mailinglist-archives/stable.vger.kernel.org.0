Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B88B3286F5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbhCARSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:18:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236971AbhCARJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:09:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E85C64E99;
        Mon,  1 Mar 2021 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616961;
        bh=66sK3yAydc9g1KiW61EpXbNrkFOzjQ/pz/UJTDITgIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1V2QC2seGGazipH9z+Wk+wdS7pWT8BZtLDhzA1NadwsWeo7pK/oCzwokaWgVutNE7
         HY1riiDObCorAoSyXuQt3I9SZ3jCRCf9BKn2qEv+5eF0s8KuLxKe8ePXC0n2wu51/L
         CHVdamoNrEdILQIJH3cfV5RtOLFWLO8zzR0TPI4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/247] sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set
Date:   Mon,  1 Mar 2021 17:12:53 +0100
Message-Id: <20210301161039.153818631@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index e6f2a38d2e61e..1f1a7583fa905 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -554,7 +554,7 @@ config COMPAT
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



