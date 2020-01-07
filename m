Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABA8133209
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgAGVGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728973AbgAGVGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE8AE214D8;
        Tue,  7 Jan 2020 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431192;
        bh=33Bi1yVAAsVNi7Ev68V72KZgAWblLjCh7fQukOoLmBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcFKYwP5KR7UdVUSU5b0VLL2yY+ZDwLv7JyCGgSL+dqVsKdDfaEi7uKS8o0CeR7Cg
         91+INRUuscksuO8ju7seBxNaegi7k+h5l0LReidSzWPo48C9BRFaGJ4A3sWQawLXgb
         Uezn2VOjvjhoIgI3APN3GZS/Pu2qCshRM/QG22vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Sven Schnelle <svens@stackframe.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 071/115] tracing: Have the histogram compare functions convert to u64 first
Date:   Tue,  7 Jan 2020 21:54:41 +0100
Message-Id: <20200107205303.954455199@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 106f41f5a302cb1f36c7543fae6a05de12e96fa4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/tracing_map.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -148,8 +148,8 @@ static int tracing_map_cmp_atomic64(void
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


