Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7FB2C0983
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388649AbgKWNIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732850AbgKWMsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 670BE20888;
        Mon, 23 Nov 2020 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135710;
        bh=K4QyVoNnllLtRru6GQBzKjCXb2dKaUP7i8gT6OpILvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSlsuA9N9MtPNMQrgNhPf9kpGChBncOLT1HB9UcAgdhG3HD+Dv4L6SEGtDPxIj16C
         P80nkdMAHimBdop1ruoTnrOBjAsOPxTcKENp2r0P9pUXu+bXj9umhFmdLaHO7ixdNr
         zrDvBzwpLLpR5rXcytP+7WpXPSjZqiK9v+mDjrJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 167/252] libbpf: Fix VERSIONED_SYM_COUNT number parsing
Date:   Mon, 23 Nov 2020 13:21:57 +0100
Message-Id: <20201123121843.652172408@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 1fd6cee127e2ddff36d648573d7566aafb0d0b77 ]

We remove "other info" from "readelf -s --wide" output when
parsing GLOBAL_SYM_COUNT variable, which was added in [1].
But we don't do that for VERSIONED_SYM_COUNT and it's failing
the check_abi target on powerpc Fedora 33.

The extra "other info" wasn't problem for VERSIONED_SYM_COUNT
parsing until commit [2] added awk in the pipe, which assumes
that the last column is symbol, but it can be "other info".

Adding "other info" removal for VERSIONED_SYM_COUNT the same
way as we did for GLOBAL_SYM_COUNT parsing.

[1] aa915931ac3e ("libbpf: Fix readelf output parsing for Fedora")
[2] 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")

Fixes: 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20201118211350.1493421-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 9ae8f4ef0aac2..8bf2c406b0e05 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -152,6 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
+			      sed 's/\[.*\]//' | \
 			      awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
@@ -220,6 +221,7 @@ check_abi: $(OUTPUT)libbpf.so
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf --dyn-syms --wide $(OUTPUT)libbpf.so |		 \
+		    sed 's/\[.*\]//' |					 \
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
 		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
-- 
2.27.0



