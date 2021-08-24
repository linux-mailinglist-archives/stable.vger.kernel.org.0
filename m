Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1093F6429
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbhHXRBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239152AbhHXQ74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF68E613CD;
        Tue, 24 Aug 2021 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824258;
        bh=2Pn+Mp4FVPMb6fWNViq2NqcBXn4g6e17Pw+se5gNxRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mx6hXWQaumNdqDOb9LgEwFVqvIJo07l54vviy4qpCTK5gP9TnCiV5gdWpAl2KFRHp
         mpXtwcenswIeBvfQ1UyZARRbrgyRJ8KOOOU4Q6MFq72/PfUPiswyb3HaP9Nmkz8X7i
         pM3MOjFNilrJ6Az8/HboOTmhUxLRj+js94hLQbqh5/Hfo8X2pi6wjwyRqUedtInADg
         etSy/hEp5gPVNFXMYBGglE1O03QoL6/YZgz3aDDXSuG0C737dBCBAYxTUcXSv/hKo9
         DTSnepPNEnNklyuOaiojaDG2MfN5uc7rc7YesN6KTdoDDes0AKryMSFsIod+1vhnuZ
         Ung9XGBQrzLEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Delgadillo <adelg@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 091/127] arm64: clean vdso & vdso32 files
Date:   Tue, 24 Aug 2021 12:55:31 -0400
Message-Id: <20210824165607.709387-92-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Delgadillo <adelg@google.com>

[ Upstream commit 017f5fb9ce793e3558db94ee72068622bc0b79db ]

commit a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
changes the cleaning behavior of arm64's vdso files, in that vdso.lds,
vdso.so, and vdso.so.dbg are not removed upon a 'make clean/mrproper':

$ make defconfig ARCH=arm64
$ make ARCH=arm64
$ make mrproper ARCH=arm64
$ git clean -nxdf
Would remove arch/arm64/kernel/vdso/vdso.lds
Would remove arch/arm64/kernel/vdso/vdso.so
Would remove arch/arm64/kernel/vdso/vdso.so.dbg

To remedy this, manually descend into arch/arm64/kernel/vdso upon
cleaning.

After this commit:
$ make defconfig ARCH=arm64
$ make ARCH=arm64
$ make mrproper ARCH=arm64
$ git clean -nxdf
<empty>

Similar results are obtained for the vdso32 equivalent.

Signed-off-by: Andrew Delgadillo <adelg@google.com>
Cc: stable@vger.kernel.org
Fixes: a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
Link: https://lore.kernel.org/r/20210810231755.1743524-1-adelg@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index b52481f0605d..02997b253dee 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -181,6 +181,8 @@ archprepare:
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
+	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso
+	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso32
 
 ifeq ($(KBUILD_EXTMOD),)
 # We need to generate vdso-offsets.h before compiling certain files in kernel/.
-- 
2.30.2

