Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637DB133433
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgAGVYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbgAGVAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2883F2087F;
        Tue,  7 Jan 2020 21:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430843;
        bh=rjfiq6c//nGl2IPh016mKpsk1jDqtQkxkkZfg1r3eVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6nTYgSXRP/MG5YXW7V5nHKC5d9oZ3/K9/KiS3jdqAD53yUh1ue03S3dIZwKkm2V+
         JCu91bHTDVfp/znImIZRh52ZSPfgcIYkQLocWDqi1NREj0iRIpFeq2ZIi7FuNMkYY2
         gfAICVX7OltAyPXymMAEqLBQRdMqH4LBqvvrJcuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 118/191] tracing: Fix endianness bug in histogram trigger
Date:   Tue,  7 Jan 2020 21:53:58 +0100
Message-Id: <20200107205339.295739293@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit fe6e096a5bbf73a142f09c72e7aa2835026eb1a3 upstream.

At least on PA-RISC and s390 synthetic histogram triggers are failing
selftests because trace_event_raw_event_synth() always writes a 64 bit
values, but the reader expects a field->size sized value. On little endian
machines this doesn't hurt, but on big endian this makes the reader always
read zero values.

Link: http://lore.kernel.org/linux-trace-devel/20191218074427.96184-4-svens@linux.ibm.com

Cc: stable@vger.kernel.org
Fixes: 4b147936fa509 ("tracing: Add support for 'synthetic' events")
Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_hist.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -911,7 +911,26 @@ static notrace void trace_event_raw_even
 			strscpy(str_field, str_val, STR_VAR_LEN_MAX);
 			n_u64 += STR_VAR_LEN_MAX / sizeof(u64);
 		} else {
-			entry->fields[n_u64] = var_ref_vals[var_ref_idx + i];
+			struct synth_field *field = event->fields[i];
+			u64 val = var_ref_vals[var_ref_idx + i];
+
+			switch (field->size) {
+			case 1:
+				*(u8 *)&entry->fields[n_u64] = (u8)val;
+				break;
+
+			case 2:
+				*(u16 *)&entry->fields[n_u64] = (u16)val;
+				break;
+
+			case 4:
+				*(u32 *)&entry->fields[n_u64] = (u32)val;
+				break;
+
+			default:
+				entry->fields[n_u64] = val;
+				break;
+			}
 			n_u64++;
 		}
 	}


