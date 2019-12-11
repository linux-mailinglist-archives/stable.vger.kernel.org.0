Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7035011B545
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732287AbfLKPUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732149AbfLKPT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4844224658;
        Wed, 11 Dec 2019 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077598;
        bh=V3+W7ZWCbX77NaZBAeU295+GDlSRMBaIq1zVLZZiujw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=poHivdjGMroeZXwEfls2jXF5YcLXikHd5x2JEK7BG9vaQqAI1ujXtieLR8LXyXTkY
         ogwnAJGJFhZ1YNHWRPQ9yQbZ9G2kR1cCq4fetkY3FNDnhVfOZoJPQxL8LaTfd7NI35
         laEoVMmuVjhMovQ8uhsSJp6K11F9r7qpzSPLcP3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Breno Leitao <leitao@debian.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/243] selftests/powerpc: Skip test instead of failing
Date:   Wed, 11 Dec 2019 16:04:20 +0100
Message-Id: <20191211150345.730535239@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit eafcd8e3fbad4f426a40ed2b6a8c697c3a4ef36a ]

Current core-pkey selftest fails if the test runs without privileges to
write into the core pattern file (/proc/sys/kernel/core_pattern). This
causes the test to fail and give the impression that the subsystem being
tested is broken, when, in fact, the test is being executed without the
proper privileges. This is the current error:

	test: core_pkey
	tags: git_version:v4.19-3-g9e3363be9bce-dirty
	Error writing to core_pattern file: Permission denied
	failure: core_pkey

This patch simply skips this test if it runs without the proper privileges,
avoiding this undesired failure.

CC: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
CC: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/ptrace/core-pkey.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/core-pkey.c b/tools/testing/selftests/powerpc/ptrace/core-pkey.c
index e23e2e199eb4e..d5c64fee032dc 100644
--- a/tools/testing/selftests/powerpc/ptrace/core-pkey.c
+++ b/tools/testing/selftests/powerpc/ptrace/core-pkey.c
@@ -352,10 +352,7 @@ static int write_core_pattern(const char *core_pattern)
 	FILE *f;
 
 	f = fopen(core_pattern_file, "w");
-	if (!f) {
-		perror("Error writing to core_pattern file");
-		return TEST_FAIL;
-	}
+	SKIP_IF_MSG(!f, "Try with root privileges");
 
 	ret = fwrite(core_pattern, 1, len, f);
 	fclose(f);
-- 
2.20.1



