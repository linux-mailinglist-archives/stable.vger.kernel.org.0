Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB3314899B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391476AbgAXOTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391462AbgAXOTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C39F208C4;
        Fri, 24 Jan 2020 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875555;
        bh=42WkP/Rp3pK4A21HaZqFzJemGQbzr/tGytg8oylj2Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMaQbmP1p+qZ6HkvS0NFOau8Yo+Ojw73EMGx5FdSOQuL30c5sbzXn7dKJU/dcS0hk
         1aA1s0x2e0G7SmY+6Cz/cwroYKtM2QRDEzOZm8I48Hge4iAUeh4EnKXbNDDWOJTWl0
         kQzP2xfWXm8BhbENzgEAgOHyKXtLzHDHL+NeLmpI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 050/107] bpftool: Fix printing incorrect pointer in btf_dump_ptr
Date:   Fri, 24 Jan 2020 09:17:20 -0500
Message-Id: <20200124141817.28793-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 555089fdfc37ad65e0ee9b42ca40c238ff546f83 ]

For plain text output, it incorrectly prints the pointer value
"void *data".  The "void *data" is actually pointing to memory that
contains a bpf-map's value.  The intention is to print the content of
the bpf-map's value instead of printing the pointer pointing to the
bpf-map's value.

In this case, a member of the bpf-map's value is a pointer type.
Thus, it should print the "*(void **)data".

Fixes: 22c349e8db89 ("tools: bpftool: fix format strings and arguments for jsonw_printf()")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Link: https://lore.kernel.org/bpf/20200110231644.3484151-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index d66131f696892..397e5716ab6d8 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -26,7 +26,7 @@ static void btf_dumper_ptr(const void *data, json_writer_t *jw,
 			   bool is_plain_text)
 {
 	if (is_plain_text)
-		jsonw_printf(jw, "%p", data);
+		jsonw_printf(jw, "%p", *(void **)data);
 	else
 		jsonw_printf(jw, "%lu", *(unsigned long *)data);
 }
-- 
2.20.1

