Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128CBEED6F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbfKDWGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389987AbfKDWGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:38 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B0AB217F4;
        Mon,  4 Nov 2019 22:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905198;
        bh=Odrr+zmNdI6AN052yBovEOwzEQZbeXlYtg8noSwp/dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBEGQbzvmAC3VSHCB0j6IlYYqYKWTNmU1B/WpkVzQ16RG7TC8wLiigmJzLg9nukno
         E8jpTDEHdPiPpjrLxoLb9i/I4Iac/DdXYOgEmy6AYcyR5JqK1QhzPMEbOTKSle/y5r
         ZJ3rX0LujiAXDoXKIY7pRm/JXUJCL/pQ/G33OorU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 063/163] arm64: armv8_deprecated: Checking return value for memory allocation
Date:   Mon,  4 Nov 2019 22:44:13 +0100
Message-Id: <20191104212144.594404107@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



