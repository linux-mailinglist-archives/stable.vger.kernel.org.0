Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6977811AF91
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbfLKPNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbfLKPNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 268E624671;
        Wed, 11 Dec 2019 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077231;
        bh=V3W/It5zf+Qc9Qam9DLjUxFvJ61pLPbxIY3M6si2UcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0zkgNEGSpPkUVhaf70PZKATow9zLpJHeVNu63NNoaIXnZ5mL3lHym+FAzsor3dAs
         D4IDT24vlOtaLyeVi4keV8L8xmgAmnaVRUzQ84q2C+mSMNOVHCkKHekqcgndC2+IsQ
         2a8VbQo4HBG5S8n53Tchouf9LOWR/bv3q4Ek29II=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 110/134] scripts/kallsyms: fix definitely-lost memory leak
Date:   Wed, 11 Dec 2019 10:11:26 -0500
Message-Id: <20191211151150.19073-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 21915eca088dc271c970e8351290e83d938114ac ]

build_initial_tok_table() overwrites unused sym_entry to shrink the
table size. Before the entry is overwritten, table[i].sym must be freed
since it is malloc'ed data.

This fixes the 'definitely lost' report from valgrind. I ran valgrind
against x86_64_defconfig of v5.4-rc8 kernel, and here is the summary:

[Before the fix]

  LEAK SUMMARY:
     definitely lost: 53,184 bytes in 2,874 blocks

[After the fix]

  LEAK SUMMARY:
     definitely lost: 0 bytes in 0 blocks

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kallsyms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ae6504d07fd61..fb15f09e0e38c 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -489,6 +489,8 @@ static void build_initial_tok_table(void)
 				table[pos] = table[i];
 			learn_symbol(table[pos].sym, table[pos].len);
 			pos++;
+		} else {
+			free(table[i].sym);
 		}
 	}
 	table_cnt = pos;
-- 
2.20.1

