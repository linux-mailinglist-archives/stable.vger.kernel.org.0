Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F233F469B85
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358271AbhLFPRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347453AbhLFPOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5338EC0698D5;
        Mon,  6 Dec 2021 07:07:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F179B810E7;
        Mon,  6 Dec 2021 15:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6690EC341C1;
        Mon,  6 Dec 2021 15:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803256;
        bh=qHA3pse0aJpPJ8bg2NKqEmnqjVvguuq1LWSl+GxzR1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkidqR15FQDPdE215CnL6HK8TR4eN7EDjqOZaM0fmbPjDOPdVakSkJ5IYMa+DcQeh
         FvmHZLfowYNMef+bLkGyPZTjwbLTYGEWiP3qoVoZQ6vB/Aqz6ISQXAPSfQ87CDzVXC
         Lr3Wr0GrHTyzUSWKlzGqzMRVQ9ejUCLICxIoR9W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhangyue <zhangyue1@kylinos.cn>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 084/106] kprobes: Limit max data_size of the kretprobe instances
Date:   Mon,  6 Dec 2021 15:56:32 +0100
Message-Id: <20211206145558.419381527@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
@@ -193,6 +193,8 @@ struct kretprobe {
 	raw_spinlock_t lock;
 };
 
+#define KRETPROBE_MAX_DATA_SIZE	4096
+
 struct kretprobe_instance {
 	struct hlist_node hlist;
 	struct kretprobe *rp;
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2004,6 +2004,9 @@ int register_kretprobe(struct kretprobe
 		}
 	}
 
+	if (rp->data_size > KRETPROBE_MAX_DATA_SIZE)
+		return -E2BIG;
+
 	rp->kp.pre_handler = pre_handler_kretprobe;
 	rp->kp.post_handler = NULL;
 	rp->kp.fault_handler = NULL;


