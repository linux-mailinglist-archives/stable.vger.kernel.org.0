Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADBB259718
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731426AbgIAQKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731391AbgIAPiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E42220E65;
        Tue,  1 Sep 2020 15:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974688;
        bh=oTjC9jfaLqaZgNMzxkpn5Xgk4LZV2PW+EeOGjegi/zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yl6BC8DZp1TErz3osVJr9xSHxuyTGiQKyn/2O53+D8ETQ7LwLkSHVdahnYXoANRTe
         JA+yllBT37Jl0y1x4m8zzy+yM5l6WxxTTf2npci+5T1GTXZdSOM7fv/wSwAMTbDmLJ
         Ywy0Hfi9wS5Lx2hrycgPWCYwgyh5nz5jjCA0eoc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Popov <alex.popov@linux.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 016/255] gcc-plugins/stackleak: Dont instrument itself
Date:   Tue,  1 Sep 2020 17:07:52 +0200
Message-Id: <20200901151001.568883262@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



