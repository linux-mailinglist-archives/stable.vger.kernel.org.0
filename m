Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910221FBB53
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgFPPhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730341AbgFPPhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:37:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1E4D20C56;
        Tue, 16 Jun 2020 15:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321860;
        bh=dC7qEY8RWldK5Tu4/BHmKfll+FauoIDgIQY9R1Du2LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUlf1cO4W3qxLyVbYDP6/guI1Ai/lAoRRJhRZ0q7y15B3aZ66gq/UV0FQdVJTAURr
         nX9rR1/pHCfnYcNOQo4qcTMw0HwrPH5Tk5V0Ol4VP2cAE2AojLZetQflYKMrmzN+Nk
         356SjhcrZ4+hKKJLF29IYT3uHUG/2CZe49FX7t+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/134] csky: Fixup abiv2 syscall_trace break a4 & a5
Date:   Tue, 16 Jun 2020 17:33:17 +0200
Message-Id: <20200616153101.327933348@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit e0bbb53843b5fdfe464b099217e3b9d97e8a75d7 ]

Current implementation could destory a4 & a5 when strace, so we need to get them
from pt_regs by SAVE_ALL.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/abiv2/inc/abi/entry.h | 2 ++
 arch/csky/kernel/entry.S        | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/csky/abiv2/inc/abi/entry.h b/arch/csky/abiv2/inc/abi/entry.h
index 9023828ede97..ac8f65a3e75a 100644
--- a/arch/csky/abiv2/inc/abi/entry.h
+++ b/arch/csky/abiv2/inc/abi/entry.h
@@ -13,6 +13,8 @@
 #define LSAVE_A1	28
 #define LSAVE_A2	32
 #define LSAVE_A3	36
+#define LSAVE_A4	40
+#define LSAVE_A5	44
 
 #define KSPTOUSP
 #define USPTOKSP
diff --git a/arch/csky/kernel/entry.S b/arch/csky/kernel/entry.S
index 65c55f22532a..4349528fbf38 100644
--- a/arch/csky/kernel/entry.S
+++ b/arch/csky/kernel/entry.S
@@ -170,8 +170,10 @@ csky_syscall_trace:
 	ldw	a3, (sp, LSAVE_A3)
 #if defined(__CSKYABIV2__)
 	subi	sp, 8
-	stw	r5, (sp, 0x4)
-	stw	r4, (sp, 0x0)
+	ldw	r9, (sp, LSAVE_A4)
+	stw	r9, (sp, 0x0)
+	ldw	r9, (sp, LSAVE_A5)
+	stw	r9, (sp, 0x4)
 #else
 	ldw	r6, (sp, LSAVE_A4)
 	ldw	r7, (sp, LSAVE_A5)
-- 
2.25.1



