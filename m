Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBD015F05B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388583AbgBNRyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:54:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388473AbgBNP6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB6A224681;
        Fri, 14 Feb 2020 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695886;
        bh=FSZNZhAOFhYYMThmr+oCAnsLgXdPEgdWYjoPiw6Ulfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLJaeKm1o/ntxSh/1NTXAw0he0D4TMUGDTtSilHskdtKyRlvvYpv1JQEYhfjF31/c
         PYtBym8hIS2nFHolg5+4drfOaFfyrtX3PmLGxgBpdGL36QHK43DMrgsYh8bvarSCvs
         ICauRyL+H0fkXxOqujUBWJS3VnC8aZ6NrsjSSWNQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 430/542] kbuild: use -S instead of -E for precise cc-option test in Kconfig
Date:   Fri, 14 Feb 2020 10:47:02 -0500
Message-Id: <20200214154854.6746-430-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3bed1b7b9d79ca40e41e3af130931a3225e951a3 ]

Currently, -E (stop after the preprocessing stage) is used to check
whether the given compiler flag is supported.

While it is faster than -S (or -c), it can be false-positive. You need
to run the compilation proper to check the flag more precisely.

For example, -E and -S disagree about the support of
"--param asan-instrument-allocas=1".

$ gcc -Werror --param asan-instrument-allocas=1 -E -x c /dev/null -o /dev/null
$ echo $?
0

$ gcc -Werror --param asan-instrument-allocas=1 -S -x c /dev/null -o /dev/null
cc1: error: invalid --param name ‘asan-instrument-allocas’; did you mean ‘asan-instrument-writes’?
$ echo $?
1

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kconfig.include | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index d4adfbe426903..bfb44b265a948 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -25,7 +25,7 @@ failure = $(if-success,$(1),n,y)
 
 # $(cc-option,<flag>)
 # Return y if the compiler supports <flag>, n otherwise
-cc-option = $(success,$(CC) -Werror $(CLANG_FLAGS) $(1) -E -x c /dev/null -o /dev/null)
+cc-option = $(success,$(CC) -Werror $(CLANG_FLAGS) $(1) -S -x c /dev/null -o /dev/null)
 
 # $(ld-option,<flag>)
 # Return y if the linker supports <flag>, n otherwise
-- 
2.20.1

