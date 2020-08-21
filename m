Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93CC24DDAF
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgHURVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgHUQQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:16:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46F0422B40;
        Fri, 21 Aug 2020 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026562;
        bh=qPyHyNfco18mQTkDq3vxRcTyVpTFndICNo8YCySJlHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZwhmzC+GcAymoCje5uQjp7Znzwjzc9Yup67Dqc9oSz8laUb6c5n8V1ytgg5M7DXn
         9dq8ut69GdQzi5ImTWP0hlahJ6e5Vr4p6upXQlO/j94i0UW1PevNW3PgGQFZ0GVblF
         3qforLpC38mnZ7tyDZEHKBenfmPzhRISpW6seeDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Popov <alex.popov@linux.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 14/61] gcc-plugins/stackleak: Don't instrument itself
Date:   Fri, 21 Aug 2020 12:14:58 -0400
Message-Id: <20200821161545.347622-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
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
index 4cb4130ced329..d372134ac9ec1 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_RSEQ) += rseq.o
 
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
 
+CFLAGS_stackleak.o += $(DISABLE_STACKLEAK_PLUGIN)
 obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
 KASAN_SANITIZE_stackleak.o := n
 KCOV_INSTRUMENT_stackleak.o := n
-- 
2.25.1

