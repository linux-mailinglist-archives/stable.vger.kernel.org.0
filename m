Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1B759E151
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355360AbiHWKnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355817AbiHWKkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:40:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0F513D40;
        Tue, 23 Aug 2022 02:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86C3DB81C85;
        Tue, 23 Aug 2022 09:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7421C433D6;
        Tue, 23 Aug 2022 09:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245703;
        bh=A4qmZ8TcNyB+XC5U6Vi3km4RklcqDpl7euHQej9m1wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPCuSHiumtuCwNevlZdkWxHDmGMxLq/4zNXSXvmTGhUufJ6SZ/XkYNGDxWvD4RrM/
         piKsO7SlZmyPOuFpX2dA0fY1qurAoHE+YhHVO/ZoLv0zLwjA9HsAWNjOMX8T9o/vv9
         2Ez/xuzdXckvP565qNqA+n+LEVxrs1HSU64fO6B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/287] kfifo: fix kfifo_to_user() return type
Date:   Tue, 23 Aug 2022 10:25:31 +0200
Message-Id: <20220823080106.174131336@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 045ed31e23aea840648c290dbde04797064960db ]

The kfifo_to_user() macro is supposed to return zero for success or
negative error codes.  Unfortunately, there is a signedness bug so it
returns unsigned int.  This only affects callers which try to save the
result in ssize_t and as far as I can see the only place which does that
is line6_hwdep_read().

TL;DR: s/_uint/_int/.

Link: https://lkml.kernel.org/r/YrVL3OJVLlNhIMFs@kili
Fixes: 144ecf310eb5 ("kfifo: fix kfifo_alloc() to return a signed int value")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kfifo.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 89fc8dc7bf38..ab9ff74818a4 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -629,7 +629,7 @@ __kfifo_uint_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_to_user(fifo, to, len, copied) \
-__kfifo_uint_must_check_helper( \
+__kfifo_int_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	void __user *__to = (to); \
-- 
2.35.1



