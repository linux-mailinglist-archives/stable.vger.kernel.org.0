Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C491D469AA4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346275AbhLFPJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:09:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40458 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346773AbhLFPHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:07:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B78BB8111A;
        Mon,  6 Dec 2021 15:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF81C341C1;
        Mon,  6 Dec 2021 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803028;
        bh=8i0G+mKv+8hK5jKrWdU1ehMSo8gzobZK8Hcj50uckMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCT2Uq01F9DFZJpKArU6WcYD2qLRzyupAA9F2BcuCVrzpsCiyPmDvypPP4JwLE5il
         Q9FftcDZrCXBKjV0Re3xfOzii8igtinX78p9XLhkRJdN6Bx9vXMVD25z9svql+ajHY
         lvyg4fDwwKLUedgPeLufgBuWm5zZ45D8szQT+vT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhangyue <zhangyue1@kylinos.cn>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 49/62] kprobes: Limit max data_size of the kretprobe instances
Date:   Mon,  6 Dec 2021 15:56:32 +0100
Message-Id: <20211206145550.902607157@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 6bbfa44116689469267f1a6e3d233b52114139d2 upstream.

The 'kprobe::data_size' is unsigned, thus it can not be negative.  But if
user sets it enough big number (e.g. (size_t)-8), the result of 'data_size
+ sizeof(struct kretprobe_instance)' becomes smaller than sizeof(struct
kretprobe_instance) or zero. In result, the kretprobe_instance are
allocated without enough memory, and kretprobe accesses outside of
allocated memory.

To avoid this issue, introduce a max limitation of the
kretprobe::data_size. 4KB per instance should be OK.

Link: https://lkml.kernel.org/r/163836995040.432120.10322772773821182925.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: f47cd9b553aa ("kprobes: kretprobe user entry-handler")
Reported-by: zhangyue <zhangyue1@kylinos.cn>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kprobes.h |    2 ++
 kernel/kprobes.c        |    3 +++
 2 files changed, 5 insertions(+)

--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -192,6 +192,8 @@ struct kretprobe {
 	raw_spinlock_t lock;
 };
 
+#define KRETPROBE_MAX_DATA_SIZE	4096
+
 struct kretprobe_instance {
 	struct hlist_node hlist;
 	struct kretprobe *rp;
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1899,6 +1899,9 @@ int register_kretprobe(struct kretprobe
 		}
 	}
 
+	if (rp->data_size > KRETPROBE_MAX_DATA_SIZE)
+		return -E2BIG;
+
 	rp->kp.pre_handler = pre_handler_kretprobe;
 	rp->kp.post_handler = NULL;
 	rp->kp.fault_handler = NULL;


