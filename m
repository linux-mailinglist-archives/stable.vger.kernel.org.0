Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B814F499FAB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841998AbiAXXAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835934AbiAXWhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9B5C02B871;
        Mon, 24 Jan 2022 12:59:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D67E612E9;
        Mon, 24 Jan 2022 20:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BCEC340E5;
        Mon, 24 Jan 2022 20:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057993;
        bh=Awjc1r/8AS2b08K/MPXxdKLbb1VLsp2k2khdbnO2o44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrBTqfhcUQz28eMRefPkliTE6ZC9NJXM5zyF/QNmx9zIz3IMN6iGU8Yu47w5Ouw7p
         ZG9EOWHqQgBcrMnXCZ9IGCO8RDsCTqr1jDRr0GPA2iJIk4A0wHaBrJl0d9OshlbG8C
         +2O4CTD0Uamx24HTRzsbhkqyuKH44UkKF9h8eMoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0146/1039] kernel/locking: Use a pointer in ww_mutex_trylock().
Date:   Mon, 24 Jan 2022 19:32:15 +0100
Message-Id: <20220124184130.078742854@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 2202e15b2b1a946ce760d96748cd7477589701ab ]

mutex_acquire_nest() expects a pointer, pass the pointer.

Fixes: 12235da8c80a1 ("kernel/locking: Add context to ww_mutex_trylock()")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211104122706.frk52zxbjorso2kv@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/ww_rt_mutex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/ww_rt_mutex.c b/kernel/locking/ww_rt_mutex.c
index 0e00205cf467a..d1473c624105c 100644
--- a/kernel/locking/ww_rt_mutex.c
+++ b/kernel/locking/ww_rt_mutex.c
@@ -26,7 +26,7 @@ int ww_mutex_trylock(struct ww_mutex *lock, struct ww_acquire_ctx *ww_ctx)
 
 	if (__rt_mutex_trylock(&rtm->rtmutex)) {
 		ww_mutex_set_context_fastpath(lock, ww_ctx);
-		mutex_acquire_nest(&rtm->dep_map, 0, 1, ww_ctx->dep_map, _RET_IP_);
+		mutex_acquire_nest(&rtm->dep_map, 0, 1, &ww_ctx->dep_map, _RET_IP_);
 		return 1;
 	}
 
-- 
2.34.1



