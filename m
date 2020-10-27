Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D729B471
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789380AbgJ0PCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789372AbgJ0PCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:02:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5367022284;
        Tue, 27 Oct 2020 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810920;
        bh=C7nuvz4TG+LNYVNN2IN49Nn4dau9vcjWBJL1Ux15x9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmCgKomSHZeBS8+fxYSejpnteoQwFIv9IYr4zJHso15PQeY0x9RiWFUpxsjq1J/0D
         6bYNu4F/rArKTdo4mQ/sRV0AreDG7D1L72hnoh/l06vCHO0hnw/40QykKhBlPsH9+0
         jYC+8hdp/qGERqFuC9VyF7/e6ww4zknQQxvbhCE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 308/633] tracing: Fix parse_synth_field() error handling
Date:   Tue, 27 Oct 2020 14:50:51 +0100
Message-Id: <20201027135537.125990296@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit 8fbeb52a598c7ab5aa603d6bb083b8a8d16d607a ]

synth_field_size() returns either a positive size or an error (zero or
a negative value). However, the existing code assumes the only error
value is 0. It doesn't handle negative error codes, as it assigns
directly to field->size (a size_t; unsigned), thereby interpreting the
error code as a valid size instead.

Do the test before assignment to field->size.

[ axelrasmussen@google.com: changelog addition, first paragraph above ]

Link: https://lkml.kernel.org/r/9b6946d9776b2eeb43227678158196de1c3c6e1d.1601848695.git.zanussi@kernel.org

Fixes: 4b147936fa50 (tracing: Add support for 'synthetic' events)
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_synth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index c6cca0d1d5840..46a96686e93c6 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -465,6 +465,7 @@ static struct synth_field *parse_synth_field(int argc, const char **argv,
 	struct synth_field *field;
 	const char *prefix = NULL, *field_type = argv[0], *field_name, *array;
 	int len, ret = 0;
+	ssize_t size;
 
 	if (field_type[0] == ';')
 		field_type++;
@@ -520,11 +521,12 @@ static struct synth_field *parse_synth_field(int argc, const char **argv,
 			field->type[len - 1] = '\0';
 	}
 
-	field->size = synth_field_size(field->type);
-	if (!field->size) {
+	size = synth_field_size(field->type);
+	if (size <= 0) {
 		ret = -EINVAL;
 		goto free;
 	}
+	field->size = size;
 
 	if (synth_field_is_string(field->type))
 		field->is_string = true;
-- 
2.25.1



