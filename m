Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2251EDD45C
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfJRWEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbfJRWEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF5B2246B;
        Fri, 18 Oct 2019 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436285;
        bh=Odrr+zmNdI6AN052yBovEOwzEQZbeXlYtg8noSwp/dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NASvWmS9Tu0L/UrZlxFPE0N1xQB3aCJoCn8Hd6wd08mu2VxoUSJuKJTyCQd/4YK2q
         nqNMbgzqpcmQcGMWDX2Si4cv5Ghp03WUz0j1OBRo+kVnDN4yeXT7bxT2v55dpyB9le
         5QM+Fv7AXo6lhIkHYyFRb6SncFtRpft1OG7ZbXiE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfeng Ye <yeyunfeng@huawei.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 61/89] arm64: armv8_deprecated: Checking return value for memory allocation
Date:   Fri, 18 Oct 2019 18:02:56 -0400
Message-Id: <20191018220324.8165-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 3e7c93bd04edfb0cae7dad1215544c9350254b8f ]

There are no return value checking when using kzalloc() and kcalloc() for
memory allocation. so add it.

Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/armv8_deprecated.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index 2ec09debc2bb1..ca158be21f833 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -174,6 +174,9 @@ static void __init register_insn_emulation(struct insn_emulation_ops *ops)
 	struct insn_emulation *insn;
 
 	insn = kzalloc(sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return;
+
 	insn->ops = ops;
 	insn->min = INSN_UNDEF;
 
@@ -233,6 +236,8 @@ static void __init register_insn_emulation_sysctl(void)
 
 	insns_sysctl = kcalloc(nr_insn_emulated + 1, sizeof(*sysctl),
 			       GFP_KERNEL);
+	if (!insns_sysctl)
+		return;
 
 	raw_spin_lock_irqsave(&insn_emulation_lock, flags);
 	list_for_each_entry(insn, &insn_emulation, node) {
-- 
2.20.1

