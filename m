Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3611F2D71
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbgFIAdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729921AbgFHXOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C11FA216FD;
        Mon,  8 Jun 2020 23:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658092;
        bh=REDsuEysCkGozpy/tAflcxRA3nXs5g++jF7F2KLZaHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyB+LWtf2Wpc9hQKGLhZ9l6PSY/3eoHvzFsN+ZQgd0J8H5NGtbXLpPFUj7q3YKxD/
         uLQYyx9Z6Mr6ElAm710/3J+zo1t9i2RX38LTRb5zzGYxvEwiM60Ijt+zGkNAKaR559
         IDItDmr2HEFmB9DHVW/X9gDzMh+TwOHUVk2pAlyY=
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
Subject: [PATCH AUTOSEL 5.6 134/606] scripts/gdb: repair rb_first() and rb_last()
Date:   Mon,  8 Jun 2020 19:04:19 -0400
Message-Id: <20200608231211.3363633-134-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
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
index 39db889b874c..c4b991607917 100644
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
2.25.1

