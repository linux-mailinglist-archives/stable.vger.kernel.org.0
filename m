Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B41A329061
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbhCAUIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232845AbhCATzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:55:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A711365376;
        Mon,  1 Mar 2021 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621316;
        bh=YfUUascPf5OSvWUS3bZt/92bARlhjZObBC2MZXyhmGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGjDwXEz3neQndzFRgES5drtWuTGzhvQ0YFgtWa6eyWyfUF4opakR/ibQMGMxbqBg
         /YGipNnBsk0gq1Pfy7hg0KBJZbZREXCOPMENM2N0PF29qMm1ThR+CtB7HPH7fiybId
         6wfspubJvxZh9BaBauaJ87Vd2YhptCM7TMOl6ge0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 472/775] sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set
Date:   Mon,  1 Mar 2021 17:10:40 +0100
Message-Id: <20210301161224.867983651@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index c9c34dc52b7d8..639dde28124a2 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -494,7 +494,7 @@ config COMPAT
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



