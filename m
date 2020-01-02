Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CC12F130
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgABWPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgABWPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ECA024649;
        Thu,  2 Jan 2020 22:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003308;
        bh=yxRUl5bDgmXnUkV1HL7CmWXoxyfxMH8YtZWC+Kj8990=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGn9DkS/CEyiiJRW+2B+O86Dmf5+tPBra9b8B05Fk21wG5I6g8qUu/7gVZH+kfL8b
         g5xgOrHX/doO89rSpQ3eWfuxgdTMEhSAFT0Re3ZA7SkxpBWp1y/z4hRAIAiSTxqd+Z
         wqJYqYIbKBur0eDGNAbeg4hTQdpE+uofeVn+a8g8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/191] scripts/kallsyms: fix definitely-lost memory leak
Date:   Thu,  2 Jan 2020 23:06:28 +0100
Message-Id: <20200102215841.293332499@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ae6504d07fd6..fb15f09e0e38 100644
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



