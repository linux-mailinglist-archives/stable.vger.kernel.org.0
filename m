Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA3417317
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344372AbhIXMyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343934AbhIXMvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38CE761241;
        Fri, 24 Sep 2021 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487731;
        bh=dBWPLmhRUuP5AbnOzWV1uHPFnyYPfDzVu8Tw6gvHBWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mONjWIGl/azURAhMItPNLeCMXgfARGQzGzxG7JAAaZ08NB4kUMtFo5AN6hx4v/38o
         BxZdcgj64Wjld8SY4gwIELQY1Bfsw+JMhF7F0pgLqnA++T9J3AaG4Yrc6/PeLAd5ip
         uonguEIsznXX7LFU/surqDXxV+pOja6Z/aU+NM0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 4.19 06/34] tracing/kprobe: Fix kprobe_on_func_entry() modification
Date:   Fri, 24 Sep 2021 14:44:00 +0200
Message-Id: <20210924124330.173774576@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

The commit 960434acef37 ("tracing/kprobe: Fix to support kretprobe
events on unloaded modules") backport from v5.11, which modifies the
return value of kprobe_on_func_entry(). However, there is no adaptation
modification in create_trace_kprobe(), resulting in the exact opposite
behavior. Now we need to return an error immediately only if
kprobe_on_func_entry() returns -EINVAL.

Fixes: 960434acef37 ("tracing/kprobe: Fix to support kretprobe events on unloaded modules")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -836,8 +836,9 @@ static int create_trace_kprobe(int argc,
 			pr_info("Failed to parse either an address or a symbol.\n");
 			return ret;
 		}
+		/* Defer the ENOENT case until register kprobe */
 		if (offset && is_return &&
-		    !kprobe_on_func_entry(NULL, symbol, offset)) {
+		    kprobe_on_func_entry(NULL, symbol, offset) == -EINVAL) {
 			pr_info("Given offset is not valid for return probe.\n");
 			return -EINVAL;
 		}


