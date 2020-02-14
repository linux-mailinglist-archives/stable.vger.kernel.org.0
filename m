Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484DB15E7EF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394335AbgBNQ5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404555AbgBNQRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5F224694;
        Fri, 14 Feb 2020 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697069;
        bh=F+r6f7D9VWB0JUgqPSAS30JtMBZ1mLZZa7QocF23OE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLkdE8uAzODuanH7BC+a0F85zpluJ0HL7awHCHgKKtuZKVrpwd4/B3VwT0WzWbFL2
         a6j2m+CacIw1iVSGYC0jmqtPoARp8pTSXWGu7+D4dc1n09esVB+Ly0DJG0aZUxCbEr
         fKdvqKu5JD1v1Av5NNELwUeOsoCBdhNb1hcPml6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 025/186] sparc: Add .exit.data section.
Date:   Fri, 14 Feb 2020 11:14:34 -0500
Message-Id: <20200214161715.18113-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 548f0b9a5f4cffa0cecf62eb12aa8db682e4eee6 ]

This fixes build errors of all sorts.

Also, emit .exit.text unconditionally.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/vmlinux.lds.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 5a2344574f39b..4323dc4ae4c7a 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -167,12 +167,14 @@ SECTIONS
 	}
 	PERCPU_SECTION(SMP_CACHE_BYTES)
 
-#ifdef CONFIG_JUMP_LABEL
 	. = ALIGN(PAGE_SIZE);
 	.exit.text : {
 		EXIT_TEXT
 	}
-#endif
+
+	.exit.data : {
+		EXIT_DATA
+	}
 
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-- 
2.20.1

