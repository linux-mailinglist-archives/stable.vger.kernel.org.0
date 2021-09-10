Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA640624F
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241586AbhIJApR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231845AbhIJAVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6555061101;
        Fri, 10 Sep 2021 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233195;
        bh=E6LO8Evxc/kELFhWpj9aOvNIuz/nQCSGT3jzTP1Wqk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayz0teXC3IZsWgAJMTXCpC1ratUC1IonGEnK2K3VqhPXGPPWxKRPBB8De+vLjJhDg
         iY6Sx+LxE1M94eGUjLdf728JCwNmuqJdjSC054QMR3jsl/PRZo0IVmrvs1AXLLe21M
         1dXPoaP0N3hzx4TOQiTBLi6C1vCHBG7Gksvqs2QBKhOkNyKuNvfyFeAVAPtyu/V184
         e8ya3kA3D8AH/+iC48j6Oqil8OCIEs7f3g3bEG27tnVlGazCelAzMjIMVNJjfcK+i7
         GXSOEUnHGRJqU76/54ayKBaRStrM0WLnC0Rlw4bOy/8PaIsHFmTOwmP1MflU1+iRRA
         a8WybvSxP1t5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linux.alibaba.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 67/88] selftests: openat2: Fix testing failure for O_LARGEFILE flag
Date:   Thu,  9 Sep 2021 20:17:59 -0400
Message-Id: <20210910001820.174272-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit d538ddb97e066571e4fc58b832f40739621b42bb ]

The openat2 test suite fails on ARM64 because the definition of
O_LARGEFILE is different on ARM64. Fix the problem by defining
the correct O_LARGEFILE definition on ARM64.

"openat2 unexpectedly returned # 3['.../tools/testing/selftests/openat2']
with 208000 (!= 208000)
not ok 102 openat2 with incompatible flags (O_PATH | O_LARGEFILE) fails
with -22 (Invalid argument)"

Fixed change log to improve formatting and clarity:
Shuah Khan <skhan@linuxfoundation.org>

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/openat2_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 381d874cce99..300af824b07b 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -22,7 +22,11 @@
  * XXX: This is wrong on {mips, parisc, powerpc, sparc}.
  */
 #undef	O_LARGEFILE
+#ifdef __aarch64__
+#define	O_LARGEFILE 0x20000
+#else
 #define	O_LARGEFILE 0x8000
+#endif
 
 struct open_how_ext {
 	struct open_how inner;
-- 
2.30.2

