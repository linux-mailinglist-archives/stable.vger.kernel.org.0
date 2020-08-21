Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BB424DE4A
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgHUR2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgHUQOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:14:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD2CF22BED;
        Fri, 21 Aug 2020 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026481;
        bh=oTjC9jfaLqaZgNMzxkpn5Xgk4LZV2PW+EeOGjegi/zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RIaFJ1sLf2LhZGIIxhVAZE43Oo+KLH/eXBni4hxHTs4TEPJ5xS78wEd1EiAT5vZT
         kZYNaLu4yZW2BhqiisiD6qXrJ2Fs7zQUpujmBoFwQkZvOvB0nHdadbrjWqZm229rV+
         suar4PQUpuocamw5ATaSA9TmG5F8IeOpyK4OfJug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Popov <alex.popov@linux.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 14/62] gcc-plugins/stackleak: Don't instrument itself
Date:   Fri, 21 Aug 2020 12:13:35 -0400
Message-Id: <20200821161423.347071-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Popov <alex.popov@linux.com>

[ Upstream commit 005e696df65d0ff90468ecf38a50aa584dc82421 ]

There is no need to try instrumenting functions in kernel/stackleak.c.
Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
is disabled.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Link: https://lore.kernel.org/r/20200624123330.83226-2-alex.popov@linux.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index f3218bc5ec69f..155b5380500ad 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -125,6 +125,7 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue.o
 
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
 
+CFLAGS_stackleak.o += $(DISABLE_STACKLEAK_PLUGIN)
 obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
 KASAN_SANITIZE_stackleak.o := n
 KCSAN_SANITIZE_stackleak.o := n
-- 
2.25.1

