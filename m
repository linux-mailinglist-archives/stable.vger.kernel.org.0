Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1FD2A5758
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbgKCUzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732374AbgKCUzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20487223BD;
        Tue,  3 Nov 2020 20:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436940;
        bh=fT2YCojtvvQI4p8t8yrAfG1K0y5sbiUG8qfvU9f4FXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns4I56A5JWoB22m/TSwb5LA0HhkejMuGCov31M0S2XXFGsUP10Kgc3zOsyrMvCELX
         WR/lEBjSGDJOzlcbuHC3I6RjQMGoiI3ROg2n4XQaA4WqzRehAuODEx0x1GdRRN3M9k
         MNJFa2b8kRGT7LkgkayqLT3PkjGYoK0VM4L5JRp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/214] selftests/x86/fsgsbase: Reap a forgotten child
Date:   Tue,  3 Nov 2020 21:34:47 +0100
Message-Id: <20201103203253.744173940@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit ab2dd173330a3f07142e68cd65682205036cd00f ]

The ptrace() test forgot to reap its child.  Reap it.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/e7700a503f30e79ab35a63103938a19893dbeff2.1598461151.git.luto@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/fsgsbase.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/x86/fsgsbase.c b/tools/testing/selftests/x86/fsgsbase.c
index 15a329da59fa3..5f3aea210e018 100644
--- a/tools/testing/selftests/x86/fsgsbase.c
+++ b/tools/testing/selftests/x86/fsgsbase.c
@@ -499,6 +499,9 @@ static void test_ptrace_write_gsbase(void)
 
 END:
 	ptrace(PTRACE_CONT, child, NULL, NULL);
+	wait(&status);
+	if (!WIFEXITED(status))
+		printf("[WARN]\tChild didn't exit cleanly.\n");
 }
 
 int main()
-- 
2.27.0



