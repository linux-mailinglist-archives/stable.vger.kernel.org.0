Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 348C4797B5
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390471AbfG2TtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390478AbfG2TtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:49:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 401332171F;
        Mon, 29 Jul 2019 19:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429747;
        bh=0K6RHdAK4FBoesDM4xqngRUIE526J2Hk2OhVGo0EqLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZ4h28bWIAHZ3n5MjD8ZkGqW1Eg2Jc848Hq214RptRXfmCD1d4EjVUleDb9j+qOAb
         5mbTPX2S6VKyRsabpqXrOJJiHoZ39rgwRJ7LV3Xm7tZlIJQYt3EwxKpwuE2/vhD11X
         BQwDwWbj3Bh8MOswE2s/hc8hsl7wHDijlHjdEycE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 083/215] net/ipv4: fib_trie: Avoid cryptic ternary expressions
Date:   Mon, 29 Jul 2019 21:21:19 +0200
Message-Id: <20190729190753.998851246@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



