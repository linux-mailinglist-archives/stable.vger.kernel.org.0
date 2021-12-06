Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB67B469E78
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385867AbhLFPjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379120AbhLFPgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9E9C08EAD3;
        Mon,  6 Dec 2021 07:22:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F2FB61309;
        Mon,  6 Dec 2021 15:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8442EC341C1;
        Mon,  6 Dec 2021 15:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804178;
        bh=zUkjN7PJzhgJDGKDKnFayycM0NFb+ezBoEzVh7L+66Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhfB+dvV/u8GWp69TktqjpJF16N/Bbp4g1b54xhaJfCkeorlpMtnK8jCv5cdp0Fwf
         jKpVCYJbOlZof666lTpfMAupqE9ujXgLZ5M/KOgqDyerMCG94xMEuFbxOfFdR5iJIV
         VUgbHxT9aWwQbYuAuMPpgyGjv8xbvYNKfRoMLX2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhangyue <zhangyue1@kylinos.cn>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 054/207] kprobes: Limit max data_size of the kretprobe instances
Date:   Mon,  6 Dec 2021 15:55:08 +0100
Message-Id: <20211206145612.111181799@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
@@ -154,6 +154,8 @@ struct kretprobe {
 	struct kretprobe_holder *rph;
 };
 
+#define KRETPROBE_MAX_DATA_SIZE	4096
+
 struct kretprobe_instance {
 	union {
 		struct freelist_node freelist;
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2006,6 +2006,9 @@ int register_kretprobe(struct kretprobe
 		}
 	}
 
+	if (rp->data_size > KRETPROBE_MAX_DATA_SIZE)
+		return -E2BIG;
+
 	rp->kp.pre_handler = pre_handler_kretprobe;
 	rp->kp.post_handler = NULL;
 


