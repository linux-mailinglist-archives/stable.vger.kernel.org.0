Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5338128BA6
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 22:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfLUVLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 16:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfLUVLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 16:11:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3373A206D3;
        Sat, 21 Dec 2019 21:11:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1iim29-000o1t-Aw; Sat, 21 Dec 2019 16:11:33 -0500
Message-Id: <20191221211133.208525022@goodmis.org>
User-Agent: quilt/0.65
Date:   Sat, 21 Dec 2019 16:11:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Sven Schnelle <svens@stackframe.org>
Subject: [for-linus][PATCH 2/5] tracing: Have the histogram compare functions convert to u64 first
References: <20191221211106.338673631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The compare functions of the histogram code would be specific for the size
of the value being compared (byte, short, int, long long). It would
reference the value from the array via the type of the compare, but the
value was stored in a 64 bit number. This is fine for little endian
machines, but for big endian machines, it would end up comparing zeros or
all ones (depending on the sign) for anything but 64 bit numbers.

To fix this, first derference the value as a u64 then convert it to the type
being compared.

Link: http://lkml.kernel.org/r/20191211103557.7bed6928@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 08d43a5fa063e ("tracing: Add lock-free tracing_map")
Acked-by: Tom Zanussi <zanussi@kernel.org>
Reported-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/tracing_map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/tracing_map.c b/kernel/trace/tracing_map.c
index 9a1c22310323..9e31bfc818ff 100644
--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -148,8 +148,8 @@ static int tracing_map_cmp_atomic64(void *val_a, void *val_b)
 #define DEFINE_TRACING_MAP_CMP_FN(type)					\
 static int tracing_map_cmp_##type(void *val_a, void *val_b)		\
 {									\
-	type a = *(type *)val_a;					\
-	type b = *(type *)val_b;					\
+	type a = (type)(*(u64 *)val_a);					\
+	type b = (type)(*(u64 *)val_b);					\
 									\
 	return (a > b) ? 1 : ((a < b) ? -1 : 0);			\
 }
-- 
2.24.0


