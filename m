Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A037A3B6187
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhF1OgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234963AbhF1Oe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33DBF61C83;
        Mon, 28 Jun 2021 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890614;
        bh=w4g1Yro1aSeL1KLST5gE4jj4CVI7nznhLqmIM9an7uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkTDKmsnaQLodamyVo6A2NniBk74cKwY3ZQp0D/TtxeMRTsDQm2F9Il5AerxVEhsr
         2ntZaZ+KnkFEtR/l5fhh6qneOKgnYfVvAOdKJHrhMvaTmPRxvl2yhUqIG89mxEVWaI
         afUZXuZmkENE2lvsBt2/OvBasRd1vRDO1VujSUNaMkyWkAECM4VwL/urV5e8H3pPKh
         k17VbrhvXGxF77QfEtqjm7BDnSuz1vKfl8bdutgv/RgubK39sT5kB7pjqRWw3xMb6A
         iuVVkUJUbP09RGJDehQqL0vF4bYKkmjVdbfzum+/lLXtcg/vsXNsNZYm+vgmlL1i3o
         m+uSx8vHRP0Sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 08/71] kbuild: add CONFIG_LD_IS_LLD
Date:   Mon, 28 Jun 2021 10:29:01 -0400
Message-Id: <20210628143004.32596-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

commit b744b43f79cc758127042e71f9ad7b1afda30f84 upstream.

Similarly to the CC_IS_CLANG config, add LD_IS_LLD to avoid GNU ld
specific logic such as ld-version or ld-ifversion and gain the
ability to select potential features that depend on the linker at
configuration time such as LTO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Masahiro Yamada <masahiroy@kernel.org>
[nc: Reword commit message]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 4f9fd78e2200..f23e90d9935f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -20,6 +20,9 @@ config GCC_VERSION
 config CC_IS_CLANG
 	def_bool $(success,$(CC) --version | head -n 1 | grep -q clang)
 
+config LD_IS_LLD
+	def_bool $(success,$(LD) -v | head -n 1 | grep -q LLD)
+
 config CLANG_VERSION
 	int
 	default $(shell,$(srctree)/scripts/clang-version.sh $(CC))
-- 
2.30.2

