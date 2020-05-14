Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED111D3C50
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgENSw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbgENSw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE8C207BB;
        Thu, 14 May 2020 18:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482376;
        bh=MlcSKljYgpljWuTEmbal7pi1lzXa0+HQgb/c7fOshqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evYAfMKkbXm3BtszFEzq/4CcopWluGbQRZUaxOy7s7XSytzG9rVNMzOBCtTQdxkXD
         PekUC8WeQlwwK8zpfyJu4qkHYJOYJiAL1SH4iJDl2Wt72Oa7wrjreUNMoQjUlnZM4s
         f6Lm8SU6/E35rDA9MbA+bRh6d2ET+sFamvyLyfLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aymeric Agon-Rambosson <aymeric.agon@yandex.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Jason Wessel <jason.wessel@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 53/62] scripts/gdb: repair rb_first() and rb_last()
Date:   Thu, 14 May 2020 14:51:38 -0400
Message-Id: <20200514185147.19716-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aymeric Agon-Rambosson <aymeric.agon@yandex.com>

[ Upstream commit 50e36be1fb9572b2e4f2753340bdce3116bf2ce7 ]

The current implementations of the rb_first() and rb_last() gdb
functions have a variable that references itself in its instanciation,
which causes the function to throw an error if a specific condition on
the argument is met.  The original author rather intended to reference
the argument and made a typo.  Referring the argument instead makes the
function work as intended.

Signed-off-by: Aymeric Agon-Rambosson <aymeric.agon@yandex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Jackie Liu <liuyun01@kylinos.cn>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: http://lkml.kernel.org/r/20200427051029.354840-1-aymeric.agon@yandex.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/rbtree.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/gdb/linux/rbtree.py b/scripts/gdb/linux/rbtree.py
index 39db889b874c9..c4b9916079178 100644
--- a/scripts/gdb/linux/rbtree.py
+++ b/scripts/gdb/linux/rbtree.py
@@ -12,7 +12,7 @@ rb_node_type = utils.CachedType("struct rb_node")
 
 def rb_first(root):
     if root.type == rb_root_type.get_type():
-        node = node.address.cast(rb_root_type.get_type().pointer())
+        node = root.address.cast(rb_root_type.get_type().pointer())
     elif root.type != rb_root_type.get_type().pointer():
         raise gdb.GdbError("Must be struct rb_root not {}".format(root.type))
 
@@ -28,7 +28,7 @@ def rb_first(root):
 
 def rb_last(root):
     if root.type == rb_root_type.get_type():
-        node = node.address.cast(rb_root_type.get_type().pointer())
+        node = root.address.cast(rb_root_type.get_type().pointer())
     elif root.type != rb_root_type.get_type().pointer():
         raise gdb.GdbError("Must be struct rb_root not {}".format(root.type))
 
-- 
2.20.1

