Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C03411C2F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346287AbhITRGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345942AbhITREq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:04:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E765161361;
        Mon, 20 Sep 2021 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156872;
        bh=26DpxREAUW4RnhxRwr/LD/ekH0ARh3OLBDizhE3yZ2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yh5S2qeJsQ8AEd3nMuSr5DvGVE4ylQOsXCHW/QFON21RTo0Kzn1JVcQLS2B0Cgvbm
         dPKIlcORfpIpElAVlZ9cs2doPGyc8hQUdt2XZUIfMxXTl5EQr7cc5ApchFyHw2cJc9
         rDyJgKPZzJR+V6eAMp6P9XTpbT10hx/9OwnLe36g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 124/175] s390/jump_label: print real address in a case of a jump label bug
Date:   Mon, 20 Sep 2021 18:42:53 +0200
Message-Id: <20210920163922.126705632@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 5492886c14744d239e87f1b0b774b5a341e755cc ]

In case of a jump label print the real address of the piece of code
where a mismatch was detected. This is right before the system panics,
so there is nothing revealed.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index 083b05f5f5ab..cbc187706648 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -43,7 +43,7 @@ static void jump_label_bug(struct jump_entry *entry, struct insn *expected,
 	unsigned char *ipe = (unsigned char *)expected;
 	unsigned char *ipn = (unsigned char *)new;
 
-	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Jump label code mismatch at %pS [%px]\n", ipc, ipc);
 	pr_emerg("Found:    %6ph\n", ipc);
 	pr_emerg("Expected: %6ph\n", ipe);
 	pr_emerg("New:      %6ph\n", ipn);
-- 
2.30.2



