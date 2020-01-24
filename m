Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45361148290
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388580AbgAXL3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404066AbgAXL3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:11 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03C120704;
        Fri, 24 Jan 2020 11:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865350;
        bh=JisEXm0TUh55h7GUN8hs6vvZy75I/g9W1srvuez+k60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBdLH8lyJ8C0MfMe2yOL+z4Eok0Gb1GQVauJOVdN13QYb0+hSp8Ndgk/x1eWUD4iJ
         hzlb5bcgleuhUbKwzhiKYPzCeqyMMucQsKWRgap3AwNjMwnVfF1FfyJizB99ZiYgQa
         EAx/Q/pnqNMYbdCYu5UPLQuohJQEWhuBrNnwOlME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 509/639] tools: bpftool: fix format strings and arguments for jsonw_printf()
Date:   Fri, 24 Jan 2020 10:31:19 +0100
Message-Id: <20200124093152.542796676@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit 22c349e8db89df86804d3ba23cef037ccd44a8bf ]

There are some mismatches between format strings and arguments passed to
jsonw_printf() in the BTF dumper for bpftool, which seems harmless but
may result in warnings if the "__printf()" attribute is used correctly
for jsonw_printf(). Let's fix relevant format strings and type cast.

Fixes: b12d6ec09730 ("bpf: btf: add btf print functionality")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index e4e6e2b3fd847..ff0cc3c171411 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -26,9 +26,9 @@ static void btf_dumper_ptr(const void *data, json_writer_t *jw,
 			   bool is_plain_text)
 {
 	if (is_plain_text)
-		jsonw_printf(jw, "%p", *(unsigned long *)data);
+		jsonw_printf(jw, "%p", data);
 	else
-		jsonw_printf(jw, "%u", *(unsigned long *)data);
+		jsonw_printf(jw, "%lu", *(unsigned long *)data);
 }
 
 static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
@@ -129,7 +129,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 	switch (BTF_INT_ENCODING(*int_type)) {
 	case 0:
 		if (BTF_INT_BITS(*int_type) == 64)
-			jsonw_printf(jw, "%lu", *(__u64 *)data);
+			jsonw_printf(jw, "%llu", *(__u64 *)data);
 		else if (BTF_INT_BITS(*int_type) == 32)
 			jsonw_printf(jw, "%u", *(__u32 *)data);
 		else if (BTF_INT_BITS(*int_type) == 16)
@@ -142,7 +142,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 		break;
 	case BTF_INT_SIGNED:
 		if (BTF_INT_BITS(*int_type) == 64)
-			jsonw_printf(jw, "%ld", *(long long *)data);
+			jsonw_printf(jw, "%lld", *(long long *)data);
 		else if (BTF_INT_BITS(*int_type) == 32)
 			jsonw_printf(jw, "%d", *(int *)data);
 		else if (BTF_INT_BITS(*int_type) == 16)
-- 
2.20.1



