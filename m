Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53026DA23
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfGSD7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbfGSD7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD5D218A6;
        Fri, 19 Jul 2019 03:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508778;
        bh=WWiRGUwXypUjI0ab0plnKjXWJt7EYhDzkrUQgknLJxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lG41vMUR/3ZUX8X+ePfCgD32jLqXXiV4EdQsi7CLfTA6WX/gajnmxBBSXbvWbPnX
         Apj2tX8T1GMngAGN9AY2qzm3AQMNR1RLJi8UYECPdmt97wScdD+sMvvEWeb6p7HBHz
         VxXuRZk8xy++gbLBOQnkBTyuyVtVKal5UAp8woPs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.2 085/171] net/ipv4: fib_trie: Avoid cryptic ternary expressions
Date:   Thu, 18 Jul 2019 23:55:16 -0400
Message-Id: <20190719035643.14300-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit 25cec756891e8733433efea63b2254ddc93aa5cc ]

empty_child_inc/dec() use the ternary operator for conditional
operations. The conditions involve the post/pre in/decrement
operator and the operation is only performed when the condition
is *not* true. This is hard to parse for humans, use a regular
'if' construct instead and perform the in/decrement separately.

This also fixes two warnings that are emitted about the value
of the ternary expression being unused, when building the kernel
with clang + "kbuild: Remove unnecessary -Wno-unused-value"
(https://lore.kernel.org/patchwork/patch/1089869/):

CC      net/ipv4/fib_trie.o
net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
        ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;

Fixes: 95f60ea3e99a ("fib_trie: Add collapse() and should_collapse() to resize")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.extrawarn | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 3ab8d1a303cd..b293246e48fe 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -68,7 +68,6 @@ else
 
 ifdef CONFIG_CC_IS_CLANG
 KBUILD_CFLAGS += -Wno-initializer-overrides
-KBUILD_CFLAGS += -Wno-unused-value
 KBUILD_CFLAGS += -Wno-format
 KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-format-zero-length
-- 
2.20.1

